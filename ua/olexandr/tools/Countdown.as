package ua.olexandr.tools {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ua.olexandr.utils.DateUtils;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	[Event(name="change",type="flash.events.Event")]
	public class Countdown extends EventDispatcher {
		
		private var targetDate:Date;
		
		private var _days:Number;
		private var _hours:Number;
		private var _mins:Number;
		private var _secs:Number;
		private var _msecs:Number;
		
		private var _timer:Timer;
		
		/**
		 * 
		 */
		public function Countdown(targetDate:Date, autoStart:Boolean = true) {
			this.targetDate = targetDate;
			if (autoStart)
				start();
		}
		
		/**
		 * 
		 */
		public function start(delay:Number = 1000):void {
			_timer = new Timer(delay);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTimer);
			_timer.start();
		}
		
		/**
		 * 
		 */
		public function stop():void {
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onTimerTimer);
			_timer = null;
		}
		
		/**
		 * 
		 */
		public function get days():Number { return _days; }
		/**
		 * 
		 */
		public function get hours():Number { return _hours; }
		/**
		 * 
		 */
		public function get minutes():Number { return _mins; }
		/**
		 * 
		 */
		public function get seconds():Number { return _secs; }
		/**
		 * 
		 */
		public function get milliseconds():Number { return _msecs; }
		
		/**
		 * 
		 */
		public function get hoursFull():Number { return hours + days * DateUtils.HOUR_IN_DAY; }
		/**
		 * 
		 */
		public function get minutesFull():Number { return minutes + hoursFull * DateUtils.MINUTES_IN_HOUR; }
		/**
		 * 
		 */
		public function get secondsFull():Number { return seconds + minutesFull * DateUtils.SECONDS_IN_MINUTE; }
		/**
		 * 
		 */
		public function get millisecondsFull():Number { return milliseconds + secondsFull * DateUtils.MSECONDS_IN_SECOND; }
		
		private function onTimerTimer(e:TimerEvent):void {
			var _diff:Number = targetDate.getTime() - new Date().getTime();
			
			_days = Math.floor(_diff / DateUtils.MSECONDS_IN_DAY);
			_diff -= (_days * DateUtils.MSECONDS_IN_DAY);
			
			_hours = Math.floor(_diff / DateUtils.MSECONDS_IN_HOUR);
			_diff -= (_hours * DateUtils.MSECONDS_IN_HOUR);
			
			_mins = Math.floor(_diff / DateUtils.MSECONDS_IN_MINUTE);
			_diff -= (_mins * DateUtils.MSECONDS_IN_MINUTE);
			
			_secs = Math.floor(_diff / DateUtils.MSECONDS_IN_SECOND);
			_diff -= (_secs * DateUtils.MSECONDS_IN_SECOND);
			
			_msecs = _diff;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}