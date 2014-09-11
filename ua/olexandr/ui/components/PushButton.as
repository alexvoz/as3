package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import ua.olexandr.ui.Style;
	
	public class PushButton extends Component {
		
		protected var _back:Sprite;
		protected var _face:Sprite;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		protected var _selected:Boolean = false;
		protected var _toggle:Boolean = false;
		
		public function PushButton(label:String = "") {
			super();
			
			this.label = label;
		}
		
		public override function draw():void {
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
			
			drawFace();
			
			_label.text = _labelText;
			_label.autoSize = true;
			_label.draw();
			if (_label.width > _width - 4) {
				_label.autoSize = false;
				_label.width = _width - 4;
			} else {
				_label.autoSize = true;
			}
			_label.draw();
			_label.move(_width / 2 - _label.width / 2, _height / 2 - _label.height / 2);
		
		}
		
		public function set label(str:String):void {
			_labelText = str;
			draw();
		}
		
		public function get label():String {
			return _labelText;
		}
		
		public function set selected(value:Boolean):void {
			if (!_toggle)
				value = false;
			
			_selected = value;
			_down = _selected;
			_face.filters = [getShadow(1, _selected)];
			drawFace();
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set toggle(value:Boolean):void {
			_toggle = value;
		}
		
		public function get toggle():Boolean {
			return _toggle;
		}
		
		
		protected override function init():void {
			super.init();
			buttonMode = true;
			useHandCursor = true;
			setSize(100, 20);
		}
		
		protected override function addChildren():void {
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			_back.mouseEnabled = false;
			addChild(_back);
			
			_face = new Sprite();
			_face.mouseEnabled = false;
			_face.filters = [getShadow(1)];
			_face.x = 1;
			_face.y = 1;
			addChild(_face);
			
			_label = new Label();
			addChild(_label);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		protected function drawFace():void {
			_face.graphics.clear();
			if (_down) {
				_face.graphics.beginFill(Style.BUTTON_DOWN);
			} else {
				_face.graphics.beginFill(Style.BUTTON_FACE);
			}
			_face.graphics.drawRect(0, 0, _width - 2, _height - 2);
			_face.graphics.endFill();
		}
		
		protected function onMouseOver(event:MouseEvent):void {
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void {
			_over = false;
			if (!_down)
				_face.filters = [getShadow(1)];
			
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		protected function onMouseGoDown(event:MouseEvent):void {
			_down = true;
			drawFace();
			_face.filters = [getShadow(1, true)];
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMouseGoUp(event:MouseEvent):void {
			if (_toggle && _over)
				_selected = !_selected;
			
			_down = _selected;
			drawFace();
			_face.filters = [getShadow(1, _selected)];
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
	}
}