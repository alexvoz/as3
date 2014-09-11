/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.filters
{
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	/**
	 * перспективное искажения<br>
	 * карта создается заливками
	 * 
	 * @author silin
	 */
	public class PerspectiveMap 
	{
		private var _filter:DisplacementMapFilter;
		private var _width:int;
		private var _height:int;
		private var _scale:Number=0;
		private var _gainX:Number=0;
		private var _gainY:Number=0;
		private var _posX:Number = 0;
		private var _posY:Number = 0; 
		/**
		 * constructor
		 * @param	width		эффективная ширина фильтра
		 * @param	height		эффективная высота фильтра
		 * @param	scale		коэффициент масштабирования, 0..1 (завязан на размеры)
		 */
		public function PerspectiveMap(width:int, height:int, scale:Number = 0.5) 
		{
			_width = 2+width + width % 2;
			_height = 2+height + height % 2;
			
			var map:BitmapData = new BitmapData(_width, _height, true, 0x808080);
			_filter = new DisplacementMapFilter(map);
			_filter.mode = DisplacementMapFilterMode.COLOR;
			_filter.color = 0x00FF00;
			_filter.componentX = BitmapDataChannel.RED;
			_filter.componentY = BitmapDataChannel.BLUE;
			
			this.scale = scale;
			drawMap();
		
		}
		public function update():void
		{
			drawMap();
		}
		
		
		/**
		 * итоговый фильтр
		 */
		public function get filter():DisplacementMapFilter
		{
			return _filter;
		}
		/**
		 * общий масштаб фильтра, 0..1
		 */
		public function get scale():Number { return _scale; }
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = _width * value;
			_filter.scaleY = _height * value;

		}
		/**
		 * коэффициент эффекта по горизонтали, 0..1
		 */
		public function get gainX():Number { return _gainX; }
		
		public function set gainX(value:Number):void 
		{
			_gainX = value;
			drawMap();
		}
		/**
		 * коэффициент эффекта по вертикали, 0..1
		 */
		public function get gainY():Number { return _gainY; }
		
		public function set gainY(value:Number):void 
		{
			_gainY = value;
			drawMap();
		}
		/**
		 * смещение по горизонтали, 0..1
		 */
		public function get posX():Number { return _posX; }
		
		public function set posX(value:Number):void 
		{
			_posX = value;
			drawMap();
		}
		/**
		 * смещение по вертикали, 0..1
		 */
		public function get posY():Number { return _posY; }
		
		public function set posY(value:Number):void 
		{
			_posY = value;
			drawMap();
		}
		
		
		
		private function drawMap():void
		{
			var tmpShape:Shape = new Shape();
			var g:Graphics = tmpShape.graphics;
			var colors:Array;
			var alphas:Array;
			var ratios:Array;
			
			 var mtrx:Matrix = new Matrix();
			//VERT
			mtrx.createGradientBox(_width, _height, Math.PI / 2, 0, 0);
			
			colors = [0x808000, 0x8080FF];
			var a:Number =  0.4;
			alphas = [a, a];
			ratios = [0, 0xFF];
            g.beginGradientFill("linear", colors, alphas, ratios, mtrx);
            g.drawRect(0, 0, _width, _height);
            g.endFill();
			//HORIZ
			
			colors = [0x008080, 0xFF8080];
			mtrx.createGradientBox(_width, _height, 0, 0, 0);
			g.beginGradientFill("linear", colors, alphas, ratios, mtrx);
            g.drawRect(0, 0, _width, _height);
            g.endFill();
			
			
			colors = [0x808080, 0x808080];
			ratios = [0, 0xFF];
			
			//VERT
			alphas = [gainY * (1 - posY), gainY * posY];
			mtrx.createGradientBox(_width, _height, Math.PI/2, 0, 0);
            g.beginGradientFill("linear", colors, alphas, ratios, mtrx);
            g.drawRect(0, 0, _width, _height);
            g.endFill();
			//HORIZ
			mtrx.createGradientBox(_width, _height, 0, 0, 0);
			alphas = [gainX * (1 - posX), gainX * posX];
			g.beginGradientFill("linear", colors, alphas, ratios, mtrx);
            g.drawRect(0, 0, _width, _height);
            g.endFill();
			
			
			
			
			
			_filter.mapBitmap.fillRect(_filter.mapBitmap.rect, 0x808080);
			_filter.mapBitmap.draw(tmpShape);
			
			
			
		}
		
	}
	
}