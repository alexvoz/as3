package ua.olexandr.structures {
	
	public class Array2D {
		
		protected var _arr:Array = new Array();
		protected var _w:uint = 0;
		protected var _h:uint = 0;
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 */
		public function Array2D(width:uint, height:uint) {
			_w = width;
			_h = height;
			
			fill(null);
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	value
		 */
		public function setValue(x:uint, y:uint, value:*):void {
			if (!check(x, y))
				return;
			
			_arr[(y - 1) * _w + x - 1] = value;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function getValue(x:uint, y:uint):* {
			if (!check(x, y))
				return null;
			
			return _arr[(y - 1) * _w + x - 1];
		}
		
		/**
		 * 
		 * @param	value
		 */
		public function fill(value:*):void {
			for (var i:uint = 0; i < _w * _h; i++)
				_arr[i] = value;
		}
		
		public function get width():uint { return _w; }
		
		public function get height():uint { return _h; }
		
		
		private function check(x:uint, y:uint):Boolean {
			if (x <= 0 || x > _w || y <= 0 || y > _h)
				return false;
			
			return true;
		}
		
	}
}