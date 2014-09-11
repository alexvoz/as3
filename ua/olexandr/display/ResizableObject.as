package ua.olexandr.display {
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	[Event(name="resize", type="flash.events.Event")]
	[Event(name="render", type="flash.events.Event")]
	public class ResizableObject extends Sprite {
		
		/**
		 * Using global invalidation
		 */
		public static var invalidation:Boolean = true;
		
		/**
		 * Using invalidation
		 */
		public var invalidation:Boolean = ResizableObject.invalidation;
		/**
		 * Rounding of sizes
		 */
		public var roundingSize:Boolean = true;
		/**
		 * Rounding of position
		 */
		public var roundingPosition:Boolean = true;
		
		protected var _widthPrev:Number = 0;
		protected var _heightPrev:Number = 0;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		private var _eventName:String = Event["EXIT_FRAME"] || Event.ENTER_FRAME;
		
		/**
		 * Constructor
		 */
		public function ResizableObject() {
			
		}
		
		/**
		 * Moving
		 * @param	x
		 * @param	y
		 */
		public function move(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Set sizes
		 * @param	width
		 * @param	height
		 */
		public function setSize(width:Number, height:Number):void {
			if (_width != width || _height != height) {
				_widthPrev = _width;
				_heightPrev = _height;
				
				_width = roundingSize ? Math.round(width) : width;
				_height = roundingSize ? Math.round(height) : height;
				
				invalidate();
			}
		}
		
		/**
		 * Forcing invalidation
		 */
		public function invalidate():void {
			measure();
			dispatchEvent(new Event(Event.RESIZE));
			
			if (invalidation) {
				addEventListener(_eventName, invalidateHandler);
			} else {
 				draw();
				dispatchEvent(new Event(Event.RENDER));
			}
		}
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			setSize(value, height);
		}
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			setSize(width, value);
		}
		
		override public function set x(value:Number):void {
			super.x = roundingPosition ? Math.round(value) : value;
		}
		
		override public function set y(value:Number):void {
			super.y = roundingPosition ? Math.round(value) : value;
		}
		
		
		private function invalidateHandler(e:Event):void {
			removeEventListener(_eventName, invalidateHandler);
			
			draw();
			dispatchEvent(new Event(Event.RENDER));
		}
		
		protected function measure():void {
			//code here
		}
		
		protected function draw():void {
			//code here
		}
		
	}
}