/*
   Copyright (c) 2008 NascomASLib Contributors.  See:
   http://code.google.com/p/nascomaslib

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
 */

package ua.olexandr.modules {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;
	import ua.olexandr.tools.tweener.Easing;
	import ua.olexandr.tools.tweener.Tweener;
	
	public class Carousel extends MovieClip {
		
		private var _items:Array = [];
		
		private var _depthOfField:Number = 0;
		
		private var _rotation:Number = 0;
		private var _zValues:Dictionary = new Dictionary();
		
		private var _horizontalRadius:Number, _verticalRadius:Number;
		private var _rotPerItem:Number;
		
		private var _orders:Dictionary = new Dictionary();
		private var _blurFilters:Dictionary = new Dictionary();
		
		private var _perspectiveCorrect:Boolean = true;
		private var _currentRotationSpeed:Number = 0;
		private var _rotationSpeed:Number = 0.05;
		
		private var _hitField:Sprite;
		
		/**
		 * 
		 * @param	horizontalRadius
		 * @param	verticalRadius
		 * @param	hitField
		 * @param	perspectiveCorrect
		 */
		public function Carousel(horizontalRadius:Number, verticalRadius:Number, hitField:Sprite = null, perspectiveCorrect:Boolean = false) {
			_hitField = hitField;
			_horizontalRadius = horizontalRadius;
			_verticalRadius = verticalRadius;
			_perspectiveCorrect = perspectiveCorrect;
			this.buttonMode = true;
			super();
		}
		
		/**
		 * 
		 * @param	child
		 * @return
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			var superReturn:DisplayObject = super.addChild(child);
			_blurFilters[child] = new BlurFilter(0, 0);
			_orders[child] = _items.length;
			_items.push(child);
			_rotPerItem = 2 * Math.PI / _items.length;
			updateItemPositions();
			child.addEventListener(MouseEvent.CLICK, handleItemClick);
			return superReturn;
		}
		
		/**
		 * 
		 */
		public function autoRotate():void {
			_currentRotationSpeed = 0;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * 
		 */
		public function stopAutoRotate():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * 
		 * @param	child
		 */
		public function centerToChild(child:DisplayObject):void {
			var i:int = _items.length;
			var current:DisplayObject;
			var newAngle:Number = Math.PI * 2 - _orders[child] * _rotPerItem;
			var currentAngle:Number = _rotation;
			
			/* reset angle within bounds [0, Math.PI*2] for comparison with new angle */
			while (currentAngle > Math.PI * 2)
				currentAngle-= Math.PI * 2;
			
			while (currentAngle < 0)
				currentAngle += Math.PI * 2;
			
			_rotation = currentAngle;
			
			/* find shortest route to new position */
			if (Math.abs(newAngle - _rotation) > Math.PI) {
				if (newAngle < _rotation)	newAngle += 2 * Math.PI;
				else						newAngle -= 2 * Math.PI;
			}
			
			stopAutoRotate();
			
			Tweener.addTween(this, 1, {angle : newAngle, ease:Easing.quadOut});
		}
		
		/**
		 * 
		 */
		public function get angle():Number { return _rotation; }
		/**
		 * 
		 */
		public function set angle(value:Number):void {
			_rotation = value;
			updateItemPositions();
		}
		
		/**
		 * 
		 */
		public function get horizontalRadius():Number { return _horizontalRadius; }
		/**
		 * 
		 */
		public function set horizontalRadius(value:Number):void { _horizontalRadius = value; }
		
		/**
		 * 
		 */
		public function get verticalRadius():Number { return _verticalRadius; }
		/**
		 * 
		 */
		public function set verticalRadius(value:Number):void { _verticalRadius = value; }
		
		/**
		 * 
		 */
		public function get depthOfField():Number { return _depthOfField; }
		/**
		 * 
		 */
		public function set depthOfField(value:Number):void {
			if (value == 0) {
				for (var i:int = 0; i < _items.length; i++)
					removeBlur(_items[i]);
			}
			_depthOfField = value;
		}
		
		/**
		 * 
		 */
		public function get perspectiveCorrect():Boolean { return _perspectiveCorrect; }
		/**
		 * 
		 */
		public function set perspectiveCorrect(value:Boolean):void {
			_perspectiveCorrect = value;
			updateItemPositions();
		}
		
		/**
		 * 
		 */
		public function get rotationSpeed():Number { return _rotationSpeed; }
		/**
		 * 
		 */
		public function set rotationSpeed(value:Number):void { _rotationSpeed = value; }
		
		/**
		 * 
		 */
		public function get currentRotationSpeed():Number { return _currentRotationSpeed; }
		/**
		 * 
		 */
		public function set currentRotationSpeed(value:Number):void { _currentRotationSpeed = value; }
		
		
		private function updateItemPositions():void {
			var i:int = _items.length;
			var current:DisplayObject;
			var itemRotation:Number;
			var x:Number, z:Number;
			
			while (current = _items[--i] as DisplayObject) {
				itemRotation = _rotation + _rotPerItem * _orders[current];
				z = 2 - Math.cos(itemRotation);
				x = Math.sin(itemRotation);
				
				if (_perspectiveCorrect) {
					current.x = 2 * x / z * _horizontalRadius - current.getBounds(current).x;
					current.y = (z - 2) / z * _verticalRadius - current.getBounds(current).y;
				} else {
					current.x = x * _horizontalRadius - current.getBounds(current).x;
					current.y = (z - 3) * _verticalRadius;
				}
				
				_zValues[current] = z;
				
				current.scaleX = 1 / z;
				current.scaleY = 1 / z;
				
				updateBlur(current, z);
			}
			sortChildren();
		}
		
		private function updateBlur(target:DisplayObject, zIndex:Number):void {
			if (_depthOfField != 0) {
				var strength:Number = (zIndex - 1) * _depthOfField * .5;
				var blurFilter:BlurFilter = _blurFilters[target] as BlurFilter;
				blurFilter.blurX = strength;
				blurFilter.blurY = strength;
				target.filters = [blurFilter];
			} else
				target.filters = null;
		}
		
		private function removeBlur(target:DisplayObject):Array {
			var filters:Array = target.filters;
			var blurFilter:BlurFilter = _blurFilters[target] as BlurFilter;
			for (var i:int = 0; i < filters.length; i++) {
				if (filters[i] == blurFilter)
					filters.splice(i, 1);
			}
			return filters;
		}
		
		private function sortChildren():void {
			var next:DisplayObject;
			var current:DisplayObject;
			var i:int;
			var len:int = _items.length;
			
			// a bubble sort algorithm
			for (var j:int = 0; j < len - 2; j++) {
				i = len;
				while (current = _items[--i] as DisplayObject) {
					next = _items[i - 1];
					
					if (next && _zValues[current] > _zValues[next] && getChildIndex(current) > getChildIndex(next)) {
						_items.splice(i - 1, 1);
						_items.splice(i, 0, next);
						swapChildren(current, next);
					}
				}
			}
		}
		
		private function handleMouseMove(event:MouseEvent):void {
			var newSpeed:Number;
			
			// need mouseMovement on the bounding box, not the actual shape
			if ((_hitField && _hitField.hitTestPoint(stage.mouseX, stage.mouseY)) || (!_hitField && hitTestPoint(stage.mouseX, stage.mouseY)))
				newSpeed = -mouseX / _horizontalRadius * _rotationSpeed;
			else
				newSpeed = 0;
			
			Tweener.addTween(this, .35, {currentRotationSpeed : newSpeed, ease:Easing.none} );
		}
		
		private function handleEnterFrame(event:Event):void {
			angle += _currentRotationSpeed;
		}
		
		private function handleItemClick(event:MouseEvent):void {
			centerToChild(event.target as DisplayObject);
		}
	}
}