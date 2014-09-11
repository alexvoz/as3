/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.gadgets.book
{
	import flash.events.Event;
	/**
	 * генерится когда страница перевернута и прибыла на место
	 * @eventType silin.book.events.BookEvent
	 */
	[Event(name = "flip", type = "silin.book.events.BookEvent")]

	/**
	 * генерится при смене страницы(разворота)
	 * @eventType silin.book.events.BookEvent
	 */
	[Event(name = "changePage", type = "silin.book.events.BookEvent")]
	
	/**
	 * события книжки
	 */
	public class BookEvent extends Event 
	{
		
		
		static public const FLIP:String = "flip";
		
		static public const CHANGE_PAGE:String = "changePage";
		
		
		
		public var currentPage:int;
		
		public function BookEvent(type:String, current:int=-1, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			currentPage = current;
			
		} 
		
		public override function clone():Event 
		{ 
			return new BookEvent(type, currentPage, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BookEvent", "type", "currentPage", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}