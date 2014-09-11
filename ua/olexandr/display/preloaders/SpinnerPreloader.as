package ua.olexandr.display.preloaders {
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.2
	 */
	public class SpinnerPreloader extends BasePreloader {
		
		private var _timer:Timer;
		private var _count:int = 0;
		
		private var _dots:Array = [];
		private var _opacity:Array = [];
		
		/**
		 * 
		 * @param	color
		 * @param	radiusMin
		 * @param	size
		 * @param	count
		 * @param	speed
		 */
		public function SpinnerPreloader(color:uint = 0x666666, radiusMin:int = 16, size:int = 4, count:int = 12, speed:int = 50) {
			_count = count;
			
			super(false);
			
			for (var i:int = 0; i < _count; i++) {
				_opacity[i] = i / _count;
				
				var _alpha:Number = (2 * Math.PI / _count) * i - Math.PI / 2;
				
				var _dot:Shape = new Shape();
				_dot.graphics.beginFill(color);
				_dot.graphics.drawCircle(0, 0, size);
				_dot.x = radiusMin * (Math.cos(_alpha) + 1) - radiusMin;
				_dot.y = radiusMin * (Math.sin(_alpha) + 1) - radiusMin;
				_holder.addChild(_dot);
				
				_dots[i] = _dot;
			}
			
			_timer = new Timer(speed);
		}
		
		
		override protected function startIn():void {
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
			
			for (var i:int = 0; i < _count; i++)
				_dots[i].alpha = _dots[i].scaleX = _dots[i].scaleY = _opacity[i];
		}
		
		override protected function stopIn():void {
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer.stop();
			
			for (var i:int = 0; i < _count; i++)
				_dots[i].alpha = _dots[i].scaleX = _dots[i].scaleY = 1;
		}
		
		
		private function timerHandler(e:TimerEvent):void {
			_opacity.unshift(_opacity.pop());
			for (var i:int = 0; i < _count; i++)
				_dots[i].alpha = _dots[i].scaleX = _dots[i].scaleY = _opacity[i];
		}
		
	}

}