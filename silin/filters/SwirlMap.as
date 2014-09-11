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
	 * спиральное искажение <br>
	 * 
	 * @author silin
	 */
	public class SwirlMap 
	{
		private var _filter:DisplacementMapFilter;
		private var _width:int;
		private var _height:int;
		private var _scale:Number;
		/**
		 * constructor
		 * @param	width		ширина фильра
		 * @param	height		высота фильтра
		 * @param	scale		коэффициент масштабирования, 0..1 (завязан на размеры)
		 */
		public function SwirlMap(width:int, height:int, scale:Number = 0) 
		{
			_width = width + width % 2;
			_height = height + height % 2;
			
			var map:BitmapData = new BitmapData(_width, _height, false, 0x808080);
			_filter = new DisplacementMapFilter(map);
			_filter.mode = DisplacementMapFilterMode.COLOR;
			_filter.componentX = BitmapDataChannel.RED;
			_filter.componentY = BitmapDataChannel.BLUE;
			_filter.scaleX = _width * scale;
			_filter.scaleY = _height * scale;
			

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
		 * коэффициент масштабирования
		 */
		public function get scale():Number { return _scale; }
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = _width * value;
			_filter.scaleY = _height * value;
			
		}
		
		
		
		private function drawMap():void
		{
			
			for (var i:int = 0; i < _width; i++)
			{
				for (var j:int = 0; j < _height; j++)
				{
					
					var x0:Number = 2 * (i / _width - 0.5);
					var y0:Number = 2 * (j / _height - 0.5);
					var fi:Number = Math.atan2(y0, x0) +  Math.PI / 4;
					var x1:Number = Math.cos(fi);
					var y1:Number = Math.sin(fi);
					
					var red:int = 128 * (1 - x1 + x0);
					var blue:int = 128 * (1 - y1 + y0);
					_filter.mapBitmap.setPixel(i, j, red << 16 | blue);
					
				}
			}
			//_filter.mapBitmap.applyFilter(_filter.mapBitmap, _filter.mapBitmap.rect, new Point(), new BlurFilter(8,8));
			
		}
		/**
		 * сложно сказать что это такое, но затейливо :)
		 */
		public function reverse():void
		{
			var mtrx:Matrix = new Matrix();
			mtrx.translate(-_filter.mapBitmap.width,0);
			mtrx.scale( -1, 1);
			var tmp:BitmapData = _filter.mapBitmap.clone();
			
			_filter.mapBitmap.draw(tmp, mtrx);
			tmp.dispose();
			_filter.componentX = BitmapDataChannel.BLUE;
			_filter.componentY = BitmapDataChannel.RED;
		}
	}
	
}