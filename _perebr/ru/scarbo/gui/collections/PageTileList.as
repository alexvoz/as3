package ru.scarbo.gui.collections 
{
	import ru.scarbo.gui.events.ListEvent;
	import ru.scarbo.gui.utils.IPagenator;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class PageTileList extends TileList 
	{
		private var _pagenator:IPagenator;
		
		public function PageTileList() 
		{
			super();
		}
		
		public function set pagenator(value:IPagenator):void {
			this._pagenator = value;
			this._pagenator.addEventListener(ListEvent.CHANGE, _pageChangeHandler);
		}
		
		override protected function _initItemRenderers():void {
			var width:uint = (super._columnWidth + super._columnGap) * super._columnCount;
			var height:uint = (super._rowHeight + super._rowGap) * super._rowCount;
			var numPages:uint = uint(super._dataLength / (super._columnCount * super._rowCount));
			super.setSize(width, height);
			super._initItemRenderers();
			this._container.y = 0;
			if (numPages > 0) {
				this._pagenator.numPages = numPages + 1;
			}else {
				this._pagenator.numPages = 0;
			}
		}
		
		private function _pageChangeHandler(e:ListEvent):void {
			var index:uint = this._pagenator.selectedIndex;
			var height:uint = (super._rowHeight + super._rowGap) * super._rowCount;
			this._container.y = -(height * index);
		}
	}

}