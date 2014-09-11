/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.filters
{
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	/**
	 * DisplacementMapFilter с механизмом смазывания пятна в заданном направлении
	 * 
	 * @author silin
	 */
	public class SmudgeMap 
	{
		private const ORIGIN: Point = new Point();
		private var _filter:DisplacementMapFilter;
		private var _radius:int=25;
		private var _spotMap:BitmapData;
		private var _filterMap:BitmapData;
		private var _spotX:Number;
		private var _spotY:Number;
		private var _smooth:Number = 2;
		/**
		 * constructor
		 * @param	width	ширина фильтра
		 * @param	height	высота фильтра
		 */
		public function SmudgeMap(width:int, height:int ) 
		
		{
			createSpotMap();
			_filterMap = new BitmapData(width, height, false, 0x808080);
			_filter = new DisplacementMapFilter(_filterMap, null, BitmapDataChannel.RED, BitmapDataChannel.BLUE);
			_filter.mode = DisplacementMapFilterMode.COLOR;
		}
		
		private function updateMap():void
		{
			_filterMap.fillRect(_filterMap.rect, 0x808080);
			var mtrx:Matrix = new Matrix();
			mtrx.translate(_spotX - _radius, _spotY - _radius);
			_filterMap.draw(_spotMap, mtrx);
		}
		
		private function createSpotMap():void
		{
			var size:int = _radius * _radius;
			var pow:Number = 1 / _smooth;
			
			_spotMap = new BitmapData(2 * _radius, 2 * _radius, false, 0x808080);
			
			for (var i:int = -_radius; i < _radius; i++) 
			{
				for (var j:int = -_radius; j < _radius; j++) 
				{
					var r:int = i * i + j * j;
					if (r < 16) r = 16;// чтоб не слишком резко для самого центра
					
					var coeff:Number = Math.pow(r / size, pow);
					
					if (coeff <1)
					{
						var clr:int = 0x80  * coeff;
						_spotMap.setPixel(i + _radius, j + _radius, clr << 16 | clr);
					}
				}
			}
		}
		
		/**
		 * смазывает битмапдату из x-y на dX-dY 
		 * @param	bmd
		 * @param	x
		 * @param	y
		 * @param	dX
		 * @param	dY
		 */
		public function smudgeBitmap(bmd:BitmapData, x:int, y:int, dX:int, dY:int):void
		{
			_spotX = x;
			_spotY = y;
			updateMap();
			_filter.scaleX = 2 * dX;
			_filter.scaleY = 2 * dY;
			bmd.applyFilter(bmd, bmd.rect, ORIGIN, _filter);
		}
		
		/**
		 * размер пятна
		 */
		public function get size():Number
		{
			return _radius;
		}
		public function set size(value:Number):void 
		{
			
			_radius = Math.round(value / 2);
			createSpotMap();
		}
		
		
		/**
		 * степень сглаживания, 0 без смазывания - только пемещение
		 */
		public function set smooth(value:Number):void 
		{
			if (value <= 0) value = 0;
			_smooth = value;
			createSpotMap();
		}
		/**
		 * итоговый фильтр
		 */
		public function get filter():DisplacementMapFilter { return _filter; }
		
	}
	
}