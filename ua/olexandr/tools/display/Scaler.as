package ua.olexandr.tools.display {
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Scaler {
		
		public static const INSIDE:String = 'inside';
		public static const OUTSIDE:String = 'outside';
		public static const STRETCH:String = 'stretch';
		public static const WIDTH:String = 'width';
		public static const HEIGHT:String = 'height';
		public static const NONE:String = 'none';
		
		
		private static var _calc:Boolean = false;
		
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function calcInside(target:DisplayObject, width:Number, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return calc(target, width, height, INSIDE, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function calcOutside(target:DisplayObject, width:Number, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return calc(target, width, height, OUTSIDE, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function calcWidth(target:DisplayObject, width:Number, max:Number = NaN, min:Number = NaN):Number {
			return calc(target, width, 0, WIDTH, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function calcHeight(target:DisplayObject, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return calc(target, 0, height, HEIGHT, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	type
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function calc(target:DisplayObject, width:Number, height:Number, type:String, max:Number = NaN, min:Number = NaN):Number {
			_calc = true;
			return scale(target, width, height, type, max, min);
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function scaleInside(target:DisplayObject, width:Number, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return scale(target, width, height, INSIDE, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function scaleOutside(target:DisplayObject, width:Number, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return scale(target, width, height, OUTSIDE, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function scaleStretch(target:DisplayObject, width:Number, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return scale(target, width, height, STRETCH, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function scaleWidth(target:DisplayObject, width:Number, max:Number = NaN, min:Number = NaN):Number {
			return scale(target, width, 0, WIDTH, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	height
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function scaleHeight(target:DisplayObject, height:Number, max:Number = NaN, min:Number = NaN):Number {
			return scale(target, 0, height, HEIGHT, max, min);
		}
		
		/**
		 * 
		 * @param	target
		 * @return
		 */
		[Inline]
		public static function scaleNone(target:DisplayObject):Number {
			return scale(target, 0, 0, NONE);
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	type
		 * @param	max
		 * @param	min
		 * @return
		 */
		[Inline]
		public static function scale(target:DisplayObject, width:Number, height:Number, type:String, max:Number = NaN, min:Number = NaN):Number {
			var _kW:Number = width / target.width * target.scaleX;
			var _kH:Number = height / target.height * target.scaleY;
			
			if (!isNaN(max)) {
				_kW = Math.min(_kW, max);
				_kH = Math.min(_kH, max);
			}
			
			if (!isNaN(min)) {
				_kW = Math.max(_kW, min);
				_kH = Math.max(_kH, min);
			}
			
			if (_kW == Infinity || _kH == Infinity)
				type = NONE;
			
			var _res:Number;
			
			switch(type) {
				case INSIDE: {
					_res = _kW = _kH = Math.min(_kW, _kH);
					break;
				}
				case OUTSIDE: {
					_res = _kW = _kH = Math.max(_kW, _kH);
					break;
				}
				case STRETCH: {
					break;
				}
				case WIDTH: {
					_kH = _kW;
					_res = _kW
					break;
				}
				case HEIGHT: {
					_kW = _kH;
					_res = _kH;
					break;
				}
				default: {
					_kW = 1;
					_kH = 1;
					_res = 1;
					break;
				}
			}
			
			if (_calc) {
				_calc = false;
			} else {
				target.scaleX = _kW;
				target.scaleY = _kH;
			}
			
			return _res;
		}
		
	}

}