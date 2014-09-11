package ru.scarbo.gui.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class BasicEvent extends Event 
	{
		public static const INITIALIZE:String = 'basicevent_init';
		public static const BUILD:String = 'basicevent_build';
		public static const DESTROY:String = 'basicevent_destroy';
		public static const DRAW:String = 'basicevent_draw';
		public static const DATA_CHANGE:String = 'basicevent_datachange';
		
		public function BasicEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}