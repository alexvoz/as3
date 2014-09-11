package ru.cartoonizer.gui.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vyacheslav Makhotkin <retardeddude@gmail.com>
	 */
	public class ValidateEvent extends Event 
	{
		
		public static const VALID:String = 'ValidateEvent_Valid';
		public static const INVALID:String = 'ValidateEvent_Invalid';
		
		public function ValidateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ValidateEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ValidateEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}