package ua.alexvoz.display {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	
	public class Dragger extends MovieClip {
		public static const RIGTH:String = 'right';
		public static const LEFT:String = 'left';
		public static const UP:String = 'up';
		public static const DOWN:String = 'down';
		public static var STAGE:Stage;
		private static var _bX:int;
		private static var _bY:int;
		private static var _eX:int;
		private static var _eY:int;
		
		public function Dragger() {
			
		}
		
		static public function beginDrag(mc:MovieClip, rect:Rectangle = null):void {
			if (rect == null) rect = new Rectangle(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			var _rect:Rectangle = new Rectangle( -( mc.width - rect.width) + rect.x, -( mc.height - rect.height) + rect.y, (mc.width - rect.width), (mc.height - rect.height));
			_bX = STAGE.mouseX;
			_bY = STAGE.mouseY;
			STAGE.addEventListener(Event.ENTER_FRAME, XY);
			mc.startDrag(false, _rect);
			Mouse.cursor = MouseCursor.HAND;
			mc.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		static private function outHandler(e:MouseEvent):void {
			endDrag(e.target as MovieClip);
		}
		
		static private function XY(e:Event):void {
			_eX = STAGE.mouseX;
			_eY = STAGE.mouseY;
		}
		
		static public function endDrag(mc:MovieClip):Boolean {
			mc.stopDrag();
			STAGE.removeEventListener(Event.ENTER_FRAME, XY);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
			Mouse.cursor = MouseCursor.AUTO;
			var _fl:Boolean = false;
			if (!(_bX - _eX) || !(_bY - _eY)) _fl = true;
			return _fl;
		}
		
		static public function moveObj(mc:MovieClip, direct:String = 'left', step:Number = 20, rect:Rectangle = null, moveit:Boolean = false):Number {
			if (rect == null) rect = new Rectangle(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			var _delta:Number;
			if (direct == 'down' && mc.height > rect.height) {
				_delta = Math.max(rect.y - (mc.height - rect.height), mc.y - step);
				if (moveit) mc.y = _delta;
			}
			if (direct == 'up' && mc.height > rect.height) {
				_delta = Math.min(rect.y, mc.y + step);
				if (moveit) mc.y = _delta;
			}
			if (direct == 'right' && mc.width > rect.width) {
				_delta = Math.max(rect.x - (mc.width - rect.width), mc.x - step);
				if (moveit) mc.x = _delta;
			}
			if (direct == 'left' && mc.width > rect.width) {
				_delta = Math.min(rect.x, mc.x + step);
				if (moveit) mc.x = _delta;
			}
			return _delta;
		}
		
	}

}