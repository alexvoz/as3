/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.filters
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * волнообразное искажение<br>
	 * @author silin
	 *
	 */
	public class WaveMap
	{
		private const ORIGIN:Point = new Point();
		
		private var _width:int;
		private var _height:int;
		private var _pos:int = 0;
		
		private var _scale:Number = 0.5;
		private var _waveHeigth:int = 20;
		private var _offset:Number = 0.25;
		private var _filter:DisplacementMapFilter;
		private var _mapWidth:int;
		private var _mapHeight:int;
		private var _filterPoint:Point;
		
		private var _waveMap:BitmapData;
		private var _filterMap:BitmapData;
		private var _offsetMap:BitmapData;
		
		
		/**
		 * constructor
		 * @param	width		эффективная ширина фильтра
		 * @param	height		эффективная высота фильтра
		 * @param	scale		масштаб искажения
		 */
		public function WaveMap(width:int, height:int, scale:Number = 0.5 )
		{
			_scale = scale;
			_width = width + int(width % 2);
			_height = height + int(height % 2);
			
			_filterPoint = new Point( -_width / 2, 0);
			_mapWidth = 2 * _width;
			_mapHeight = 2 * _height;
			
			_waveMap = new BitmapData(_mapWidth, _mapHeight);
			_filterMap = new BitmapData(_mapWidth, _mapHeight);
			_offsetMap = new BitmapData(_mapWidth, _mapHeight);
			
			
			var mode:String = DisplacementMapFilterMode.COLOR;
			_filter = new DisplacementMapFilter(_filterMap, _filterPoint , 1, 1, _scale * _width, 0, mode);
			createWaveMap();
			createOffsetMap();
		}
		
		/**
		 * @private
		 */
		private function createWaveMap():void
		{
			var halfMap:BitmapData = new BitmapData(_mapWidth, _height);
			var seed:int = 12;// Math.round(64 * Math.random());
			
			
			var quartMap:BitmapData = new BitmapData(_mapWidth, Math.ceil(_height / 2));
			quartMap.perlinNoise(0, _waveHeigth, 1, seed, false, true, 1, true, null);
			
			halfMap.draw(quartMap);
			
			var mtrx:Matrix = new Matrix(1, 0, 0, -1, 0, _height);
			halfMap.draw(quartMap,mtrx);
			
			_waveMap.draw(halfMap);
			mtrx= new Matrix(1, 0, 0, -1, 0, 2 * _height);
			_waveMap.draw(halfMap, mtrx);
			
			quartMap.dispose();
			halfMap.dispose();
		}
		/**
		 * @private
		 */
		private function createOffsetMap():void
		{
			
			var w:Number = _mapWidth;
			var h:Number = _offset * _height;
			if (w && h)
			{
				var shape:Shape = new Shape();
				var mtrx: Matrix = new Matrix();
				mtrx.createGradientBox(w, h, Math.PI / 2, 0, 0);
				shape.graphics.beginGradientFill( 'linear', [ 0x800080, 0x800080 ], [ 1, 0 ], [ 0, 0xFF ], mtrx );
				shape.graphics.drawRect(0, 0, w, h);
				shape.graphics.endFill();
				_offsetMap = new BitmapData(w, h, true, 0);
				_offsetMap.draw( shape);
			}else
			{
				_offsetMap = null;
			}
			
			
			
			
			
			
				
		}
		
		/**
		 * двигает карту
		 * @param	value
		 */
		public function shift(value:int = 1):void
		{
			_pos -= value;
			if (_pos > _height)_pos -= _height;
			if (_pos < 0)_pos += _height;
			
			
			var rec:Rectangle = new Rectangle(0, _pos, _mapWidth, _mapHeight);
			_filterMap.copyPixels(_waveMap, rec, ORIGIN);
			if(_offsetMap)
				_filterMap.draw(_offsetMap);
			
		}

		/**
		 * коэффициент масштабирования, 0..1 от ширины
		 */
		public function get scale():Number { return _scale; }
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = _scale*_width;
			
		}
		/**
		 * продольный размер волны (default=20)
		 */
		public function get waveHeigth():int { return _waveHeigth; }
		
		public function set waveHeigth(value:int):void 
		{
			_waveHeigth = value;
			createWaveMap();
		}
		/**
		 * итоговый фильтр
		 */
		public function get filter():DisplacementMapFilter { return _filter; }
		
		/**
		 * граница плавного перехода , 0..1 от высоты (default = 0.25)
		 */
		public function get offset(): Number
		{
			return _offset;
		}
		public function set offset(value:Number):void
		{
			//if (value < 0.1) value = 0.1;
			_offset = value;
			createOffsetMap();
		}

		
	}
	
}