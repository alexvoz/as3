package ua.olexandr.tools.display {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ua.olexandr.constants.AlignConst;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Aligner {
		
		private static var _calc:Boolean = false;
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToTL(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.TL);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToTC(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.TC);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToTR(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.TR);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToCL(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.CL);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToCC(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.CC);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToCR(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.CR);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToBL(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.BL);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToBC(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.BC);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calcToBR(target:DisplayObject, rect:Rectangle = null):Point {
			return calc(target, rect, AlignConst.BR);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function calc(target:DisplayObject, rect:Rectangle = null, location:String = 'CC'):Point {
			_calc = true;
			return align(target, rect, location);
		}
		
		
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToTL(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.TL);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToTC(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.TC);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToTR(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.TR);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToCL(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.CL);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToCC(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.CC);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToCR(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.CR);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToBL(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.BL);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToBC(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.BC);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @return
		 */
		[Inline]
		public static function alignToBR(target:DisplayObject, rect:Rectangle = null):Point {
			return align(target, rect, AlignConst.BR);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	rect
		 * @param	location
		 * @return
		 */
		[Inline]
		public static function align(target:DisplayObject, rect:Rectangle = null, location:String = 'CC'):Point {
			rect ||= new Rectangle(0, 0, 0, 0);
			location = location.toUpperCase();
			
			var _p:Point = new Point();
			
			switch (location) {
				case AlignConst.TL: {
					_p.x = Math.ceil(rect.x);
					_p.y = Math.ceil(rect.y);
					break;
				}
				case AlignConst.TC: {
					_p.x = Math.round(rect.x + (rect.width - target.width) * .5);
					_p.y = Math.ceil(rect.y);
					break;
				}
				case AlignConst.TR: {
					_p.x = Math.floor(rect.x + rect.width - target.width);
					_p.y = Math.ceil(rect.y);
					break;
				}
				case AlignConst.CL: {
					_p.x = Math.ceil(rect.x);
					_p.y = Math.round(rect.y + (rect.height - target.height) * .5);
					break;
				}
				case AlignConst.CR: {
					_p.x = Math.floor(rect.x + rect.width - target.width);
					_p.y = Math.round(rect.y + (rect.height - target.height) * .5);
					break;
				}
				case AlignConst.BL: {
					_p.x = Math.ceil(rect.x);
					_p.y = Math.floor(rect.y + rect.height - target.height);
					break;
				}
				case AlignConst.BC: {
					_p.x = Math.round(rect.x + (rect.width - target.width) * .5);
					_p.y = Math.floor(rect.y + rect.height - target.height);
					break;
				}
				case AlignConst.BR: {
					_p.x = Math.floor(rect.x + rect.width - target.width);
					_p.y = Math.floor(rect.y + rect.height - target.height);
					break;
				}
				default: {
					_p.x = Math.round(rect.x + (rect.width - target.width) * .5);
					_p.y = Math.round(rect.y + (rect.height - target.height) * .5);
					break;
				}
			}
			
			if (_calc) {
				_calc = false;
			} else {
				target.x = _p.x;
				target.y = _p.y;
			}
			
			return _p;
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	isParent
		 * @return
		 */
		[Inline]
		public static function getRect(target:DisplayObject, isParent:Boolean = true):Rectangle {
			var _rect:Rectangle = new Rectangle();
			
			if (!isParent) {
				_rect.x = target.x;
				_rect.y = target.y;
			}
			
			if (target is Stage) {
				_rect.width = (target as Stage).stageWidth;
				_rect.height = (target as Stage).stageHeight;
			} else {
				_rect.width = target.width;
				_rect.height = target.height;
			}
			
			return _rect;
		}
		
	}
}
