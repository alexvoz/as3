package ru.scarbo.gui.collections 
{
	import ru.scarbo.gui.collections.itemRenerers.IListItemRenderer;
	import ru.scarbo.gui.collections.itemRenerers.TileListItemRenderer;
	import ru.scarbo.gui.core.BasicList;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class TileList extends BasicList 
	{
		protected var _rowHeight:uint;
		protected var _columnWidth:uint;
		protected var _rowCount:uint;
		protected var _columnCount:uint;
		protected var _rowGap:uint;
		protected var _columnGap:uint;
		
		public function TileList() 
		{
			super();
			super.clipContent = true;
			super.itemRenderer = TileListItemRenderer;
			this._rowHeight = this._columnWidth = 20;
			this._rowGap = this._columnGap = 2;
			this._rowCount = this._columnCount = 2;
		}
		
		public function set rowCount(value:uint):void 
		{
			this._rowCount = value;
		}
		public function set columnCount(value:uint):void 
		{
			this._columnCount = value;
		}
		public function set rowGap(value:uint):void 
		{
			this._rowGap = value;
		}
		public function set columnGap(value:uint):void 
		{
			this._columnGap = value;
		}
		public function set rowHeight(value:uint):void 
		{
			this._rowHeight = value;
		}
		public function set columnWidth(value:uint):void 
		{
			this._columnWidth = value;
		}
		
		
		override protected function _initItemRenderers():void {
			var x:uint = 0;
			var y:uint = -this._rowHeight - this._rowGap;
			//
			for (var i:uint = 0; i < super._dataLength; i++) {
				var itemRenderer:IListItemRenderer = super._itemsRenderers[i] as IListItemRenderer;
				itemRenderer.setSize(this._columnWidth, this._rowHeight);
				if (i % this._columnCount == 0) {
					x = 0;
					y += this._rowGap + itemRenderer.height;
				}else {
					x += this._columnGap + itemRenderer.width;
				}
				//
				itemRenderer.x = x;
				itemRenderer.y = y;
				itemRenderer.visible = true;
			}
		}
	}

}