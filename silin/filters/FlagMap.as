/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.filters
{
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	
	
	/**
	 * имитация флага<br>
	 * отсвет реализован в отдельном спрайте c blendMode = BlendMode.MULTIPLY 
	 * (надо положить над объектом, к которому применяется фильтр).<br>
	 * карта и отсвет считаются итерационно, для визуального эффекта нужен переодический вызов render()
	 * 
	 * @author silin
	 */
	public class FlagMap 
	{
		private const ORIGIN:Point = new Point();
		
		public var speedX:Number = 2;
		public var speedY:Number = 1;
		
		private var _width:int;
		private var _height:int;
		
		private var _posX:int = 0;
		private var _posY:int = 0;
		
		private var _scale:Number=0.25;
		private var _offset:Number = 0.35;
		
		private var _filter:DisplacementMapFilter;
		
		private var _filterMap:BitmapData;
		private var _offsetMap:BitmapData;
		
		
		
		private var _lightMtrx:ColorAdjust = new ColorAdjust();
		private var _shadeBmd:BitmapData;
		
		private var _filterPoint:Point;//точка приложения, сдвинута на четверть чтобы захватить краевые эффекты
		private var _maskBmd:BitmapData;//битмап для альфа-маски копирования карты фильтра в шейдер
		private var _maskOriginalBmd:BitmapData;//битмап с исходным прямокгольником оригоинала
		
		
		private var _perlinMap:PerlinMap;
		private var _renderShadeFlag:Boolean = true;
		private var _mapWidth:int;
		private var _mapHeight:int;
		/**
		 * constructor
		 * @param	width			ширина
		 * @param	height			высота
		 * @param	scale			коэффициент масштабирования, 0..1 (завязан на размеры)
		 * @param	size			размер ячеки перлинойза, 0..1 (завязан на размеры)
		 * @param	renderShade		нужно ли считать отсвет
		 */
		public function FlagMap(width:int, height:int, scale:Number = 0.15, cellSize:Number = 20, renderShade:Boolean = true)
		{
			
			_perlinMap = new PerlinMap(width, height, scale, cellSize, 1);
			
			_width = width + width % 2;
			_height = height + height % 2;
			_mapWidth = 2 * _width;
			_mapHeight = 2 * _height;
			
			
			_renderShadeFlag = renderShade;
			
			
			
			_filterMap = new BitmapData(_mapWidth, _mapHeight, false, 0x808080);
			_filterPoint = new Point( -_width / 2, -_height / 2);
			
			
			_filter = new DisplacementMapFilter(_filterMap, _filterPoint);
			_filter.mode = DisplacementMapFilterMode.COLOR;
			_filter.componentX = BitmapDataChannel.RED;
			_filter.componentY = BitmapDataChannel.BLUE;
			
			_filter.scaleX = _width * scale;
			_filter.scaleY = _height * scale;
			
			
			_shadeBmd = new BitmapData(_mapWidth, _mapHeight, true, 0);
			_maskOriginalBmd = new BitmapData(_mapWidth, _mapHeight, true, 0);
			_maskBmd = new BitmapData(_mapWidth, _mapHeight, true, 0);
			
			_lightMtrx.saturation(0).brightness(0.5).contrast(1);
		
			
			_maskOriginalBmd.fillRect(new Rectangle(width / 2, height / 2, width, height), 0xFFFF0000);
			
			createOffsetMap();
			
		}
		/**
		 * @private
		 */
		private function createOffsetMap():void
		{
			var w:Number = _offset * _width;
			var h:Number = _mapHeight;
			var dx:Number = _width / 2;
			
			if (w && h)
			{
				//шейп во всю высоту и ширину:буферный участок + сам градиент
				var shape:Shape = new Shape();
				var mtrx: Matrix = new Matrix();
				mtrx.createGradientBox(w, h, 0, dx, 0);
				shape.graphics.beginGradientFill( 'linear', [ 0x800080, 0x800080 ], [ 1, 0 ], [ 0, 0xFF ], mtrx );
				shape.graphics.drawRect(dx, 0, w, h);
				shape.graphics.beginFill(0x800080);
				shape.graphics.drawRect(0, 0, dx, h);
				shape.graphics.endFill();
				//карта ослабления, ширина: буферный участок + сам градиент
				_offsetMap = new BitmapData(dx + w, h, true, 0);
				_offsetMap.draw(shape);
				
				
			}else
			{
				_offsetMap = null;
			}
			
		}
		
		
		/**
		 * расчет итерации 
		 */
		public function render():void	
		{
			//двигаем позицию копирования перлиннойзовой карты
			_posX -= speedX;
			if (_posX > _width)_posX -= _width
			else if (_posX < 0)_posX += _width;
			
			_posY += speedY;
			if (_posY > _height)_posY -= _height
			else if (_posY < 0)_posY += _height;
			
			//область копирования
			var srcRec:Rectangle = new Rectangle(_posX - _width / 2, _posY - _height / 2, _mapWidth, _mapHeight);
			
			//копируем теущий фрагмент перлинойзовой карт
			_filterMap.copyPixels(_perlinMap.filter.mapBitmap, srcRec, ORIGIN);
			
			//пририсоваем  градиент для начального участка
			if (_offsetMap)
			{
				_filterMap.draw(_offsetMap);
			}
			//если стоит флаг, считаем отсвет
			if (_renderShadeFlag)
			{
				drawShade();
			}
		}
		
		/**
		 * возвращает спрайт c  подсветкой (blendMode = BlendMode.MULTIPLY)<br> 
		 * подсветка пересчитывается в render() при включенном renderShade
		 */
		public function getShade():Sprite
		{
			var shade:Sprite = new Sprite();
			var shadeBmp:Bitmap = new Bitmap(_shadeBmd);
			shadeBmp.y = - _height / 2;
			shadeBmp.x = -_width / 2;
			shade.addChild(shadeBmp);
			shade.blendMode = BlendMode.MULTIPLY;
			return shade;
		}
		
		private function drawShade():void
		{
			
			_maskBmd.copyPixels(_maskOriginalBmd, _maskOriginalBmd.rect, ORIGIN);
			//для маски начальная точка совпадает с картой, поэтому надо применять фильтр от начала
			_filter.mapPoint = ORIGIN;
			//искажаем картой фильтра
			_maskBmd.applyFilter(_maskBmd, _maskBmd.rect, ORIGIN, _filter);
			//возвращаем точку применения фильтра на место
			_filter.mapPoint = _filterPoint;
			
			//рисуем перлинНойз карты с маской
			_shadeBmd.copyPixels(_filterMap, _shadeBmd.rect, ORIGIN, _maskBmd, ORIGIN);
			//применяем фильтр (десатурация, осетление, контраст)
			_shadeBmd.applyFilter(_shadeBmd, _shadeBmd.rect, ORIGIN, _lightMtrx.filter);
			
		}
		
		
		
		/**
		 * коэффициент масштабирования, 0..1 (завязан на размеры)
		 */
		public function get scale():Number { return _scale;}
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = _width * value;
			_filter.scaleY = _height * value;
			
		}
		/**
		 * итоговый фильтр
		 */
		public function get filter():DisplacementMapFilter
		{
			return _filter;
		}
		
		/**
		 * граница плавного перехода , 0..1 от ширины (default = 0.25)
		 */
		public function get offset(): Number
		{
			return _offset;
		}
		public function set offset(value:Number):void
		{
			_offset = value;
			createOffsetMap();
		}
		/**
		 * нужно ли считать подсветку (default = true)
		 */
		public function get renderShade():Boolean { return _renderShadeFlag; }
		
		public function set renderShade(value:Boolean):void 
		{
			_renderShadeFlag = value;
			if (!_renderShadeFlag)
			{
				//на всякий случай заливаем прозрачным битмап отсвета
				_shadeBmd.fillRect(_shadeBmd.rect, 0);
			}
		}
		/**
		 * размер ячейки перлинойза
		 */
		public function get cellSize():Number { return _perlinMap.cellSize; }
		
		public function set cellSize(value:Number):void 
		{
			
			_perlinMap.cellSize = value;
			
		}
		
		
	}
}
