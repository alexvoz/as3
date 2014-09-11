package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ListItem extends Component {
		protected var _data:Object;
		protected var _label:Label;
		protected var _defaultColor:uint = 0xffffff;
		protected var _selectedColor:uint = 0xdddddd;
		protected var _rolloverColor:uint = 0xeeeeee;
		protected var _selected:Boolean;
		protected var _mouseOver:Boolean = false;
		
		public function ListItem(data:Object = null) {
			_data = data;
		}
		
		public override function draw():void {
			super.draw();
			graphics.clear();
			
			if (_selected) {
				graphics.beginFill(_selectedColor);
			} else if (_mouseOver) {
				graphics.beginFill(_rolloverColor);
			} else {
				graphics.beginFill(_defaultColor);
			}
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			if (_data == null)
				return;
			
			if (_data is String) {
				_label.text = _data as String;
			} else if (_data.hasOwnProperty("label") && _data.label is String) {
				_label.text = _data.label;
			} else {
				_label.text = _data.toString();
			}
		}
		
		public function set data(value:Object):void {
			_data = value;
			invalidate();
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			invalidate();
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set defaultColor(value:uint):void {
			_defaultColor = value;
			invalidate();
		}
		
		public function get defaultColor():uint {
			return _defaultColor;
		}
		
		public function set selectedColor(value:uint):void {
			_selectedColor = value;
			invalidate();
		}
		
		public function get selectedColor():uint {
			return _selectedColor;
		}
		
		public function set rolloverColor(value:uint):void {
			_rolloverColor = value;
			invalidate();
		}
		
		public function get rolloverColor():uint {
			return _rolloverColor;
		}
		
		
		protected override function init():void {
			super.init();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			setSize(100, 20);
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_label = new Label();
			_label.x = 5;
			addChild(_label);
			_label.draw();
		}
		
		protected function onMouseOver(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = true;
			invalidate();
		}
		
		protected function onMouseOut(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = false;
			invalidate();
		}
		
	}
}