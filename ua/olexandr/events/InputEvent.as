package ua.olexandr.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class InputEvent extends Event {
		
		public static const KEY_DOWN:String = 'keyDown';
		public static const KEY_UP:String = 'keyUp';
	 
		public static const CHAR_DOWN:String = 'charDown';
		public static const CHAR_UP:String = 'charUp';
	 
		public static const MOUSE_DOWN:String = 'mouseDown';
		public static const MOUSE_UP:String = 'mouseUp';
		
		
		private var _isMouseDown:Boolean;
		
		private var _isControlDown:Boolean;
		private var _isAltDown:Boolean;
		private var _isShiftDown:Boolean;
		
		private var _keyCode:uint;
		private var _charCode:uint;
		
		/**
		 * Creates an InputEvent object to pass as a parameter to event listeners.
		 * @param	type
		 * @param	mouse
		 * @param	control
		 * @param	alt
		 * @param	shift
		 * @param	key
		 * @param	char
		 */
		public function InputEvent(type:String, mouse:Boolean, control:Boolean, alt:Boolean, shift:Boolean, key:uint = 0, char:uint = 0) {
			super(type, false, false);
			
			_isMouseDown = mouse;
			
			_isControlDown = control;
			_isAltDown = alt;
			_isShiftDown = shift;
			
			_keyCode = key;
			_charCode = char;
		} 
		
		/**
		 * 
		 */
		public function get isMouseDown():Boolean { return _isMouseDown; }
		
		/**
		 * 
		 */
		public function get isShiftDown():Boolean { return _isShiftDown; }
		/**
		 * 
		 */
		public function get isAltDown():Boolean { return _isAltDown; }
		/**
		 * 
		 */
		public function get isControlDown():Boolean { return _isControlDown; }
		
		/**
		 * 
		 */
		public function get keyCode():uint { return _keyCode; }
		/**
		 * 
		 */
		public function get charCode():uint { return _charCode; }
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * @return
		 */
		public override function clone():Event { 
			return new InputEvent(type, _isMouseDown, _isControlDown, _isAltDown, _isShiftDown, _keyCode, _charCode);
		} 
		
		/**
		 * Returns a string containing all the properties of the InputEvent object.
		 * @return
		 */
		public override function toString():String { 
			return formatToString("InputEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}