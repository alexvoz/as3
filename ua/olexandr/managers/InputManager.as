package ua.olexandr.managers {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import ua.olexandr.events.InputEvent;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	[Event(name="keyDown", type="ua.olexandr.events.InputEvent")]
	[Event(name="keyUp", type="ua.olexandr.events.InputEvent")]
	[Event(name="charDown", type="ua.olexandr.events.InputEvent")]
	[Event(name="charUp", type="ua.olexandr.events.InputEvent")]
	[Event(name="mouseDown", type="ua.olexandr.events.InputEvent")]
	[Event(name="mouseUp", type="ua.olexandr.events.InputEvent")]
	public class InputManager extends EventDispatcher {
		
		private var _stage:Stage;
		
		private var _isControlDown:Boolean;
		private var _isShiftDown:Boolean;
		private var _isAltDown:Boolean;
		
		private var _keysDown:Array;
		private var _keysListen:Array;
		
		private var _charsDown:Array;
		private var _charsListen:Array;
		
		private var _isMouseDown:Boolean;
		
		/**
		 * 
		 * @param	stage
		 */
		public function InputManager(stage:Stage) {
			reset();
			
			_stage = stage;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler); 
			
			_stage.addEventListener(Event.DEACTIVATE, deactivateHandler);
		}
		
		/**
		 * Добавить клавишу в список прослушивающихся
		 * @param	code
		 */
		public function addListenKey(code:uint):void {
			if (_keysListen.indexOf(code) == -1)
				_keysListen.push(code);
		}
		
		/**
		 * Удалить клавишу в список прослушивающихся
		 * @param	code
		 */
		public function removeListenKey(code:uint):void {
			if (_keysListen.indexOf(code) > -1)
				_keysListen.splice(_keysListen.indexOf(code), 1);
		}
		
		/**
		 * Добавить символ в список прослушивающихся
		 * @param	code
		 */
		public function addListenChar(code:uint):void {
			if (_charsListen.indexOf(code) == -1)
				_charsListen.push(code);
		}
		
		/**
		 * Удалить символ из списка прослушивающихся
		 * @param	code
		 */
		public function removeListenChar(code:uint):void {
			if (_charsListen.indexOf(code) > -1)
				_charsListen.splice(_charsListen.indexOf(code), 1);
		}
		
		/**
		 * Сбросить все нажатия
		 */
		public function reset():void {
			_isControlDown = false;
			_isAltDown = false;
			_isShiftDown = false;
			
			_keysDown = [];
			_keysListen = [];
			
			_charsDown = [];
			_charsListen = [];
			
			_isMouseDown = false;
			
			if (_stage) {
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				
				_stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler); 
				
				_stage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
				
				_stage = null;
			}
		}
		
		/**
		 * 
		 * @return
		 */
		public function isControlDown():Boolean { return _isControlDown; }
		/**
		 * 
		 * @return
		 */
		public function isShiftDown():Boolean { return _isShiftDown; }
		/**
		 * 
		 * @return
		 */
		public function isAltDown():Boolean { return _isAltDown; }
		
		/**
		 * 
		 * @param	code
		 * @return
		 */
		public function isKeyDown(code:int):Boolean { return _keysDown[code]; }
		/**
		 * 
		 * @param	code
		 * @return
		 */
		public function isCharDown(code:int):Boolean { return _charsDown[code]; }
		
		/**
		 * 
		 * @return
		 */
		public function isMouseDown():Boolean { return _isMouseDown; }
		
		/**
		 * 
		 * @param	...codes
		 * @return
		 */
		public function isKeysDown(...codes):Boolean {
			for each (var code:int in codes) {
				if (!isKeyDown(code))
					return false;
			}
			return true;
		}
		
		/**
		 * 
		 * @param	...codes
		 * @return
		 */
		public function isCharsDown(...codes):Boolean {
			for each (var code:int in codes) {
				if (!isCharDown(code))
					return false;
			}
			return true;
		}
		
		
		private function keyDownHandler(e:KeyboardEvent):void {
			_isControlDown = e.ctrlKey;
			_isShiftDown = e.shiftKey;
			_isAltDown = e.altKey;
			
			if (!_keysDown[e.keyCode]) {
				_keysDown[e.keyCode] = true;
				
				if (!_keysListen.length || _keysListen.indexOf(e.keyCode) > -1)
					dispatchEvent(createEvent(InputEvent.KEY_DOWN, e.keyCode, 0));
			}
			
			if (!_charsDown[e.charCode]) {
				_charsDown[e.charCode] = true;
				
				if (!_charsListen.length || _charsListen.indexOf(e.charCode) > -1)
					dispatchEvent(createEvent(InputEvent.CHAR_DOWN, 0, e.charCode));
			}
		}
		
		private function keyUpHandler(e:KeyboardEvent):void {
			_isControlDown = e.ctrlKey;
			_isShiftDown = e.shiftKey;
			_isAltDown = e.altKey;
			
			if (_keysDown[e.keyCode]) {
				_keysDown[e.keyCode] = false;
				
				if (!_keysListen.length || _keysListen.indexOf(e.keyCode) > -1)
					dispatchEvent(createEvent(InputEvent.KEY_UP, e.keyCode, 0));
			}
			
			if (_charsDown[e.charCode]) {
				_charsDown[e.charCode] = false;
				
				if (!_charsListen.length || _charsListen.indexOf(e.charCode) > -1)
					dispatchEvent(createEvent(InputEvent.CHAR_UP, 0, e.charCode));
			}
		}
		
		
		private function mouseDownHandler(e:MouseEvent):void {
			_isMouseDown = true;
			
			dispatchEvent(createEvent(InputEvent.MOUSE_DOWN));
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			_isMouseDown = false;
			
			dispatchEvent(createEvent(InputEvent.MOUSE_UP));
		}
		
		private function deactivateHandler(e:Event):void {
			reset();
		}
		
		
		private function createEvent(type:String, key:uint = 0, char:uint = 0):InputEvent {
			return new InputEvent(type, _isMouseDown, _isControlDown, _isAltDown, _isShiftDown, key, char);
		}
		
	}
}