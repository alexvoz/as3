package ua.olexandr.managers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class DisplayCursorManager {
		
		private static var _stage:Stage;
		private static var _cursor:DisplayObject;
		
		/**
		 * 
		 * @param	stage
		 */
		[Inline]
		public static function init(stage:Stage):void {
			_stage = stage;
		}
		
		/**
		 * 
		 * @param	cursor
		 */
		[Inline]
		public static function show(cursor:DisplayObject):void {
			if (_cursor)
				hide();
			
			_cursor = cursor;
			
			if (_cursor) {
				if (_cursor is InteractiveObject)
					(_cursor as InteractiveObject).mouseEnabled = false;
				if (_cursor is DisplayObjectContainer)
					(_cursor as DisplayObjectContainer).mouseChildren = false;
				
				efHandler(null);
				_stage.addEventListener(Event.ENTER_FRAME, efHandler);
			}
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function hide():void {
			_stage.removeEventListener(Event.ENTER_FRAME, efHandler);
			
			_stage.removeChild(_cursor);
			_cursor = null;
			
			Mouse.show();
		}
		
		
		private static function efHandler(e:Event):void {
			Mouse.hide();
			
			_cursor.x = _stage.mouseX;
			_cursor.y = _stage.mouseY;
			
			_stage.addChild(_cursor);
		}
	}

}