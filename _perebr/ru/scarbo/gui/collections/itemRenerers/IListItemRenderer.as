package ru.scarbo.gui.collections.itemRenerers 
{
	import ru.scarbo.gui.core.IBasic;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public interface IListItemRenderer extends IBasic
	{
		function get rowIndex():int;
		function set rowIndex(value:int):void;
		function get columnIndex():int;
		function set columnIndex(value:int):void;
		function get data():Object;
		function set data(value:Object):void;
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		function get index():int;
		function set index(value:int):void;
		function set labelField(value:String):void;
		function set labelFunction(value:Function):void;
	}
	
}