/*
   Copyright (c) 2008 NascomASLib Contributors.  See:
   http://code.google.com/p/nascomaslib

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
 */

package ua.olexandr.display.effects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	public class Pixelator extends Bitmap {
		
		private var _pixelation:Number = 0;
		private var _source:DisplayObject;
		
		/**
		 * 
		 * @param	source
		 * @param	pixelation
		 */
		public function Pixelator(source:DisplayObject, pixelation:Number = 0) {
			_pixelation = pixelation;
			this.source = source;
			updateBitmap();
		}
		
		/**
		 * 
		 */
		public function get pixelation():Number { return _pixelation; }
		/**
		 * 
		 */
		public function set pixelation(value:Number):void {
			_pixelation = value;
			updateBitmap();
		}
		
		/**
		 * 
		 */
		public function get source():DisplayObject { return _source; }
		/**
		 * 
		 */
		public function set source(value:DisplayObject):void {
			_source = value;
			if (bitmapData)
				bitmapData.dispose();
			bitmapData = new BitmapData(value.width, value.height);
			updateBitmap();
		}
		
		
		private function updateBitmap():void {
			var _scale:Number;
			var _bmpData:BitmapData;
			var _matrix:Matrix;
			
			if (_pixelation == 1) {
				_scale = 0.00001;
				_bmpData = new BitmapData(1, 1);
			} else {
				_scale = 1 - _pixelation;
				_bmpData = new BitmapData(Math.ceil(bitmapData.width * _scale), Math.ceil(bitmapData.height * _scale));
			}
			
			_matrix = new Matrix(_scale, 0, 0, _scale);
			_bmpData.draw(_source, _matrix);
			_matrix.a = _matrix.d = 1 / _scale;
			
			bitmapData.draw(_bmpData, _matrix);
			_bmpData.dispose();
		}
	
	}
}