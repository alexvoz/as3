package ua.alexvoz.media {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author a.pismenchuk
	 */
	public class StageVideoPlayerEvents extends Event {
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const ERROR:String = "error";
		public static const END:String = "end";
		
		private var _data:*;
		
		public function StageVideoPlayerEvents(type:String, data:*) {
			_data = data;
			super(type, false, false);
		}
		
		public override function clone():Event { 
			return new StageVideoPlayerEvents(type, _data);
		} 
	  
		public override function toString():String { 
			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():* {
			return _data;
		}
		
	}

}