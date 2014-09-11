package ua.olexandr.display.dialog {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ua.olexandr.display.Box;
	import ua.olexandr.text.Label;
	import ua.olexandr.tools.display.Arranger;
	import ua.olexandr.utils.DisplayUtils;
	
	public class Dialog extends Sprite {
		
		private var _buttons:Array;
		
		private var _back:Box;
		private var _label:Label;
		private var _holder:Sprite;
		
		/**
		 * 
		 * @param	message
		 * @param	okButton
		 */
		public function Dialog(message:String, okButton:Boolean = false) {
			_back = new Box(0xFFFFFF);
			addChild(_back);
			
			_label = new Label();
			_label.text = message;
			_label.move(10, 10);
			addChild(_label);
			
			_buttons = [];
			if (okButton)
				addButton("OK");
			
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		/**
		 * 
		 * @param	label
		 * @param	callback
		 * @param	...args
		 */
		public function addButton(label:String, callback:Function = null, ...args:Array):void {
			var _but:Button = new Button(label, callback, args);
			_but.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			
			_buttons.push(_but);
			
			if (stage) {
				addButtons();
				draw();
			}
		}
		
		
		private function addedHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			
			if (_buttons)
				addButtons();
			
			draw();
		}
		
		private function buttonClickHandler(e:MouseEvent):void {
			var _but:Button = e.target as Button;
			
			_but.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
			_but.call();
			
			dispatchEvent(new Event(Event.SELECT));
		}
		
		
		private function addButtons():void {
			if (_holder) 	DisplayUtils.clear(_holder);
			else			_holder = new Sprite();
			
			var _button:Button;
			var _width:uint = 50;
			
			var _len:int = _buttons.length;
			for (var i:int = 0; i < _len; i++)
				_width = Math.max(_width, (_buttons[i] as Button).width);
			
			for (i = 0; i < _len; i++) {
				_button = _buttons[i] as Button;
				_button.width = _width;
				_holder.addChild(_button);
			}
			
			var _cols:uint = Math.floor(stage.stageWidth / 2 / (_width + 10));
			Arranger.arrangeRows(_buttons, _cols, 10, 10);
			
			addChild(_holder);
		}
		
		private function draw():void {
			var _widthLimit:Number = stage.stageWidth / 2;
			var _heightExtra:uint = 10;
			
			var _width:uint;
			
			if (_label.width > _widthLimit) {
				_label.wordWrap = true;
				_label.width = _widthLimit - 20;
				_width = _widthLimit;
			} else {
				_width = ((_buttons && _holder.width > _label.width) ? _holder.width : _label.width) + 20;
			}
			
			_label.x = (_width - _label.width) / 2;
			
			if (_buttons) {
				_holder.x = (_width - _holder.width) / 2;
				_holder.y = _label.y + _label.height + 10;
				_heightExtra = 20;
			} 
			
			_back.setSize(_width, height + _heightExtra);
			
		}
		
	}
}


import flash.events.Event;
import flash.events.MouseEvent;
import ua.olexandr.display.Box;
import ua.olexandr.text.Label;

internal class Button extends Box {
	
	private var _label:Label;
	
	private var _callback:Function;
	private var _args:Array;
	
	public function Button(title:String, callback:Function, args:Array) {
		_callback = callback;
		_args = args;
		
		super(0xE6E6E6);
		addBorder(0xCECECE);
		
		_label = new Label();
		_label.text = title;
		_label.move(2, 2);
		addChild(_label);
		
		setSize(_label.width + _label.x * 2, 22);
		
		buttonMode = true;
		mouseChildren = false;
		
		addEventListener(Event.ADDED_TO_STAGE, addedHandler);
	}
	
	public function call():void {
		if (_callback is Function)
			_callback.apply(null, _args);
	}
	
	override public function set width(value:Number):void {
		_width = value < 50 ? 50 : value;
		_label.x = (width - _label.width) / 2;
		
		draw();
	}
	
	
	private function mouseHandler(e:MouseEvent):void {
		switch (e.type) {
			case MouseEvent.ROLL_OVER:
			case MouseEvent.MOUSE_UP: {
				fillColor = 0xC9C9C9;
				break;
			}
			case MouseEvent.MOUSE_DOWN: {
				fillColor = 0xF8F8F8;
				break;
			}
			default: {
				fillColor = 0xE6E6E6;
				break;
			}
		}
	}
	
	private function addedHandler(e:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		
		addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
		addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	private function onRemoved(e:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		
		removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
		removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
		removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
	}
	
}