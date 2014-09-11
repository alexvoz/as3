package ua.olexandr.managers {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import ua.olexandr.debug.Logger;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class NativeCursorManager {
		
		private static var _hash:Object = { };
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isAvailable():Boolean {
			return Mouse.supportsCursor && Mouse.supportsNativeCursor;
		}
		
		/**
		 * 
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function has(value:String):Boolean {
			return _hash.hasOwnProperty(value) && _hash[value];
		}
		
		/**
		 * 
		 * @param	value
		 * @param	data
		 * @param	hotSpot
		 * @param	frameRate
		 */
		[Inline]
		public static function add(value:String, data:Vector.<BitmapData>, hotSpot:Point = null, frameRate:Number = NaN):void {
			if (isAvailable() && !has(value)) {
				var cursor:MouseCursorData = new MouseCursorData();
				cursor.data = data;
				
				cursor.hotSpot = hotSpot || new Point(0, 0);
				cursor.frameRate = frameRate || 0;
				
				try {
					Mouse.registerCursor(value, cursor);
				} catch (err:Error) {
					Logger.error(err.message);
					return;
				}
				
				_hash[value] = true;
			}
		}
		
		/**
		 * 
		 * @param	value
		 */
		[Inline]
		public static function remove(value:String):void {
			if (isAvailable() && has(value)) {
				Mouse.unregisterCursor(value);
				_hash[value] = false;
			}
		}
		
		/**
		 * 
		 * @param	value
		 */
		[Inline]
		public static function setCursor(value:String):void {
			if (isAvailable() && has(value))
				Mouse.cursor = value;
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function setAuto():void {
			if (isAvailable())
				Mouse.cursor = MouseCursor.AUTO;
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function setArrow():void {
			if (isAvailable())
				Mouse.cursor = MouseCursor.ARROW;
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function setButton():void {
			if (isAvailable())
				Mouse.cursor = MouseCursor.BUTTON;
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function setHand():void {
			if (isAvailable())
				Mouse.cursor = MouseCursor.HAND;
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function setIBeam():void {
			if (isAvailable())
				Mouse.cursor = MouseCursor.IBEAM;
		}
		
	}

}