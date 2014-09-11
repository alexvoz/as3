package ua.olexandr.tools.display {
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class VAligner {
		
		public static const T:String = 'T';
		public static const C:String = 'C';
		public static const B:String = 'B';
		
		
		private static var _calc:Boolean = false;
		
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @return
		 */
		[Inline]
		public static function alignToT(target:DisplayObject, height:Number = 0):Number {
			return align(target, height, T);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @return
		 */
		[Inline]
		public static function alignToC(target:DisplayObject, height:Number = 0):Number {
			return align(target, height, C);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @return
		 */
		[Inline]
		public static function alignToB(target:DisplayObject, height:Number = 0):Number {
			return align(target, height, B);
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @return
		 */
		[Inline]
		public static function calcToT(target:DisplayObject, height:Number = 0):Number {
			_calc = true;
			return align(target, height, T);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @return
		 */
		[Inline]
		public static function calcToC(target:DisplayObject, height:Number = 0):Number {
			_calc = true;
			return align(target, height, C);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @return
		 */
		[Inline]
		public static function calcToB(target:DisplayObject, height:Number = 0):Number {
			_calc = true;
			return align(target, height, B);
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @param	location
		 * @return
		 */
		[Inline]
		public static function align(target:DisplayObject, height:Number = 0, location:String = 'C'):Number {
			height ||= 0;
			location = location.toUpperCase();
			
			var _y:Number = 0;
			
			switch (location) {
				case C: {
					_y += Math.round((height - target.height) * .5);
					break;
				}
				case B: {
					_y += Math.floor(height - target.height);
					break;
				}
			}
			
			if (_calc) 	_calc = false;
			else		target.y = _y;
			
			return _y;
		}
		
	}
}