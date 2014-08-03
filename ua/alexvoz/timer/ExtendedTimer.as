package ua.alexvoz.timer {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	
	[Event(name = "complete", type = "ua.alexvoz.timer.ExtendedTimerEvents")]
	[Event(name = "tick", type = "ua.alexvoz.timer.ExtendedTimerEvents")]

	public class ExtendedTimer extends EventDispatcher {
		private var _startTime:int;
		private var _timer:Timer;
		private var _delay:int;
		private var _repeatCount:int;
		private var _pauseTime:int;
		private var _isInfinitely:Boolean = false;
		private var _paused:Boolean = false;
		
		public function ExtendedTimer(ms:int, count:int) {
			_delay = ms;
			if (count == 0) _isInfinitely = true;
				else _repeatCount = count;
			_timer = new Timer(ms, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
		}
		
		private function timerComplete(e:TimerEvent):void {
			_timer.reset();
			if (!_isInfinitely) _repeatCount--;
			if (_isInfinitely || _repeatCount > 0) {
				dispatchEvent(new ExtendedTimerEvents(ExtendedTimerEvents.TICK));
				_timer.delay = _delay;
				_timer.repeatCount = 1;
				_timer.start();
			} else {
				dispatchEvent(new ExtendedTimerEvents(ExtendedTimerEvents.COMPLETE));
			}
		}
		
		public function start():void {
			_timer.start();
			_startTime = getTimer();
		}
		
		public function pause():void {
			if (!_paused) {
				_paused = true;
				_timer.reset();
				_timer.delay = _delay - (getTimer() - _startTime); //time left
				_pauseTime = getTimer();
			}
		}
		
		public function resume():void {
			if (_paused) {
				_paused = false;
				_startTime += getTimer() - _pauseTime;
				_timer.start();
			}
		}
		
		public function stop():void {
			_timer.stop();
		}
		
		public function get repeatCount():int {
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void {
			if (value == 0) {
				_isInfinitely = true;
			} else {
				_repeatCount = value;
				_isInfinitely = false;
			}
		}
		
		public function get delay():int {
			return _delay;
		}
		
		public function set delay(value:int):void {
			_delay = value;
		}
		
		public function get isInfinitely():Boolean {
			return _isInfinitely;
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function get startTime():int {
			return _startTime;
		}
		
		public function get runningTime():int {
			return getTimer() - _startTime;
		}
		
	}

}
