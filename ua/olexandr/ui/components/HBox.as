package ua.olexandr.ui.components {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	[Event(name="resize",type="flash.events.Event")]
	public class HBox extends Component {
		protected var _spacing:Number = 5;
		private var _alignment:String = NONE;
		
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const MIDDLE:String = "middle";
		public static const NONE:String = "none";
		
		public function HBox() {
			super();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			child.addEventListener(Event.RESIZE, onResize);
			draw();
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject {
			super.addChildAt(child, index);
			child.addEventListener(Event.RESIZE, onResize);
			draw();
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject {
			super.removeChild(child);
			child.removeEventListener(Event.RESIZE, onResize);
			draw();
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = super.removeChildAt(index);
			child.removeEventListener(Event.RESIZE, onResize);
			draw();
			return child;
		}
		
		public override function draw():void {
			_width = 0;
			_height = 0;
			var xpos:Number = 0;
			for (var i:int = 0; i < numChildren; i++) {
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				xpos += child.width;
				xpos += _spacing;
				_width += child.width;
				_height = Math.max(_height, child.height);
			}
			doAlignment();
			_width += _spacing * (numChildren - 1);
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function set spacing(s:Number):void {
			_spacing = s;
			invalidate();
		}
		
		public function get spacing():Number {
			return _spacing;
		}
		
		public function set alignment(value:String):void {
			_alignment = value;
			invalidate();
		}
		
		public function get alignment():String {
			return _alignment;
		}
		
		
		protected function onResize(event:Event):void {
			invalidate();
		}
		
		protected function doAlignment():void {
			if (_alignment != NONE) {
				for (var i:int = 0; i < numChildren; i++) {
					var child:DisplayObject = getChildAt(i);
					if (_alignment == TOP) {
						child.y = 0;
					} else if (_alignment == BOTTOM) {
						child.y = _height - child.height;
					} else if (_alignment == MIDDLE) {
						child.y = (_height - child.height) / 2;
					}
				}
			}
		}
		
	}
}