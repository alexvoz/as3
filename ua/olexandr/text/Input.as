package ua.olexandr.text {
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import ua.olexandr.text.Label;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Input extends Label {
		
		private var _placeholder:String;
		
		/**
		 * 
		 * @param	color
		 * @param	size
		 */
		public function Input(color:uint = 0x000000, size:Number = 12) {
			super(color, size);
			
			autoSize = TextFieldAutoSize.NONE;
			selectable = true;
			type = TextFieldType.INPUT;
			
			width = 100;
			
			_placeholder = '';
			
			addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}
		
		/**
		 * 
		 */
		public function get placeholder():String { return _placeholder; }
		/**
		 * 
		 */
		public function set placeholder(value:String):void {
			var _flag:Boolean = text == _placeholder;
			
			_placeholder = value;
			
			if (_flag)
				text = _placeholder;
		}
		
		
		private function focusInHandler(e:FocusEvent):void {
			if (text == _placeholder)
				text = '';
		}
		
		private function focusOutHandler(e:FocusEvent):void {
			if (text == '')
				text = _placeholder;
		}
		
	}

}