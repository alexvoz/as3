package ru.scarbo.gui.collections.itemRenerers 
{
	import flash.display.DisplayObject;
	import ru.scarbo.gui.core.BasicButton;
	import ru.scarbo.gui.core.IBasic;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class TileListItemRenderer extends BasicButton implements IListItemRenderer
	{
		private var _icon:DisplayObject;
		private var _index:int;
		private var _rowIndex:int;
		private var _columnIndex:int;
		private var _labelField:String;
		private var _labelFunction:Function;
		
		public function TileListItemRenderer() 
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
		public function get columnIndex():int { return this._columnIndex; }
		public function set columnIndex(value:int):void {
			this._columnIndex = value;
		}
		
		override public function get data():Object{ return _data; }
		override public function set data(value:Object):void 
		{
			this.setSkin(value.icons[BasicButton.SKIN], BasicButton.SKIN);
			this.setSkin(value.icons[BasicButton.SKIN_OVER], BasicButton.SKIN_OVER);
			this.setSkin(value.icons[BasicButton.SKIN_PRESS], BasicButton.SKIN_PRESS);
			this.setSkin(value.icons[BasicButton.SKIN_SELECTED], BasicButton.SKIN_SELECTED);
			this._currentSkin = value.icons[BasicButton.SKIN];
			this._data = value;
			if (value.hasOwnProperty('icon')) {
				this._icon = value.icon as DisplayObject;
				this.addChild(this._icon);
			}
			this.changed = true;
		}
		
		override protected function _draw():void {
			if (this._currentSkin is IBasic) {
				IBasic(this._currentSkin).setSize(this._width, this._height);
			}else {
				this._currentSkin.width = this._width;
				this._currentSkin.height = this._height;
			}
			//
			if (this._icon) {
				this._icon.x = (this._width - this._icon.width) / 2;
				this._icon.y = (this.height - this._icon.height) / 2;
			}
			//
			super._draw();
		}
		
	}

}