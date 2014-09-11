package ru.scarbo.gui.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ButtonEvent extends Event 
	{
		public static const PRESS:String = 'buttonevent_press';
		public static const RELEASE:String = 'buttonevent_release';
		public static const RELEASE_OUTSIDE:String = 'buttonevent_release_outside';
		public static const CLICK:String = 'buttonevent_click';
		public static const DOUBLE_CLICK:String = 'buttonevent_double_click';
		public static const OVER:String = 'buttonevent_over';
		public static const OUT:String = 'buttonevent_out';
		
		public function ButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
	}

}