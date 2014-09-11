package ru.scarbo.gui.collections 
{
	import ru.scarbo.gui.collections.itemRenerers.ButtonBarItemRenderer;
	import ru.scarbo.gui.collections.itemRenerers.IListItemRenderer;
	import ru.scarbo.gui.core.BasicList;
	import ru.scarbo.gui.core.Direction;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ButtonBar extends BasicList 
	{
		protected var _rowHeight:uint;
		protected var _rowGap:uint;
		protected var _direction:String;
		
		public function ButtonBar() 
		{
			super();
			super.clipContent = true;
			super.itemRenderer = ButtonBarItemRenderer;
			this._rowHeight = 20;
			this._rowGap = 2;
			this._direction = Direction.VERTICAL;
		}
		
		public function set rowGap(value:uint):void 
		{
			this._rowGap = value;
		}
		public function set rowHeight(value:uint):void 
		{
			this._rowHeight = value;
		}
		public function set direction(value:String):void {
			this._direction = value;
		}
		
		
		override protected function _initItemRenderers():void {
			if (this._direction == Direction.VERTICAL) {
				this._verticalLayoutItems();
			}else {
				this._horizontalLayoutItems();
			}
		}
		
		private function _verticalLayoutItems():void {
			var y:uint = 0;
			for (var i:uint = 0; i < super._dataLength; i++) {
				var itemRenderer:IListItemRenderer = this._itemsRenderers[i] as IListItemRenderer;
				itemRenderer.setSize(this._width, this._rowHeight);
				itemRenderer.y = y;
				itemRenderer.rowIndex = i;
				itemRenderer.visible = true;
				//
				y += this._rowGap + itemRenderer.height;
			}
		}
		private function _horizontalLayoutItems():void {
			var x:uint = 0;
			for (var i:uint = 0; i < super._dataLength; i++) {
				var itemRenderer:IListItemRenderer = this._itemsRenderers[i] as IListItemRenderer;
				itemRenderer.setSize(this._rowHeight, this._height);
				itemRenderer.x = x;
				itemRenderer.rowIndex = i;
				itemRenderer.visible = true;
				//
				x += this._rowGap + itemRenderer.width;
			}
		}
	}

}