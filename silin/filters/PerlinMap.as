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
	 * безшовная какрта perlinNoise <br>
	 * с механизмом зацикленного сдвига по осям<br>
	 * 
	 * @author silin
	 */
	
	public class PerlinMap 
	{
		private const ORIGIN: Point = new Point();
		
		private var _filter:DisplacementMapFilter;
		
		private var _width:int;
		private var _height:int;
		
		private var _posX:int = 0;
		private var _posY:int = 0;
		
		private var _scale:Number=0.25;
		
		private var _scaleX:Number;
		private var _scaleY:Number;
		
		private var _cellSize:Number = 20;
		private var _numOctaves:int = 1;
		
		
		/**
		 * constructor
		 * @param	width	эффективная ширина фильтра
		 * @param	height	эффективная высота фильтра
		 * @param	scale	коэффициент масштабирования, 0..1 (завязан на размеры)
		 */
		public function PerlinMap(width:int, height:int, scale:Number = 0.25, size:Number = 20, numOctaves:int = 1) 
		{
			_numOctaves = numOctaves;
			_width = width + width % 2;
			_height = height + height % 2;
			
			var map:BitmapData = new BitmapData(3 * _width, 3 * _height, false, 0x808080);
			
			_filter = new DisplacementMapFilter(map, new Point( -_width / 2, -_height / 2));
			_filter.mode = DisplacementMapFilterMode.COLOR;
			_filter.componentX = BitmapDataChannel.RED;
			_filter.componentY = BitmapDataChannel.BLUE;
			_scale = scale;
			_filter.scaleX = _width * scale;
			_filter.scaleY = _height * scale;
			_cellSize = size;
			

			drawMap();
			shiftX(_width / 2);
			shiftY(_height / 2);
			
			
		}
		
		/**
		 * @private
		 */
		private function drawMap():void
		{
			
			var mtrx:Matrix = new Matrix();
			
			var seed:int =  128;// Math.round(64 * Math.random());
			
			
			var channels:uint = BitmapDataChannel.RED | BitmapDataChannel.BLUE;
			var res:BitmapData = _filter.mapBitmap;
			var map:BitmapData = new BitmapData(0.5 * _width, 0.5 * _height, false, 0x00FF00);
			map.perlinNoise(_cellSize, _cellSize, _numOctaves, seed, false, true , channels );
			res.draw(map);
			mtrx.scale( -1, 1);
			mtrx.translate(_width, 0);
			res.draw(map, mtrx);
			mtrx = new Matrix();
			mtrx.scale( 1, -1);
			mtrx.translate(0, _height);
			res.draw(map, mtrx);
			mtrx = new Matrix();
			mtrx.scale( -1, -1);
			mtrx.translate(_width, _height);
			res.draw(map, mtrx);
			map = new BitmapData(_width, _height);
			map.copyPixels(res, map.rect, ORIGIN);
			
			
						
			for (var i:int = 0; i < 3; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{
					res.copyPixels(map, map.rect, new Point(_width*i, _height*j));
				}
			}
			var blurX:int = _width/16;
			var blurY:int = _height/16;
			res.applyFilter(res, res.rect, ORIGIN, new BlurFilter(blurX, blurY, 2));
			
		}
		
		
		/**
		 * двигает карту по горизонтали
		 * @param	value
		 */
		public function shiftX(value:int = 1):void 
		{
			
			_posX += value;

			if (_posX > _width)_posX -= _width
			else if (_posX < 0)_posX += _width;
			
			
			_filter.mapPoint = new Point( -_posX - _width / 2, -_posY - _height / 2);
		}
		/**
		 * двигает карту по вертикали
		 * @param	value
		 */
		public function shiftY(value:int = 1):void 
		{
			
			_posY += value;
			if (_posY > _height)_posY -= _height
			else if (_posY < 0)_posY += _height;
			_filter.mapPoint = new Point( -_posX - _width / 2, -_posY - _height / 2);
			
		}
		
		/**
		 * размер ячейки перлинойза
		 */
		public function get cellSize():Number { return _cellSize; }
		
		public function set cellSize(value:Number):void 
		{
			_cellSize = value;
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
		 * коэффициент масштабирования, 0..1 (завязан на размеры)
		 */
		public function get scale():Number { return _scale;}
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = _width * value;
			_filter.scaleY = _height * value;
			
		}
		
	}
	
}