package ua.olexandr.display.preloaders {  
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ua.olexandr.utils.ColorUtils;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.2
	 */
	public class CirclePreloader extends BasePreloader {  
		
		private var _count:int;
		private var _timer:Timer;
		
		/**
		 * 
		 * @param	colorStart
		 * @param	colorEnd
		 * @param	radiusMin
		 * @param	size
		 * @param	count
		 * @param	speed
		 */
		public function CirclePreloader(colorStart:uint = 0x000000, colorEnd:uint = 0x999999, radiusMin:int = 12, size:int = 4, count:int = 10, speed:int = 50) {
			_count = count;  
			
			super(false);
			
			for (var i:int = 0; i < _count; i++) {
				var _color:uint = ColorUtils.ratioRGB(colorStart, colorEnd, i / _count);
				
				var _circle:Shape = drawCircle(size, _color);
				_circle.x = radiusMin + size;
				
				var _cont:Sprite = new Sprite();
				_cont.addChild(_circle);
				_cont.rotation = 360 * i / _count;
				_holder.addChild(_cont);
			}
			
			
			_timer = new Timer(speed);
		}  
		
		
		override protected function startIn():void {
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		
		override protected function stopIn():void {
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer.stop();
		}
		
		
		private function timerHandler(e:TimerEvent):void {
			_holder.rotation += 360 / _count;
		}  
		
		private function drawCircle(size:Number, color:uint = 0x000000):Shape {
			var _shape:Shape = new Shape();
			_shape.graphics.beginFill(color, 1);
			_shape.graphics.drawCircle(0, 0, size);
			_shape.graphics.endFill();
			return _shape;
		}
		
   }  
}  