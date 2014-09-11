package ua.olexandr.tools {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Broadcaster {
		
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	weak
		 */
		public static function addEventListener(type:String, listener:Function, weak:Boolean = true):void {
			_dispatcher.addEventListener(type, listener, false, 0, weak);
		}
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 */
		public static function removeEventListener(type:String, listener:Function):void {
			_dispatcher.removeEventListener(type, listener);
		}
		
		/**
		 * 
		 * @param	event
		 */
		public static function dispatchEvent(event:Event):void {
			_dispatcher.dispatchEvent(event);
		}
	
	}
}
