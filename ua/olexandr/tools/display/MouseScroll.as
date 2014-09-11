package ua.olexandr.tools.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ua.olexandr.utils.MathUtils;
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class MouseScroll {
		
		/**
		 * 
		 */
		public var activeRatio:Number = .3;
		/**
		 * 
		 */
		public var speedMin:Number = 0;
		/**
		 * 
		 */
		public var speedMax:Number = 10;
		
		private var _target:DisplayObject;
		private var _holder:DisplayObjectContainer;
		
		private var _scrollY:Boolean;
		private var _scrollX:Boolean;
		
		private var _viewRect:Rectangle;
		
		private var _speedX:Number;
		private var _speedY:Number;
		
		private var _scrolling:Boolean;
		private var _helper:Sprite;
		
		/**
		 * 
		 * @param	target
		 * @param	holder
		 * @param	scrollX
		 * @param	scrollY
		 */
		public function MouseScroll(target:DisplayObject, holder:DisplayObjectContainer, scrollX:Boolean, scrollY:Boolean) {
			_target = target;
			_target.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			
			_holder = holder;
			
			_scrollX = scrollX;
			_scrollY = scrollY;
			
			_speedX = speedMin;
			_speedY = speedMin;
			
			_scrolling = false;
			_helper = new Sprite();
			startScroll();
		}
		
		/**
		 * 
		 */
		public function get viewRect():Rectangle { return _viewRect; }
		/**
		 * 
		 */
		public function set viewRect(value:Rectangle):void {
			_viewRect = value;
			
			startScroll();
		}
		
		
		private function addedHandler(e:Event):void {
			startScroll();
		}
		
		private function removedHandler(e:Event):void {
			stopScroll();
		}
		
		private function efHandler(e:Event):void {
			var _x:Number = _viewRect.x;
			var _y:Number = _viewRect.y;
			var _w:Number = _viewRect.width;
			var _h:Number = _viewRect.height;
			
			var _mx:Number = _holder.mouseX - _x;
			var _my:Number = _holder.mouseY - _y;
			
			var _speedRange:Number = speedMax - speedMin;
			var _speedXNeed:Number = speedMin;
			var _speedYNeed:Number = speedMin;
			
			if (_mx > 0 && _mx < _w && _my > 0 && _my < _h) {
				if (_target.width >= _w) {
					if (_mx / _w < activeRatio) {
						_speedXNeed += ((1 - _mx / (_w * activeRatio)) * _speedRange);
					} else if (_mx / _w > 1 - activeRatio) {
						_speedXNeed += ((1 - (_w - _mx) / (_w * activeRatio)) * _speedRange);
						_speedXNeed *= -1;
					}
				}
				
				if (_target.height >= _h) {
					if (_my / _h < activeRatio) {
						_speedYNeed += ((1 - _my / (_h * activeRatio)) * _speedRange);
					} else if (_my / _h > 1 - activeRatio) {
						_speedYNeed += ((1 - (_h - _my) / (_h * activeRatio)) * _speedRange);
						_speedYNeed *= -1;
					}
				}
			}
			
			if (_speedX >= _speedXNeed)		_speedX = Math.max(_speedXNeed, _speedX - .5);
			else if (_speedX < _speedXNeed) _speedX = Math.min(_speedXNeed, _speedX + .5);
			
			if (_speedY >= _speedYNeed)		_speedY = Math.max(_speedYNeed, _speedY - .5);
			else if (_speedY < _speedYNeed) _speedY = Math.min(_speedYNeed, _speedY + .5);
			
			
			if (_scrollX) {
				if (_target.width >= _w) {
					var _minX:Number = _x + _w - _target.width;
					_target.x = Math.min(Math.max(_target.x + _speedX, _minX), _x);
				} else {
					_target.x = _x;
				}
			}
			
			if (_scrollY) {
				if (_target.height >= _h) {
					var _minY:Number = _y + _h - _target.height;
					_target.y = Math.min(Math.max(_target.y + _speedY, _minY), _y);
				} else {
					_target.y = _y;
				}
			}
		}
		
		
		private function startScroll():void {
			if (!_scrolling && _target.stage && _viewRect) {
				_scrolling = true;
				_helper.addEventListener(Event.ENTER_FRAME, efHandler);
			}
		}
		
		private function stopScroll():void {
			if (_scrolling) {
				_scrolling = false;
				_helper.removeEventListener(Event.ENTER_FRAME, efHandler);
			}
		}
		
	}

}