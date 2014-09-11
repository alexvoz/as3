package ua.olexandr.managers {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class DragManager {
		
		private static var _hash:Dictionary = new Dictionary();
		private static var _current:Sprite;
		
		/**
		 * 
		 * @param	target
		 * @param	dragRect
		 * @param	center
		 * @param	changeHandler
		 */
		[Inline]
		public static function add(target:Sprite, dragRect:Rectangle = null, center:Boolean = false, changeHandler:Function = null):void {
			add2(target, target, dragRect, center, changeHandler);
		}
		
		/**
		 * 
		 * @param	clickTarget
		 * @param	dragTarget
		 * @param	dragRect
		 * @param	center
		 * @param	changeHandler
		 */
		[Inline]
		public static function add2(clickTarget:Sprite, dragTarget:Sprite, dragRect:Rectangle = null, center:Boolean = false, changeHandler:Function = null):void {
			_hash[clickTarget] = new DragData(dragTarget, dragRect, changeHandler, center);
			clickTarget.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 
		 * @param	target
		 * @return
		 */
		[Inline]
		public static function has(target:Sprite):Boolean {
			return Boolean(_hash[target]);
		}
		
		/**
		 * 
		 * @param	target
		 */
		[Inline]
		public static function remove(target:Sprite):void {
			target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			delete _hash[target];
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function clear():void {
			for (var key:Object in _hash)
				remove(key as Sprite);
		}
		
		
		private static function downHandler(e:MouseEvent):void {
			if (!e.ctrlKey && !e.shiftKey) {
				_current = e.currentTarget as Sprite;
				
				_current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
				_current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
				
				var _data:DragData = _hash[_current] as DragData;
				_data.target.startDrag(_data.center, _data.rect);
			}
		}
		
		private static function moveHandler(e:MouseEvent):void {
			var _data:DragData = _hash[_current] as DragData;
			if (_data.handler is Function)
				_data.handler();
		}
		
		private static function upHandler(e:MouseEvent):void {
			var _data:DragData = _hash[_current] as DragData;
			_data.target.stopDrag();
			
			_current.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			_current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			_current = null;
		}
		
	}
}


import flash.display.Sprite;
import flash.geom.Rectangle;

internal class DragData {
	
	private var _target:Sprite;
	private var _rect:Rectangle;
	private var _handler:Function;
	private var _center:Boolean;
	
	public function DragData(target:Sprite, rect:Rectangle, handler:Function, center:Boolean) {
		_target = target;
		_rect = rect;
		_handler = handler;
		_center = center;
	}
	
	public function get target():Sprite { return _target; }
	public function get rect():Rectangle { return _rect; }
	public function get handler():Function { return _handler; }
	public function get center():Boolean { return _center; }
	
}