package ua.olexandr.functions {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	
	/**
	 * Выполнить с задержкой
	 * @param	delay в секундах
	 * @param	handler
	 * @param	...args
	 */
	public function createDelayedHandler(delay:Number, handler:Function, ...args):void {
		var _handler:Function = createHandler(handler, args);
		
		var _timer:Timer = new Timer(delay * 1000, 1);
		_timer.start();
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
			_handler();
			
			_timer.removeEventListener(e.type, arguments.callee);
			_timer.reset();
			_timer = null;
		} );
	}

}