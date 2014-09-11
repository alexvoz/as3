package ru.scarbo.gui.collections.core 
{
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public interface IList 
	{
		function get dataProvider():Array;
		function set dataProvider(value:Array):void;
		function set itemRenderer(value:Class):void;
		function set selectedIndex(value:int):void;
		function set selectedItem(value:Object):void;
		
		function get selectedIndex():int;
		function get selectedItem():Object;
	}
	
}