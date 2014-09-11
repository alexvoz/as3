package ru.scarbo.gui.collections.itemRenerers 
{
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import ru.scarbo.gui.controls.Button;
	import ru.scarbo.gui.core.BasicButton;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ButtonBarItemRenderer extends Button implements IListItemRenderer 
	{
		private var _rowIndex:int;
		private var _index:int;
		private var _labelField:String;
		private var _labelFunction:Function;
		
		public function ButtonBarItemRenderer() 
		{
			super();
		}
		
		public function set labelField(value:String):void {
			this._labelField = value;
		}
		public function set labelFunction(value:Function):void {
			this._labelFunction = value;
		}
		
		public function get index():int { return _index; }
		public function set index(value:int):void 
		{
			_index = value;
		}
		public function get rowIndex():int { return this._rowIndex; }
		public function set rowIndex(value:int):void {
			this._rowIndex = value;
		}
		public function get columnIndex():int { return -1; }
		public function set columnIndex(value:int):void { }
		
		override public function get data():Object{ return _data; }
		override public function set data(value:Object):void 
		{
			this.setSkin(value.icons[BasicButton.SKIN], 0);
			this.setSkin(value.icons[BasicButton.SKIN_OVER], 1);
			this.setSkin(value.icons[BasicButton.SKIN_PRESS], 2);
			this.setSkin(value.icons[BasicButton.SKIN_SELECTED], 3);
			this.label = value[this._labelField];
			this._data = value;
		}
		
	}

}