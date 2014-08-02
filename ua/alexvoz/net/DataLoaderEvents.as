package ua.alexvoz.net {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class DataLoaderEvents extends Event {
  
		public static const PROGRESS:String = "progress";
		public static const CURRENT_PROGRESS:String = "current_progress";
		public static const ERROR:String = "error";
		public static const COMPLETE:String = "complete";
	  
		private var _progress:Number;
		private var _data:*;
		
		public function DataLoaderEvents(type:String, progress:Number, data:*) {
			_progress = progress;
			_data = data;
			super(type, false, false);
		} 
		
		public override function clone():Event { 
			return new DataLoaderEvents(type, _progress, _data);
		} 
	  
		public override function toString():String { 
			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get progress():Number {
			return _progress;
		}
		
		public function get data():* {
			return _data;
		}
	  
	}
 
}