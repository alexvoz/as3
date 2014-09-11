package ua.olexandr.ui.components {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import ua.olexandr.ui.Style;
	
	public class Panel extends Component {
		protected var _mask:Sprite;
		protected var _background:Sprite;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _gridSize:int = 10;
		protected var _showGrid:Boolean = false;
		protected var _gridColor:uint = 0xd0d0d0;
		
		public var content:Sprite;
		
		public function Panel() {
			
		}
		
		public function addRawChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			return child;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			content.addChild(child);
			return child;
		}
		
		public override function draw():void {
			super.draw();
			_background.graphics.clear();
			_background.graphics.lineStyle(1, 0, 0.1);
			if (_color == -1) {
				_background.graphics.beginFill(Style.PANEL);
			} else {
				_background.graphics.beginFill(_color);
			}
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
			
			drawGrid();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
		}
		
		public function set shadow(b:Boolean):void {
			_shadow = b;
			if (_shadow) {
				filters = [getShadow(2, true)];
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
		
		public function set gridSize(value:int):void {
			_gridSize = value;
			invalidate();
		}
		
		public function get gridSize():int {
			return _gridSize;
		}
		
		public function set showGrid(value:Boolean):void {
			_showGrid = value;
			invalidate();
		}
		
		public function get showGrid():Boolean {
			return _showGrid;
		}
		
		public function set gridColor(value:uint):void {
			_gridColor = value;
			invalidate();
		}
		
		public function get gridColor():uint {
			return _gridColor;
		}
		
		
		protected override function init():void {
			super.init();
			setSize(100, 100);
		}
		
		protected override function addChildren():void {
			_background = new Sprite();
			super.addChild(_background);
			
			_mask = new Sprite();
			_mask.mouseEnabled = false;
			super.addChild(_mask);
			
			content = new Sprite();
			super.addChild(content);
			content.mask = _mask;
			
			filters = [getShadow(2, true)];
		}
		
		protected function drawGrid():void {
			if (!_showGrid)
				return;
			
			_background.graphics.lineStyle(0, _gridColor);
			for (var i:int = 0; i < _width; i += _gridSize) {
				_background.graphics.moveTo(i, 0);
				_background.graphics.lineTo(i, _height);
			}
			for (i = 0; i < _height; i += _gridSize) {
				_background.graphics.moveTo(0, i);
				_background.graphics.lineTo(_width, i);
			}
		}
		
	}
}