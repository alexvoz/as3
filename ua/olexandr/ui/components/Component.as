package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import ua.olexandr.ui.Style;
	
	[Event(name="resize",type="flash.events.Event")]
	[Event(name="render",type="flash.events.Event")]
	public class Component extends Sprite {
		// Flex 4.x sdk:
		[Embed(source = "../assets/Dpix_8pt.ttf", embedAsCFF = "false", fontName = "Dpix", mimeType = "application/x-font")]
		protected var Dpix:Class;
		
		// Flex 3.x sdk:
		//[Embed(source = "/assets/Dpix_8pt.ttf", fontName = "Dpix", mimeType = "application/x-font")]
		//protected var Dpix:Class;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _tag:int = -1;
		protected var _enabled:Boolean = true;
		
		public function Component() {
			init();
			if (parent != null)
				parent.addChild(this);
		}
		
		public function move(xpos:Number, ypos:Number):void {
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		public function setSize(w:Number, h:Number):void {
			_width = Math.round(w);
			_height = Math.round(h);
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}
		
		public function draw():void {
			dispatchEvent(new Event(Event.RENDER));
		}
		
		public override function set width(w:Number):void {
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public override function get width():Number {
			return _width;
		}
		
		public override function set height(h:Number):void {
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public override function get height():Number {
			return _height;
		}
		
		public override function set x(value:Number):void {
			super.x = Math.round(value);
		}
		
		public override function set y(value:Number):void {
			super.y = Math.round(value);
		}
		
		public function set tag(value:int):void {
			_tag = value;
		}
		
		public function get tag():int {
			return _tag;
		}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			tabEnabled = value;
			alpha = _enabled ? 1.0 : 0.5;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		
		protected function init():void {
			addChildren();
			invalidate();
		}
		
		protected function addChildren():void {
		
		}
		
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter {
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
		protected function invalidate():void {
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		protected function onInvalidate(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
	}
}