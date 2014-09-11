/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.filters
{
import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * имитация кругов на воде<br>
	 * карта считается итерационно, исходя из предыдущего состояния<br>
	 * для визуального эффекта нужен переодический вызов render()
	 * 
	 * @author silin
	 */
	public class RippleMap 
	{
		private const ORIGIN: Point = new Point();
		
		private var _filter:DisplacementMapFilter;
		
		private var _mapBmd: BitmapData;
		private var _resBmd : BitmapData;
	
		private var _bufBmd : BitmapData;
		private var _mtrx1 : Matrix;
		private var _mtrx2 : Matrix;
		private var _waveFilter : ConvolutionFilter;
		private var _dampFilter : ColorTransform;
		
		private var _width:int;
		private var _height:int;
		
		private var _quartRect:Rectangle;
		private var _scale:Number = 1;
		/**
		 * constructor
		 * @param	width	ширина карты
		 * @param	height 	высота карты
		 */
		public function RippleMap(width:int, height:int) 
		{
			_width = width;
			_height = height;
			_quartRect = new Rectangle(0, 0, _width/2,_height/2);
			_mtrx1 = new Matrix();
			_mtrx2 = new Matrix(2, 0, 0, 2);
			
			_mapBmd = new BitmapData(_width, _height, false, 128);
			_resBmd = new BitmapData(_width, _height, false, 128);
			_bufBmd = new BitmapData(_width, _height, false, 128);
			
			_waveFilter = new ConvolutionFilter(3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1], 9, 0);
			_dampFilter = new ColorTransform(0, 0, 0.99609374, 1, 0, 0, 2, 0);
			_dampFilter = new ColorTransform(0, 0, 0.995, 1, 0, 0, 2, 0);
			
			
			
			_filter = new DisplacementMapFilter (new BitmapData(_width, _height, false, 128), ORIGIN, 4, 4, 32, 32, DisplacementMapFilterMode.IGNORE);
			
		}
		
		/**
		 * пересчет карты
		 */
		public function render ():void{
			
			_resBmd.applyFilter (_mapBmd, _quartRect, ORIGIN, _waveFilter);
			_resBmd.draw(_resBmd,_mtrx1,null,BlendMode.ADD);
			_resBmd.draw (_bufBmd, _mtrx1, null, BlendMode.DIFFERENCE);
			_resBmd.draw (_resBmd, _mtrx1, _dampFilter);
			
			_filter.mapBitmap.draw(_resBmd, _mtrx2, null, null, null, true);
			_bufBmd = _mapBmd;
			_mapBmd = _resBmd.clone();
		}
	

		/**
		 * возвращает девственное состояние
		 */
		public function clear():void {
			
			_resBmd = new BitmapData (_width, _height, false, 128);
			_mapBmd = new BitmapData (_width, _height, false, 128);
			_bufBmd = new BitmapData (_width, _height, false, 128);
			_waveFilter = new ConvolutionFilter (3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1] , 9, 0);
			_dampFilter = new ColorTransform (0, 0, 0.99609374, 1, 0, 0, 2, 0);
			
			_filter.mapBitmap = new BitmapData(_width, _height, false, 128);
			
		}
		/**
		 * возмущение карты в точке [x,y]
		 * @param	x	координаты
		 * @param	y
		 * @param	d	степень возмущения, px
		 */
		public function wobbleXY (x : int, y : int, d:int=1):void {
			var dx:int = Math.round(x / 2);
			var dy:int = Math.round(y / 2);
		
			_mapBmd.setPixel (dx + d, dy, 0xFFFFFF);
			_mapBmd.setPixel (dx - d, dy, 0xFFFFFF);
			_mapBmd.setPixel (dx, dy + d, 0xFFFFFF);
			_mapBmd.setPixel (dx, dy - d, 0xFFFFFF);
			_mapBmd.setPixel (dx, dy, 0xFFFFFF);
		}
		
		/**
		 * возмущение в n рандомных точках
		 * @param	n
		 */
		public function wobble (n : int=32):void {
			for (var i:int = 0; i < n; i++) {
				wobbleXY (_width*Math.random() , _height*Math.random());
			}
		}
		
		
		
		
		/**
		 * итоговый фильтр
		 */
		public function get filter():DisplacementMapFilter { return _filter; }
		
		
		/**
		 * коэффициент
		 */
		public function get scale():Number { return _scale; }
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_filter.scaleX = 32 * value;
			_filter.scaleY = 32 * value;
		}
		
		
		
	}
	
}
