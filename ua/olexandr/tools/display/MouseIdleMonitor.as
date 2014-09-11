package ua.olexandr.tools.display {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * A small utility class that allows you to see if a user has been inactive with the mouse.  The class will dispatch a custom MouseIdleMonitorEvent
	 * with a params object that contains the time the user has been idle, in milliseconds.
	 *
	 * @author Matt Przybylski [http://www.reintroducing.com]
	 * @version 1.1
	 */
	[Event(name="open", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	public class MouseIdleMonitor extends EventDispatcher {
		
		private var _target:InteractiveObject;
		private var _timer:Timer;
		private var _idleTime:int;
		private var _isMouseActive:Boolean;
		
		/**
		 * Creates an instance of hte MouseIdleMonitor class.
		 * <p>
		 * The class will dispatch two events:
		 * <ul>
		 * <li>MouseIdleMonitorEvent.MOUSE_ACTIVE: Dispatched when the mouse becomes active, repeatedly on MOUSE_MOVE</li>
		 * <li>MouseIdleMonitorEvent.MOUSE_IDLE: Dispatched when the mouse becomes inactive, idleTime param holds idle time</li>
		 * </ul>
		 * </p>
		 *
		 * @param $stage The stage object to use for the mouse tracking
		 * @param $inactiveTime The time, in milliseconds, to check if the user is active or not (default: 1000)
		 *
		 * @return void
		 */
		public function MouseIdleMonitor(target:InteractiveObject) {
			_target = target;
		}
		
		/**
		 * Starts the MouseIdleMonitor and allows it to check for mouse inactivity.
		 * @return void
		 */
		public function start(inactiveSeconds:Number = 3):void {
			_target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);
			_target.addEventListener(MouseEvent.MOUSE_UP, onMouseMove);
			
			_timer = new Timer(inactiveSeconds * 1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		/**
		 * Stops the MouseIdleMonitor from checking for mouse inactivity.
		 * @return void
		 */
		public function stop():void {
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
			
			_target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);
			_target.removeEventListener(MouseEvent.MOUSE_UP, onMouseMove);
		}
		
		/**
		 * Reset the timer if the mouse moves, user is active.
		 */
		private function onMouseMove($evt:MouseEvent):void {
			_isMouseActive = true;
			_idleTime = 0;
			_timer.reset();
			_timer.start();
			
			dispatchEvent(new Event(Event.OPEN));
		}
		
		/**
		 * Runs if the user is inactive, sets the idle time.
		 */
		private function onTimer($evt:TimerEvent):void {
			_isMouseActive = false;
			_idleTime += _inactiveTime;
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * Returns a boolean value that specifies if the mouse is active or not.
		 * @return Boolean
		 */
		public function get isMouseActive():Boolean { return _isMouseActive; }
		
		/**
		 * Returns an integer representing the amount of time the user's mouse has been inactive, in milliseconds
		 * @return int
		 */
		public function get idleTime():int { return _idleTime; }
	
	}
}