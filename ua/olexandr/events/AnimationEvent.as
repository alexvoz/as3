package ua.olexandr.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class AnimationEvent extends Event {
		
		public static const START		:String = 'start';
		public static const END			:String = 'end';
		
		/**
		 * Creates an AnimationEvent object to pass as a parameter to event listeners.
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function AnimationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * @return
		 */
		public override function clone():Event { 
			return new AnimationEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * Returns a string containing all the properties of the AnimationEvent object.
		 * @return
		 */
		public override function toString():String { 
			return formatToString("AnimationEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}