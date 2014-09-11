package ua.olexandr.ui.components {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="select",type="flash.events.Event")]
	[Event(name="close",type="flash.events.Event")]
	[Event(name="resize",type="flash.events.Event")]
	public class Window extends Component {
		protected var _title:String;
		protected var _titleBar:Panel;
		protected var _titleLabel:Label;
		protected var _panel:Panel;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _minimizeButton:Sprite;
		protected var _hasMinimizeButton:Boolean = false;
		protected var _minimized:Boolean = false;
		protected var _hasCloseButton:Boolean;
		protected var _closeButton:PushButton;
		protected var _grips:Shape;
		
		public function Window(title:String = "Window") {
			_title = title;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			content.addChild(child);
			return child;
		}
		
		public override function draw():void {
			super.draw();
			_titleBar.color = _color;
			_panel.color = _color;
			_titleBar.width = width;
			_titleBar.draw();
			_titleLabel.x = _hasMinimizeButton ? 20 : 5;
			_closeButton.x = _width - 14;
			_grips.x = _titleLabel.x + _titleLabel.width;
			if (_hasCloseButton) {
				_grips.width = _closeButton.x - _grips.x - 2;
			} else {
				_grips.width = _width - _grips.x - 2;
			}
			_panel.setSize(_width, _height - 20);
			_panel.draw();
		}
		
		public function addRawChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			return child;
		}
		
		public function set shadow(b:Boolean):void {
			_shadow = b;
			if (_shadow) {
				filters = [getShadow(4, false)];
			} else {
				filters = [];
			}
		}
		
		public function get shadow():Boolean {
			return _shadow;
		}
		
		public function set color(c:int):void {
			_color = c;
			invalidate();
		}
		
		public function get color():int {
			return _color;
		}
		
		public function set title(t:String):void {
			_title = t;
			_titleLabel.text = _title;
		}
		
		public function get title():String {
			return _title;
		}
		
		public function get content():DisplayObjectContainer {
			return _panel.content;
		}
		
		public function set draggable(b:Boolean):void {
			_draggable = b;
			_titleBar.buttonMode = _draggable;
			_titleBar.useHandCursor = _draggable;
		}
		
		public function get draggable():Boolean {
			return _draggable;
		}
		
		public function set hasMinimizeButton(b:Boolean):void {
			_hasMinimizeButton = b;
			if (_hasMinimizeButton) {
				super.addChild(_minimizeButton);
			} else if (contains(_minimizeButton)) {
				removeChild(_minimizeButton);
			}
			invalidate();
		}
		
		public function get hasMinimizeButton():Boolean {
			return _hasMinimizeButton;
		}
		
		public function set minimized(value:Boolean):void {
			_minimized = value;
			//_panel.visible = !_minimized;
			if (_minimized) {
				if (contains(_panel))
					removeChild(_panel);
				_minimizeButton.rotation = -90;
			} else {
				if (!contains(_panel))
					super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function get minimized():Boolean {
			return _minimized;
		}
		
		public function set hasCloseButton(value:Boolean):void {
			_hasCloseButton = value;
			if (_hasCloseButton) {
				_titleBar.content.addChild(_closeButton);
			} else if (_titleBar.content.contains(_closeButton)) {
				_titleBar.content.removeChild(_closeButton);
			}
			invalidate();
		}
		
		public function get hasCloseButton():Boolean {
			return _hasCloseButton;
		}
		
		public function get titleBar():Panel {
			return _titleBar;
		}
		
		public function set titleBar(value:Panel):void {
			_titleBar = value;
		}
		
		public function get grips():Shape {
			return _grips;
		}
		
		public override function get height():Number {
			if (contains(_panel)) {
				return super.height;
			} else {
				return 20;
			}
		}
		
		
		protected override function init():void {
			super.init();
			setSize(100, 100);
		}
		
		protected override function addChildren():void {
			_titleBar = new Panel();
			_titleBar.filters = [];
			_titleBar.buttonMode = true;
			_titleBar.useHandCursor = true;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			_titleBar.height = 20;
			super.addChild(_titleBar);
			_titleLabel = new Label(_title);
			_titleLabel.move(5, 1);
			_titleBar.content.addChild(_titleLabel);
			
			_grips = new Shape();
			for (var i:int = 0; i < 4; i++) {
				_grips.graphics.lineStyle(1, 0xffffff, .55);
				_grips.graphics.moveTo(0, 3 + i * 4);
				_grips.graphics.lineTo(100, 3 + i * 4);
				_grips.graphics.lineStyle(1, 0, .125);
				_grips.graphics.moveTo(0, 4 + i * 4);
				_grips.graphics.lineTo(100, 4 + i * 4);
			}
			_titleBar.content.addChild(_grips);
			_grips.visible = false;
			
			_panel = new Panel();
			_panel.y = 20;
			_panel.visible = !_minimized;
			super.addChild(_panel);
			
			_minimizeButton = new Sprite();
			_minimizeButton.graphics.beginFill(0, 0);
			_minimizeButton.graphics.drawRect(-10, -10, 20, 20);
			_minimizeButton.graphics.endFill();
			_minimizeButton.graphics.beginFill(0, .35);
			_minimizeButton.graphics.moveTo(-5, -3);
			_minimizeButton.graphics.lineTo(5, -3);
			_minimizeButton.graphics.lineTo(0, 4);
			_minimizeButton.graphics.lineTo(-5, -3);
			_minimizeButton.graphics.endFill();
			_minimizeButton.x = 10;
			_minimizeButton.y = 10;
			_minimizeButton.useHandCursor = true;
			_minimizeButton.buttonMode = true;
			_minimizeButton.addEventListener(MouseEvent.CLICK, onMinimize);
			
			_closeButton = new PushButton("");
			_closeButton.move(86, 6);
			_closeButton.setSize(8, 8);
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			
			filters = [getShadow(4, false)];
		}
		
		protected function onMouseGoDown(event:MouseEvent):void {
			if (_draggable) {
				this.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
				parent.addChild(this); // move to top
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		protected function onMouseGoUp(event:MouseEvent):void {
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMinimize(event:MouseEvent):void {
			minimized = !minimized;
		}
		
		protected function onClose(event:MouseEvent):void {
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}
}