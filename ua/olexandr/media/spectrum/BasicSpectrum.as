package ua.olexandr.media.spectrum {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
	public class BasicSpectrum extends ResizableObject implements ISpectrum {
		
		private var _bmpData:BitmapData;
		private var _bitmap:Bitmap;
		
		private var _colorTransform:ColorTransform;
		private var _rect:Rectangle;
		private var _colors:Array;
		
		/**
		 * 
		 */
		public function BasicSpectrum() {
			_rect = new Rectangle(0, 0, 6, 0);
			_colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
			_colors = getGradientColors();
		}
		
		/**
		 * 
		 * @param	bytes
		 */
		public function render(bytes:ByteArray):void {
			if (_bmpData) {
				var i:int = 128;
				
				_bmpData.colorTransform(_bmpData.rect, _colorTransform);
				
				while (--i > -1) {
					bytes.position = i * 16;
					var offset:int = bytes.readFloat() * 200;
					
					_rect.x = (7 * i);
					
					if (offset >= 0) {
						_rect.y = 200 - offset;
						_rect.height = offset;
						_bmpData.fillRect(_rect, _colors[i]);
					} else {
						_rect.y = 200;
						_rect.height = -offset;
						_bmpData.fillRect(_rect, _colors[i])
					}
				}
				
				_bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(0, 0), new BlurFilter(0, 4, 2));
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
			
			_bmpData = new BitmapData(_width, _height, false, 0);
			_bitmap = new Bitmap(_bmpData);
			addChild(_bitmap);
		}
		
		
		private function getGradientColors():Array {
			var _colors:Array = [];
			var shape:Shape = new Shape();
			var bitmapGradient:BitmapData = new BitmapData(256, 1, false, 0);
			
			var colors:Array = [0xff0000, 0xffff00, 0x00ff00];
			var alphas:Array = [100, 100, 100];
			var ratios:Array = [20, 128, 192];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(128, 1, 0, 0);
			
			shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.REPEAT);
			shape.graphics.drawRect(0, 0, 256, 1);
			shape.graphics.endFill();
			bitmapGradient.draw(shape);
			
			for (var i:int = 0; i < 256; i++)
				_colors[i] = bitmapGradient.getPixel(i, 0);
			
			return _colors;
		}
		
	}
}
