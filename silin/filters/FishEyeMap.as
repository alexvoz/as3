/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.filters
{
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.Point;
	
	
	/**
	 * эффект рыбьего глаза<br>
	 * 
	 * @author silin
	 */
	public class FishEyeMap 
	{

		private var _filter:DisplacementMapFilter;
		private var _width:int;
		private var _height:int;
		private var _scale:Number;
		/**
		 * condtuctor
		 * @param	width		размеры карты искажения
		 * @param	height
		 * @param	scale		коэффициент искажения
		 */
		public function FishEyeMap(width:int, height:int, scale:Number = 0.5) 
		{
			_width = width + width % 2;
			_height = height + height % 2;
			var map:BitmapData = new BitmapData(_width, _height, false, 0x808080);
			_filter = new DisplacementMapFilter(map);
			_filter.mode = DisplacementMapFilterMode.COLOR;
			_filter.componentX = BitmapDataChannel.RED;
			_filter.componentY = BitmapDataChannel.BLUE;
			this.scale = scale;

			drawMap();
		
		}
		
		
		
		private function drawMap():void
		{
			for (var i:int = 0; i < _width; i++)
			{
				for (var j:int = 0; j < _height; j++)
				{
					
					var x0:Number = 2 * (i / _width - 0.5);
					var y0:Number = 2 * (j / _height - 0.5);

					var r:Number = Math.sqrt(x0 * x0 + y0 * y0);
					var k:Number = Math.sin(1 - r);
					
					var red:int = 128 * (1 - x0 * k);
					var blue:int = 128 * (1 - y0 * k);
					
					_filter.mapBitmap.setPixel(i, j, red << 16 | blue);
					
					
				}
			}
		}
		/**
		 * итоговый DisplacementMapFilter
		 */
		public function get filter():DisplacementMapFilter
		{
			return _filter;
		}
		/**
		 * масштаб искажения, 0..1<br>
		 * привязан к размерам карты фильтра
		 */
		public function get scale():Number { return _scale; }
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = _width * value;
			_filter.scaleY = _height * value;
			
			
		}
		
	}
	
}