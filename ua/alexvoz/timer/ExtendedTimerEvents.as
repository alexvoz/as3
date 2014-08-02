package ua.alexvoz.timer {
	import flash.events.Event;
	
	/**
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class ExtendedTimerEvents extends Event {
		
		public static const COMPLETE:String = "complete";
		public static const TICK:String = "tick";
		
		public function ExtendedTimerEvents(type:String) {
			super(type, false, false);
		}
		
		public override function clone():Event { 
			return new ExtendedTimerEvents(type);
		} 
	  
		public override function toString():String { 
			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}