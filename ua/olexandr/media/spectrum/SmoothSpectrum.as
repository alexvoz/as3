package ua.olexandr.media.spectrum {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import ua.olexandr.display.ResizableObject;
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class SmoothSpectrum extends ResizableObject implements ISpectrum {
		
		private var _color2:uint;
		private var _color1:uint;
		
		private var _plotH:int;
		
		private var _shape:Shape;
		private var _bmpData:BitmapData;
		private var _bitmap:Bitmap;
		
		/**
		 * 
		 * @param	color1
		 * @param	color2
		 */
		public function SmoothSpectrum(color1:uint = 0x666666, color2:uint = 0x999999) {
			_color1 = color1;
			_color2 = color2;
			
			_shape = new Shape();
		}
		
		/**
		 * 
		 * @param	bytes
		 */
		public function render(bytes:ByteArray):void {
			if (_bmpData) {
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(_width, 1, 0, 0, 0);
				
				_shape.graphics.clear();
				_shape.graphics.lineStyle(1);
				_shape.graphics.lineGradientStyle(GradientType.LINEAR, [_color1, _color2], [100, 100], [0, 255], matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, .1);
				
				var _points:Array = [];
				var i:int = 16;
				while (--i > -1) {
					bytes.position = i * 128;
					_points[i] = new Point(40 * i - 20, int(200 - bytes.readFloat() * _plotH));
				}
				
				var _pointsMid:Array = [];
				var _len:int = _points.length;
				for (i = 1; i < _len; i++) {
					var _x:int = (_points[i].x + _points[i - 1].x) * .5;
					var _y:int = (_points[i].y + _points[i - 1].y) * .5;
					
					_pointsMid[i - 1] = new Point(_x, _y);
				}
				
				_shape.graphics.moveTo(_pointsMid[0].x, _pointsMid[0].y);
				
				_len--;
				for (i = 1; i < _len; i++)
					_shape.graphics.curveTo(_points[i].x, _points[i].y, _pointsMid[i].x, _pointsMid[i].y);
				
				_bmpData.scroll(1, 0);
				_bmpData.draw(_shape, null, null, BlendMode.ADD);
				_bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(0, 0), new BlurFilter(2, 2, 2));
			}
		}
		
		/**
		 * 
		 */
		override public function draw():void {
			if (_bitmap) {
				removeChild(_bitmap);
				
				_bmpData.dispose();
				
				_bitmap.bitmapData = null;
				_bitmap = null;
			}
			
			_bmpData = new BitmapData(_width, _height, true, 0);
			_bitmap = new Bitmap(_bmpData);
			addChild(_bitmap);
			
			_plotH = _height * .5;
		}
	
	}
}
