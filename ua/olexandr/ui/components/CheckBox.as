package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import ua.olexandr.ui.Style;
	
	public class CheckBox extends Component {
		protected var _back:Sprite;
		protected var _button:Sprite;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _selected:Boolean = false;
		
		public function CheckBox(label:String = "") {
			_labelText = label;
		}
		
		public override function draw():void {
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, 10, 10);
			_back.graphics.endFill();
			_back.y = (_height - _back.height) / 2;
			
			_button.graphics.clear();
			_button.graphics.beginFill(Style.BUTTON_FACE);
			_button.graphics.drawRect(2, 0, 6, 6);
			_button.y = (_height - _button.height) / 2;
			
			_label.text = _labelText;
			_label.draw();
			_label.x = 12;
			_label.y = (_height - _label.height) / 2;
			
			_width = _label.x + _label.width;
			_height = _label.height;
		}
		
		public function set label(str:String):void {
			_labelText = str;
			invalidate();
		}
		
		public function get label():String {
			return _labelText;
		}
		
		public function set selected(s:Boolean):void {
			_selected = s;
			_button.visible = _selected;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public override function set enabled(value:Boolean):void {
			super.enabled = value;
			mouseChildren = false;
		}
	
		
		protected override function init():void {
			super.init();
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		}
		
		protected override function addChildren():void {
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_button = new Sprite();
			_button.filters = [getShadow(1)];
			_button.visible = false;
			addChild(_button);
			
			_label = new Label(_labelText);
			addChild(_label);
			draw();
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void {
			_selected = !_selected;
			_button.visible = _selected;
		}
		
	}
}