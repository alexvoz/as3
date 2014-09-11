package ua.olexandr.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class ScaleBitmap extends Bitmap {

		protected var _bmpData:BitmapData;
		protected var _scale9Grid:Rectangle;
		
		/**
		 * 
		 * @param	bmpData
		 * @param	pixelSnapping
		 * @param	smoothing
		 */
		public function ScaleBitmap(bmpData:BitmapData = null, pixelSnapping:String = 'auto', smoothing:Boolean = false) {
			super(bmpData, pixelSnapping, smoothing);
			_bmpData = bmpData.clone();
		}
		
		/**
		 * 
		 * @param	w
		 * @param	h
		 */
		public function setSize(w:Number, h:Number):void {
			if (_scale9Grid == null) {
				super.width = w;
				super.height = h;
			} else {
				w = Math.max(w, _bmpData.width - _scale9Grid.width);
				h = Math.max(h, _bmpData.height - _scale9Grid.height);
				resizeBitmap(w, h);
			}
		}
		
		/**
		 * 
		 */
		public function get bitmapDataOriginal():BitmapData { return _bmpData; }
		
		/**
		 * 
		 */
		override public function get bitmapData():BitmapData { return _bmpData }
		/**
		 * 
		 */
		override public function set bitmapData(bmpData:BitmapData):void {
			_bmpData = bmpData.clone();
			if (_scale9Grid != null) {
				if (!validGrid(_scale9Grid))
					_scale9Grid = null;
				setSize(bmpData.width, bmpData.height);
			} else {
				assignBitmapData(_bmpData.clone());
			}
		} 
		
		/**
		 * 
		 */
		override public function set width(w:Number):void {
			if (w != width)
				setSize(w, height);
		}
		
		/**
		 * 
		 */
		override public function set height(h:Number):void {
			if (h != height)
				setSize(width, h);
		}
		
		/**
		 * 
		 */
		override public function get scale9Grid():Rectangle { return _scale9Grid; }
		/**
		 * 
		 */
		override public function set scale9Grid(rect:Rectangle):void {
			if ((_scale9Grid == null && rect != null) || (_scale9Grid != null && !_scale9Grid.equals(rect))) {
				if (rect == null) {
					var _w:Number = width;
					var _h:Number = height;
					_scale9Grid = null;
					assignBitmapData(_bmpData.clone());
					setSize(_w, _h);
				} else {
					if (!validGrid(rect)) {
						throw (new Error("#001 - The _scale9Grid does not match the original BitmapData"));
						return;
					}
					
					_scale9Grid = rect.clone();
					resizeBitmap(width, height);
					scaleX = 1;
					scaleY = 1;
				}
			}
		}
		
		
		private function assignBitmapData(bmp:BitmapData):void {
			super.bitmapData.dispose();
			super.bitmapData = bmp;
		}
		
		private function validGrid(rect:Rectangle):Boolean {
			return rect.right <= _bmpData.width && rect.bottom <= _bmpData.height;
		}
		
		
		protected function resizeBitmap(w:Number, h:Number):void {
			var _bmpData:BitmapData = new BitmapData(w, h, true, 0x00000000);
			
			var _rowsO:Array = [0, _scale9Grid.top, _scale9Grid.bottom, _bmpData.height];
			var _colsO:Array = [0, _scale9Grid.left, _scale9Grid.right, _bmpData.width];
			
			var _rowsD:Array = [0, _scale9Grid.top, h - (_bmpData.height - _scale9Grid.bottom), h];
			var _colsD:Array = [0, _scale9Grid.left, w - (_bmpData.width - _scale9Grid.right), w];

			var _rectO:Rectangle;
			var _rectD:Rectangle;
			var _m:Matrix = new Matrix();
			
			for (var i:int = 0;i < 3; i++) {
				for (var j:int = 0 ;j < 3; j++) {
					_rectO = new Rectangle(_colsO[i], _rowsO[j], _colsO[i + 1] - _colsO[i], _rowsO[j + 1] - _rowsO[j]);
					_rectD = new Rectangle(_colsD[i], _rowsD[j], _colsD[i + 1] - _colsD[i], _rowsD[j + 1] - _rowsD[j]);
					
					_m.identity();
					_m.a = _rectD.width / _rectO.width;
					_m.d = _rectD.height / _rectO.height;
					_m.tx = _rectD.x - _rectO.x * _m.a;
					_m.ty = _rectD.y - _rectO.y * _m.d;
					
					_bmpData.draw(_bmpData, _m, null, null, _rectD, smoothing);
				}
			}
			assignBitmapData(_bmpData);
		}
	}
}