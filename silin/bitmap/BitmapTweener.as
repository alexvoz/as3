/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.bitmap
{

	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import silin.filters.*;
	
	/**
	 * генерится по заврешении загрузки и смены картинки
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")] 
	
	/**
	 * генерится при ошибке(невозможности) загрузки
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")] 
	
	/**
	 * генерится в процессе загрузки
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name = "progress", type = "flash.events.IOErrorEvent")] 
	
	/**
	 * класс для загрузки/смены битмапов с рядом эффектов
	 * @author silin
	 * @langversion 3.0
     * @playerversion 9.0.115
	 */
	public class BitmapTweener extends Sprite
	{
		//эффекты смены
		public static const NONE:String = "none";
		public static const RANDOM:String = "random";
		public static const ALPHA:String = "alpha";
		public static const BLUR:String = "blur";
		public static const PIXEL:String = "pixel";
		public static const PLASTIC:String = "plastic";
		public static const RIPPLE:String = "ripple";
		public static const SWIRL_IN:String = "swirlIn";
		public static const SWIRL_OUT:String = "swirlOut";
		public static const SHOCK:String = "shock";
		public static const FLOW:String = "flow";
		public static const OVAL:String = "oval";
		//public static const CHAOS:String = "chaos";
		/**
		 * список эффектов
		 */
		public static const EFFECTS:Array = [NONE, RANDOM, PLASTIC, ALPHA, BLUR, PIXEL,  RIPPLE, SWIRL_IN, SWIRL_OUT, SHOCK, FLOW, OVAL/*, CHAOS*/];
		private const ORIGIN:Point = new Point();
		/**
		 * величина блура (для BLUR)
		 */
		public var maxBlurSize:int = 64;
		/**
		 * размер ячейки (для PLASTIC)
		 */
		public var plasticCellSize:int = 30;
		/**
		 * разброс болтанки (для SHOCK)
		 */
		public var maxShockSize:int = 48;
		/**
		 * число сегментов/разбиений (для FLOW)
		 */
		public var flowSegments:int = 2;
		//public var chaosCellSize:int = 64;
		
		/**
		 * надо ли кешировать загруженные картинки
		 */
		public var allowCaching:Boolean = true;
		/**
		 * будет ли следующая проявляться с альфой, акутально для картинок с прозрачностью
		 */
		public var applyAlphaToNext:Boolean = false;
		
		private var _noSwap:Boolean = false;

		private var _bitmap:Bitmap = new Bitmap();
		private var _width:int;
		private var _height:int;

		private var _nextBmd:BitmapData;
		private var _prevBmd:BitmapData;

		private var _pos:Number = 0;
		private var _step:Number = 0.02;
		private var _mode:String = NONE;
		private var _currEffect:String;//нужен только чтоб реализовать RANDOM
		private var _pixelSeed:int = 0;
		private var _pixelsPerStep:int = 0;
		private var _alphaTrig:Number;

		//filters
		private var _plastic:PerlinMap;
		private var _ripple:RippleMap;
		private var _swirl:SwirlMap;
		private var _smudge:SmudgeMap;

		//alpha mask assets
		private var _maskShape:Shape=new Shape();
		private var _maskColors:Array = [0, 0];
		private var _maskAlphas:Array = [0, 1];
		private var _maskRatios:Array = [0, 0xFF];
		private var _maskMtrx:Matrix=new Matrix();
		private var _maskBmd:BitmapData;

		private var _loader:Loader = new Loader();
		private var _preloader:DisplayObject;

		private var _cache:Object = { };
		private var _currUrl:String;
		private var _randomList:Array = EFFECTS.slice(2);

		/**
		 * constructor
		 * @param	width		ширина
		 * @param	height		высота
		 * @param	mode		эффект
		 */
		public function BitmapTweener(width:int, height:int,  mode:String = NONE)
		{

			_mode = mode;
			_width = width;
			_height = height;
			_bitmap.bitmapData = new BitmapData(width, height, true, 0);
			_bitmap.smoothing = true;

			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);

			//debug
			//var t:int = getTimer();
			//создаем все карты сразу, немного пыхтит, но приемлимо
			//TODO: создавать при первом обращении и/или спецМетод инициализации всех

			_plastic = new PerlinMap(_width, _height);
			_plastic.cellSize = plasticCellSize;
			_plastic.filter.mode = DisplacementMapFilterMode.IGNORE;

			_swirl = new SwirlMap(_width, _height);
			_swirl.reverse();//невнятно-шаманское преобразование, но эффект забавный

			_ripple = new RippleMap(_width, _height);

			_smudge = new SmudgeMap(_width, _height);
			_smudge.size = width / flowSegments;

			//debug
			//var dt:int = getTimer() - t;
			//trace( "dt : " + dt );
			addChild(_bitmap);

		}

		private function onLoadProgress(evnt:ProgressEvent):void
		{
			//загрубляем цветность (безконтрольно - как пролучится..)
			var satMtrx:ColorAdjust = new ColorAdjust();
			satMtrx.saturation(0.975);
			_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, satMtrx.filter);
			dispatchEvent(evnt);

		}

		private function onLoadComplete(evnt:Event):void
		{
			
			//срисовывем контент
			var bmd:BitmapData = new BitmapData(_width, _height, true, 0);
			bmd.draw(_loader);
			if (_noSwap)
			{
				_bitmap.bitmapData = bmd;
			}else
			{
				//запускаем твин
				swap(bmd);
			}
			
			//кладем в кэш
			if (allowCaching)
			{
				_cache[_currUrl] = bmd;
			}

			//прячем прелоадер
			if (_preloader && _preloader.parent) removeChild(_preloader);

		}

		private function onLoadError(event:IOErrorEvent):void
		{
			//прячем прелоадер
			if (_preloader && _preloader.parent) removeChild(_preloader);
			dispatchEvent(event);
		}
		/**
		 * грузит картинку из указанного урл
		 * @param	url
		 */
		public function load(url:String):void
		{
			_noSwap = true;
			if (_cache[url])//если есть в кеше, то запускаем твин
			{
				_bitmap.bitmapData = _cache[url];
			}else
			{
				//сохраняем урл, чтобы можно было сохранить в кеше
				_currUrl = url;
				//стартуем загрузку
				_loader.load(new URLRequest(url));
				if (_preloader)
				{
					addChild(_preloader);
				}
			}
		}
		
		/**
		 * грузит (если нет в кеше) картинку, по завершении загрузки запускает смену
		 * @param	url
		 */
		public function loadAndSwap(url:String):void
		{
			_noSwap = false;
			if (_cache[url])//если есть в кеше, то запускаем твин
			{
				swap(_cache[url]);
			}else
			{
				//сохраняем урл, чтобы можно было сохранить в кеше
				_currUrl = url;
				//стартуем загрузку
				_loader.load(new URLRequest(url));
				if (_preloader)
				{
					addChild(_preloader);
				}
			}
		}
		/**
		 *
		 * @param	bitmapData
		 */
		public function setBitmapData(bitmapData:BitmapData):void
		{
			_bitmap.bitmapData = bitmapData;
		}

		/**
		 * меняет битмап, применяя текщий эффект
		 * @param	bmd 		битмапДата, на которую будем менять
		 */
		public function swap(bmd:BitmapData):void
		{

			if (_mode == RANDOM)//берем случайный из спсика
			{
				var indx:int = (Math.random() * _randomList.length) % _randomList.length;
				_currEffect = _randomList[indx];

			}else
			{
				_currEffect = _mode;

			}

			//текущая позиция перехода
			_pos = 0;
			//текущий битмап берем как предыдущий
			_prevBmd = new BitmapData(_width, _height, true, 0);
			_prevBmd.draw(_bitmap.bitmapData);
			//переданный как следующий
			_nextBmd = new BitmapData(_width, _height, true, 0);
			_nextBmd.draw(bmd);

			//стартовые параметры для pixelDissolve
			_pixelSeed = 0;
			_pixelsPerStep = _width * _height * _step;
			//если ripple, то возмущаем его карту
			if (_currEffect == RIPPLE)
			{
				_ripple.clear();
				var wobbleNum:int = _width * _height / 2000;
				_ripple.wobble(wobbleNum);

			}

			//стартуем твин
			addEventListener(Event.ENTER_FRAME, shiftPos);
			render();
			//вещаем событие что твин стартовал
			//dispatchEvent(new BitmapTweenerEvent(BitmapTweenerEvent.START_TWEEN, _currEffect));
		}
		
		//двигаем текущую позицию
		private function shiftPos(evnt:Event):void
		{
			//шагаем
			_pos += _step;

			if (_pos < 1)
			{
				render();//считаем
			}else
			{
				finalizeTween();//заканчиваем
			}
		}

		private function finalizeTween():void
		{
			//останавливаем счет
			removeEventListener(Event.ENTER_FRAME, shiftPos);
			//берем конечный как есть
			_bitmap.bitmapData = _nextBmd.clone();
			//вещаем событие (не используется сейчас нигде)
			dispatchEvent(new Event(Event.COMPLETE));
		}

		//расчет состояния основного битмапа в зависимости от _pos (0..1)
		private function render():void
		{

			// за основу берем копию грядущего
			_bitmap.bitmapData = _nextBmd.clone();

			//копию того что будем дорисовывать кладем в переменную
			var addedBmd:BitmapData = _prevBmd.clone();

			//матрицы для альфы
			var backwardAlpha:ColorAdjust = new ColorAdjust(ColorAdjust.CLEAR);

			backwardAlpha.alpha( 1 - _pos);

			if (applyAlphaToNext)
			{
				//альфа следующего
				var forwardAlpha:ColorAdjust = new ColorAdjust(ColorAdjust.CLEAR);
				forwardAlpha.alpha( _pos);
				_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, forwardAlpha.filter);
			}

			//var easyPos:Number = easyFunction(_pos, 0, 1, 1);
			var easyPos:Number = -0.5 * (Math.cos(Math.PI * _pos) - 1);

			switch(_currEffect)
			{

				case PIXEL:
				{
					//диссолвим реальный битмап, не копию
					_pixelSeed=_prevBmd.pixelDissolve(_nextBmd, _bitmap.bitmapData.rect, ORIGIN, _pixelSeed, _pixelsPerStep);
					_bitmap.bitmapData.draw(_prevBmd);
					break;
				}
				
				case BLUR: 
				{
					//дорисовывем с альфой
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					_bitmap.bitmapData.draw(addedBmd);
					//блурим тольк по Х, амплитутда по синусу
					var blurSize:int = maxBlurSize * Math.sin(Math.PI * easyPos);
					_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, new BlurFilter(blurSize, 0));
					break;
				}
				
				case SHOCK: 
				{
					//дорисовывем с альфой
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					_bitmap.bitmapData.draw(addedBmd);
					// блурим рандомно по X|Y, амплитутда по синусу
					var shockSize:int = maxShockSize * Math.sin(Math.PI * easyPos);
					if (Math.random() > 0.5)
					{
						_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, new BlurFilter(shockSize, 0));
					}else
					{
						_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, new BlurFilter(0, shockSize));
					}
					break;
				}

				case PLASTIC:
				{
					//дорисовывем с альфой
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					_bitmap.bitmapData.draw(addedBmd);
					//применяем фильтр, масштаб по синусу
					_plastic.scale = Math.sin(Math.PI * easyPos);
					_plastic.shiftY();
					_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, _plastic.filter);
					break;
				}
					
				case RIPPLE: 
				{
					//дорисовывем с альфой
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					_bitmap.bitmapData.draw(addedBmd);
					//масштаб с потолка, но по синусу при этом
					_ripple.scale = 8 * Math.sin(Math.PI * easyPos);
					//пересчитываем карту и применяем
					_ripple.render();
					_bitmap.bitmapData.applyFilter(_bitmap.bitmapData, _bitmap.bitmapData.rect, ORIGIN, _ripple.filter);
					break;
				}
				
				case SWIRL_IN: 
				{
					//масштаб по квадрату
					//альфу не применяем
					_swirl.scale = 2 * _pos * _pos;
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, _swirl.filter);
					//альфу применяем только на излете
					_alphaTrig=0.75
					if (_pos > _alphaTrig)
					{
						backwardAlpha.alpha(1 - (_pos - _alphaTrig) / (1 - _alphaTrig));
						addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					}
					_bitmap.bitmapData.draw(addedBmd);
					break;
				}
				
				case SWIRL_OUT:
				{
					//масштаб по квадрату
					_swirl.scale = -2.5 * _pos * _pos;
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, _swirl.filter);
					//альфу применяем только на излете
					_alphaTrig=0.85
					if (_pos > _alphaTrig)
					{
						backwardAlpha.alpha (1 - (_pos - _alphaTrig) / (1 - _alphaTrig));
						addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					}
					_bitmap.bitmapData.draw(addedBmd);
					break;
				}
				case FLOW:
				{
					//характерный размер по Y
					var sY:Number = _step *  _height;
					//сколько пятен по горизонтали (с запасом)
					for (var i:int = 0; i < 2 * flowSegments + 2; i++)
					{
						//по Х раномно 0.75..1.25 от точных
						var tX:Number = (0.75 + 0.5 * Math.random()) * i  * _smudge.size;
						//по У рандомно -0.5..0.5 от точной
						var tY:Number = _pos  * _height + (0.5 - Math.random()) * sY;
						//величина смазывания
						var dX:Number = 0;
						var dY:Number = sY * (1 +  0.5*Math.random());
						//смазываем реальный битамп, не копию (нужно чтоб изменения накапливлись)
						_smudge.smudgeBitmap(_prevBmd, tX, tY, dX, dY);
					}
					//рисуем маску
					_maskMtrx.createGradientBox(_width, _height, Math.PI / 2);
					//прозрачность от текущей позиции и выше
					_maskRatios = [0, int(0xFF * _pos)];
					_maskShape.graphics.clear();
					_maskShape.graphics.beginGradientFill(GradientType.LINEAR, _maskColors, _maskAlphas, _maskRatios, _maskMtrx);
					_maskShape.graphics.drawRect(0, 0, _width, _height);
					//срисовываем в служебный биттмап
					_maskBmd = new BitmapData(_width, _height, true, 0);
					_maskBmd.draw(_maskShape);
					//срисовываем битмап в себя с прозрачной маской
					_prevBmd.copyPixels(_prevBmd, _bitmap.bitmapData.rect, ORIGIN, _maskBmd, ORIGIN);
					//убиваем маску
					_maskBmd.dispose();
					_maskShape.graphics.clear();
					//пририсовываем
					_bitmap.bitmapData.draw(_prevBmd);
					break;
				}
		
				case OVAL:
				{
					//рисуем маску
					_maskMtrx.createGradientBox(2* _width,2 * _height, 0, -_width/2, -_height/2);
					_maskRatios = [0, int(0xFF * Math.sqrt(_pos))];
					_maskShape.graphics.clear();
					_maskShape.graphics.beginGradientFill(GradientType.RADIAL, _maskColors, _maskAlphas, _maskRatios, _maskMtrx);
					_maskShape.graphics.drawRect(0, 0, _width, _height);
					//срисовываем в служебный биттмап
					_maskBmd = new BitmapData(_width, _height, true, 0);
					_maskBmd.draw(_maskShape);
					//копируем с альфой в себя же (если брать свежий, то получается криво: что и как рабираться не стал)
					_prevBmd.copyPixels(_prevBmd, _bitmap.bitmapData.rect, ORIGIN, _maskBmd, ORIGIN);
					_maskBmd.dispose();
					//пририсовываем
					_bitmap.bitmapData.draw(_prevBmd);
					break;
				}
				/*
				case CHAOS:
				{
					//дорисовывем с альфой
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					_bitmap.bitmapData.draw(addedBmd);
					var aPos:Number = Math.sin(Math.PI * _pos);
					//применяем замут из Pixel
					BitmapTransform.crystalize(_bitmap.bitmapData, chaosCellSize, aPos, aPos, true, true);
					break;
				}
				*/
				case ALPHA:
				{
					//дорисовывем с альфой и все
					addedBmd.applyFilter(addedBmd, addedBmd.rect, ORIGIN, backwardAlpha.filter);
					_bitmap.bitmapData.draw(addedBmd);
					break;
				}

				default:
				{
					//уходим на конечную позицию
					_pos = 1;
					break;
				}
			}
		}
		/**
		 * текущий еффект, (чтобы сориентироваться в режиме рандом)
		 */
		public function get currentEffect():String { return _currEffect; }

		/**
		 * эффект перехода
		 */
		public function get mode():String { return _mode; }
		public function set mode(value:String):void
		{
			_mode = value;
		}

		/**
		 * шаг твина из расчета всеь цикл=1, 0.02 по умолчанию
		 */
		public function get step():Number { return _step; }
		public function set step(value:Number):void
		{
			_step = value;
		}

		/**
		 * дисплейОбжект, который будет показан во время загрузки
		 */
		public function get preloader():DisplayObject { return _preloader; }
		public function set preloader(value:DisplayObject):void
		{
			_preloader = value;

		}
	}
}

