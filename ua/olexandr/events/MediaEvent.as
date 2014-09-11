package ua.olexandr.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class MediaEvent extends Event{
		
		static public const INIT			:String = 'init';
		
		static public const ERROR			:String = 'error';
		
		static public const LOAD_PROGRESS	:String = 'load_progress';
		static public const LOAD_COMPLETE	:String = 'load_complete';
		
		static public const PLAY_START		:String = 'play_start';
		static public const PLAY_PROGRESS	:String = 'play_progress';
		static public const PLAY_COMPLETE	:String = 'play_complete';
		
		
		/**
		 * 
		 */
		public var bytesLoaded:Number;
		/**
		 * 
		 */
		public var bytesTotal:Number;
		/**
		 * 
		 */
		public var percentageLoading:Number;
		
		/**
		 * 
		 */
		public var position:Number;
		/**
		 * 
		 */
		public var length:Number;
		/**
		 * 
		 */
		public var percentagePlaying:Number;
		
		/**
		 * 
		 */
		public var text:String;
		
		
		/**
		 * Creates an MediaEvent object to pass as a parameter to event listeners.
		 * @param	type
		 * @param	text
		 */
		public function MediaEvent(type:String, text:String = '') {
			super(type, false, true);
			this.text = text;
		}
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * @return
		 */
		override public function clone():Event {
			var _e:MediaEvent = new MediaEvent(type, text);
			
			_e.bytesLoaded = bytesLoaded;
			_e.bytesTotal = bytesTotal;
			_e.percentageLoading = percentageLoading;
			
			_e.position = position;
			_e.length = length;
			_e.percentagePlaying = percentagePlaying;
			
			_e.text = text;
			
			return _e;
		} 
		
		
	}

}