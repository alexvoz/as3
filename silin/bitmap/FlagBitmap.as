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
	
	/**
	 * Bitmap с механизмом искажения, имитирующим развевающийся флаг
	 * @author silin
	 */
	public class FlagBitmap extends Bitmap
	{
		
		private const ORIGIN: Point = new Point();

		private var _source:BitmapData;//исходныая картинка
		private var _output:BitmapData;//показываемая картинка
		
		private var _flagBmd:BitmapData;
		private var _margin:int = 10;
		private var _noiseSeed: Number =  Math.floor( Math.random() * 0xFF);//0xCC;//
		private var _noiseOffsetArr: Array/*Point*/ = [];
		private var _noiseFallOffBmd: BitmapData;
		private var _noiseBmd: BitmapData;
		private var _displacementFilter: DisplacementMapFilter;
		private var _lightBmd: BitmapData;
		//колорТрансформ копирования отблеска
		private var _lightContrast: ColorTransform = new ColorTransform( 4, 4, 4, 1, 0, 0, 0, 0 );
		//фильр десатурации
		private var _grayMаtrix: ColorMatrixFilter = new ColorMatrixFilter(
			[
				0, 0, .35, 0, 0,
				0, 0, .35, 0, 0,
				0, 0, .35, 0, 0,
				0, 0, .35, 0.4, 0
			]
		);

		/**
		 * constructor
		 * @param	source			исходный bitmapData
		 */
		public function FlagBitmap(source:BitmapData)
		{
			super();
			//берем по ссылке, если нужен апдейт, то все будем делать снаружи
			_source = source;
			init();
		}
		
		/**
		 * запускает анимацию
		 */
		public function startAnimation():void	
		{
			addEventListener(Event.ENTER_FRAME, render);
		}
		/**
		 * останавливает анимацию
		 */
		public function stopAnimation():void	
		{
			removeEventListener(Event.ENTER_FRAME, render);
		}
		
		private function init(): void
		{
			//коэффициент масштабирования фильтра смещений (один для обоих направлений)
			var scale:Number = 0.125 * Math.max(_source.width, _source.height);
			
			//максимально возможное смещение (+1 px в запас)
			_margin = 1 + scale / 2;
			
			//результирующая картинка
			_output = new BitmapData(_source.width + 2 * _margin, _source.height + 2 * _margin, true, 0);
			bitmapData = _output;
			
			//исходная картинка с полями
			_flagBmd = new BitmapData( width, height, true, 0x0 );
			_flagBmd.copyPixels( _source, _source.rect, new Point(_margin,_margin) );
			
			//битмап коррекции затухания возмущений у левой кромки
			_noiseFallOffBmd = new BitmapData( width, height, true, 0 );
			var shape: Shape = new Shape();
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [ 0x008080, 0x008080 ];
			var alphas:Array = [0.99, 0];
			var ratios:Array = [0x00, 0x60];
			var mtrx:Matrix = new Matrix();
			mtrx.createGradientBox(width - _margin, height, 0, _margin, 0);
			shape.graphics.beginGradientFill(fillType, colors, alphas, ratios, mtrx);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			_noiseFallOffBmd.draw( shape);
			
			//битмап перлинойза
			_noiseBmd = new BitmapData( width, height, false, 0x0);
			
			//массив смещений перлинойза
			_noiseOffsetArr = [ new Point(), new Point() ];
		
			//фильтр смещения
			_displacementFilter = new DisplacementMapFilter( 
				_noiseBmd, ORIGIN, BitmapDataChannel.GREEN, BitmapDataChannel.BLUE,
				scale, scale, DisplacementMapFilterMode.IGNORE
			);
			
			//битмап jтблеска
			_lightBmd = new BitmapData( width, height, true, 0 );
			
			//пересчитываем здесь
			render();
			//стартуем рендеринг
			startAnimation();
		}
		
		
		
		
		//пересчет (на ENTER_FRAME)
		private function render(event:Event = null):void	
		{
			//общие габариты
			var rec:Rectangle = _output.rect;
			//заливаем прозрачным
			_output.fillRect( rec, 0x0 );
			//двигаем смещения фильра
			_noiseOffsetArr[0].x -= 0.04 * _source.width;
			_noiseOffsetArr[1].x -= 0.03 * _source.height;
			//генерим перлинНойз с этими смещениями
			_noiseBmd.perlinNoise(
				0.618 * _source.width, 0.618 * _source.height, 
				2,	_noiseSeed,	false, true, 6,	false,	_noiseOffsetArr 
			);
			//накладываем карту затухания 
			_noiseBmd.copyPixels(_noiseFallOffBmd, rec,	ORIGIN,	_noiseFallOffBmd, ORIGIN, true );
			//смещаем основное изображение
			_output.applyFilter( _flagBmd, rec, ORIGIN, _displacementFilter);
			//в отблеск кладем перлинНойховую карту
			_lightBmd.copyPixels( _noiseBmd, rec, ORIGIN, _output, ORIGIN );
			//перегоняем в серую
			_lightBmd.applyFilter( _lightBmd, rec, ORIGIN, _grayMаtrix );
			//дорисовываем к изображению с BlendMode.MULTIPLY
			_output.draw( _lightBmd, null, _lightContrast, 	BlendMode.MULTIPLY, null, true );
			
		}
		
		//UTILS
		/**
		 * рисует палку (линия - clr, thick) в graphics; <br/>
		 * предполагается, что система координат graphics совпадает с  родительской; <br/>
		 * работает только после добавления экземпляра в дисплейЛист родителя
		 * @param	graphics	где рисовать
		 * @param	length		длина
		 * @param	clr			цвет
		 * @param	thick		толщина
		 */
		public function drawStick(graphics:Graphics, length:Number, clr:uint = 0x808080, thick:Number = 3):void
		{
			if (!parent) 
			{
				throw(new Error("Flag instance is't in display list"));
			}
			var cX:Number = pivot.x;
			var cY:Number = pivot.y;
			
			graphics.moveTo(cX, cY);
			var fi:Number = -Math.PI / 180 * rotation;
			
			cX += length * Math.sin(fi);
			cY += length * Math.cos(fi);
			
			graphics.lineStyle(thick, clr);
			graphics.lineTo(cX, cY);
		}
		
		/**
		 * TL-угол полотнища в родителе; <br/>
		 * работает только после добавления экземпляра в дисплейЛист родителя
		 */
		public function get pivot():Point 
		{ 
			if (!parent) 
			{
				throw(new Error("Flag instance is't in display list"));
			}
			var p:Point = new Point(_margin, _margin);
			p=localToGlobal(p);
			p=parent.globalToLocal(p);
			return p;
		}
		/**
		 * поазывает включена ли анимация
		 */
		public function get animated(): Boolean{ return hasEventListener(Event.ENTER_FRAME); }

	}

}

