package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollPane extends Panel {
		protected var _vScrollbar:VScrollBar;
		protected var _hScrollbar:HScrollBar;
		protected var _corner:Shape;
		protected var _dragContent:Boolean = true;
		
		public function ScrollPane() {
			super();
		}
		
		public function update():void {
			invalidate();
		}
		
		public override function draw():void {
			super.draw();
			
			var vPercent:Number = (_height - 10) / content.height;
			var hPercent:Number = (_width - 10) / content.width;
			
			_vScrollbar.x = width - 10;
			_hScrollbar.y = height - 10;
			
			if (hPercent >= 1) {
				_vScrollbar.height = height;
				_mask.height = height;
			} else {
				_vScrollbar.height = height - 10;
				_mask.height = height - 10;
			}
			if (vPercent >= 1) {
				_hScrollbar.width = width;
				_mask.width = width;
			} else {
				_hScrollbar.width = width - 10;
				_mask.width = width - 10;
			}
			_vScrollbar.setThumbPercent(vPercent);
			_vScrollbar.maximum = Math.max(0, content.height - _height + 10);
			_vScrollbar.pageSize = _height - 10;
			
			_hScrollbar.setThumbPercent(hPercent);
			_hScrollbar.maximum = Math.max(0, content.width - _width + 10);
			_hScrollbar.pageSize = _width - 10;
			
			_corner.x = width - 10;
			_corner.y = height - 10;
			_corner.visible = (hPercent < 1) && (vPercent < 1);
			content.x = -_hScrollbar.value;
			content.y = -_vScrollbar.value;
		}
		
		public function set dragContent(value:Boolean):void {
			_dragContent = value;
			if (_dragContent) {
				_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
				_background.useHandCursor = true;
				_background.buttonMode = true;
			} else {
				_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
				_background.useHandCursor = false;
				_background.buttonMode = false;
			}
		}
		
		public function get dragContent():Boolean {
			return _dragContent;
		}
		
		public function set autoHideScrollBar(value:Boolean):void {
			_vScrollbar.autoHide = value;
			_hScrollbar.autoHide = value;
		}
		
		public function get autoHideScrollBar():Boolean {
			return _vScrollbar.autoHide;
		}
	
		
		protected override function init():void {
			super.init();
			addEventListener(Event.RESIZE, onResize);
			_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			_background.useHandCursor = true;
			_background.buttonMode = true;
			setSize(100, 100);
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_vScrollbar = new VScrollBar(null, width - 10, 0, onScroll);
			_hScrollbar = new HScrollBar(null, 0, height - 10, onScroll);
			addRawChild(_vScrollbar);
			addRawChild(_hScrollbar);
			_corner = new Shape();
			_corner.graphics.beginFill(Style.BUTTON_FACE);
			_corner.graphics.drawRect(0, 0, 10, 10);
			_corner.graphics.endFill();
			addRawChild(_corner);
		}
		
		protected function onScroll(event:Event):void {
			content.x = -_hScrollbar.value;
			content.y = -_vScrollbar.value;
		}
		
		protected function onResize(event:Event):void {
			invalidate();
		}
		
		protected function onMouseGoDown(event:MouseEvent):void {
			content.startDrag(false, new Rectangle(0, 0, Math.min(0, _width - content.width - 10), Math.min(0, _height - content.height - 10)));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMouseMove(event:MouseEvent):void {
			_hScrollbar.value = -content.x;
			_vScrollbar.value = -content.y;
		}
		
		protected function onMouseGoUp(event:MouseEvent):void {
			content.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
	}
}