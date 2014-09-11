package ru.scarbo.gui.utils 
{
	import ru.scarbo.gui.core.IBasic;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public interface IPagenator extends IBasic
	{
		function set numPages(value:uint):void;
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
	}
	
}