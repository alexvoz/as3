package ua.olexandr.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class FrameEvent extends Event {
		
		public static const CHANGE:String = "change";
		public static const COMPLETE:String = "complete";
		
		
		private var _frame:int;
		
		/**
		 * Creates an FrameEvent object to pass as a parameter to event listeners.
		 * @param	type
		 * @param	frame
		 */
		public function FrameEvent(type:String, frame:int = 0) { 
			super(type, false, false);
			_frame = frame;
		} 
		
		/**
		 * 
		 */
		public function get frame():int { return _frame; }
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * @return
		 */
		public override function clone():Event { 
			return new FrameEvent(type, _frame);
		} 
		
		/**
		 * Returns a string containing all the properties of the FrameEvent object.
		 * @return
		 */
		public override function toString():String {
			return "[FrameEvent type=" + type + " frame=" + frame + "]";
		}
		
	}
	
}