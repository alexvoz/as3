package ru.scarbo.gui.collections.core 
{
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public interface IListIterator 
	{
		function hasNext():Boolean;
		function get nextIndex():int;
		function next():* ;
		
		function hasPrevious():Boolean;
		function get previousIndex():int;
		function previous():* ;
		
		function get index():int;
		function get current():* ;
		function start():void;
		function end():void;
		function remove():Boolean;
	}
	
}