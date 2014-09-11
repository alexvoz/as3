package ua.olexandr.tools.display {
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class HAligner {
		
		public static const L:String = 'L';
		public static const C:String = 'C';
		public static const R:String = 'R';
		
		
		private static var _calc:Boolean = false;
		
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @return
		 */
		[Inline]
		public static function alignToL(target:DisplayObject, width:Number = 0):Number {
			return align(target, width, L);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @return
		 */
		[Inline]
		public static function alignToC(target:DisplayObject, width:Number = 0):Number {
			return align(target, width, C);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @return
		 */
		[Inline]
		public static function alignToR(target:DisplayObject, width:Number = 0):Number {
			return align(target, width, R);
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @return
		 */
		[Inline]
		public static function calcToL(target:DisplayObject, width:Number = 0):Number {
			_calc = true;
			return align(target, width, L);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @return
		 */
		[Inline]
		public static function calcToC(target:DisplayObject, width:Number = 0):Number {
			_calc = true;
			return align(target, width, C);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @return
		 */
		[Inline]
		public static function calcToR(target:DisplayObject, width:Number = 0):Number {
			_calc = true;
			return align(target, width, R);
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	location
		 * @return
		 */
		[Inline]
		public static function align(target:DisplayObject, width:Number = 0, location:String = 'C'):Number {
			width ||= 0;
			location = location.toUpperCase();
			
			var _x:Number = 0;
			
			switch (location) {
				case C: {
					_x += Math.round((width - target.width) * .5);
					break;
				}
				case R: {
					_x += Math.floor(width - target.width);
					break;
				}
			}
			
			if (_calc) 	_calc = false;
			else		target.x = _x;
			
			return _x;
		}
		
	}
}