package ru.scarbo.gui.events 
{
	import flash.events.Event;
	import ru.scarbo.gui.collections.itemRenerers.IListItemRenderer;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ListEvent extends Event 
	{
		public static const CHANGE:String = 'listevent_change';
		public static const ITEM_ROLL_OUT:String = 'listevent_rollout';
		public static const ITEM_ROLL_OVER:String = 'listevent_rollover';
		public static const ITEM_CLICK:String = 'listevent_click';
		public static const ITEM_DOUBLE_CLICK:String = 'listevent_doubleclick';
		
		public var itemRenderer:IListItemRenderer;
		
		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, itemRenderer:IListItemRenderer = null) 
		{
			super(type, bubbles, cancelable);
			this.itemRenderer = itemRenderer;
		}
		
		override public function clone():Event {
			return new ListEvent(super.type, super.bubbles, super.cancelable, this.itemRenderer);
		}
	}

}