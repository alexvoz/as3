package ru.scarbo.gui.core
{
	import flash.display.DisplayObject;
	import ru.scarbo.gui.collections.core.IList;
	import ru.scarbo.gui.collections.itemRenerers.IListItemRenderer;
	import ru.scarbo.gui.events.ButtonEvent;
	import ru.scarbo.gui.events.ListEvent;

	/**
	 * ...
	 * @author Scarbo
	 */
	public class BasicList extends BasicContainer implements IList
	{
		protected var _dataProvider:Array;
		protected var _labelField:String;
		protected var _labelFunction:Function;
		protected var _itemsRenderers:Array;
		protected var _dataLength:uint;
		protected var _itemRenderer:Class;
		protected var _selectedIndex:int = -1;
		protected var _selectedItem:Object = null;
		protected var _selectedItemRenderer:IListItemRenderer;

		public function BasicList()
		{
			super();
			this.labelField = 'label';
			this.labelFunction = null;
		}

		/****DATA PROVIDER****/
		public function get dataProvider():Array { return this._dataProvider;}
		public function set dataProvider(value:Array):void
		{
			this._dataProvider = value;
			this._createItemRenderers();
			if (this._builted) this._initItemRenderers();
		}
		
		protected function _createItemRenderers():void {
			this.removeAllChildren();
			this._itemsRenderers = [];
			//
			if (!this._dataProvider) {
				this._dataLength = 0;
				return;
			}
			//
			this._dataLength = this._dataProvider.length;
			for (var i:uint = 0; i < this._dataLength; i++) {
				var itemRenderer:IListItemRenderer = new this._itemRenderer() as IListItemRenderer;
				if (itemRenderer) {
					itemRenderer.index = i;
					itemRenderer.labelField = this._labelField;
					itemRenderer.labelFunction = this._labelFunction;
					itemRenderer.data = this._dataProvider[i];
					itemRenderer.visible = false;
					itemRenderer.addEventListener(ButtonEvent.OVER, this._itemRendererOverHandler);
					itemRenderer.addEventListener(ButtonEvent.OUT, this._itemRendererOutHandler);
					itemRenderer.addEventListener(ButtonEvent.PRESS, this._itemRendererClickHandler);
					itemRenderer.addEventListener(ButtonEvent.DOUBLE_CLICK, this._itemRendererDoubleClickHandler);
					this._itemsRenderers.push(itemRenderer);
					this.addChild(DisplayObject(itemRenderer));
				}
			}
		}

		public function set itemRenderer(value:Class):void
		{
			this._itemRenderer = value;
		}

		/****SELECTED ITEM****/
		public function get selectedIndex():int { return this._selectedIndex; }
		public function set selectedIndex(value:int):void
		{
			//if (this._selectedIndex != value) {
				this._selectedIndex = value;
				if (this._dataProvider && this._selectedIndex >= 0 && this._selectedIndex < this._dataLength) {
					if (this._selectedItemRenderer) this._selectedItemRenderer.selected = false;
					this._selectedItemRenderer = this._itemsRenderers[this._selectedIndex] as IListItemRenderer;
					this._selectedItemRenderer.selected = true;
					this._selectedItem = this._selectedItemRenderer.data;
					this.dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false, this._selectedItemRenderer));
				}
			//}
		}

		public function get selectedItem():Object { return this._selectedItem; }
		public function set selectedItem(value:Object):void
		{
			if (this._dataProvider) this.selectedIndex = this._dataProvider.indexOf(value);
		}
		
		/****LABEL****/
		public function set labelField(value:String):void 
		{
			_labelField = value;
		}
		public function set labelFunction(value:Function):void 
		{
			_labelFunction = value;
		}
		
		/****LAYOUT ITEMRENDERERS****/
		override final protected function _build():void {
			this._initItemRenderers();
			super._build();
		}
		
		protected function _initItemRenderers():void {
			
		}
		
		/****DISPATCHERS****/
		protected function _itemRendererOverHandler(e:ButtonEvent):void {
			var itemRenderer:IListItemRenderer = e.target as IListItemRenderer;
			this.dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OVER, false, false, itemRenderer));
		}
		protected function _itemRendererOutHandler(e:ButtonEvent):void {
			var itemRenderer:IListItemRenderer = e.target as IListItemRenderer;
			this.dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OUT, false, false, itemRenderer));
		}
		protected function _itemRendererClickHandler(e:ButtonEvent):void {
			var itemRenderer:IListItemRenderer = e.target as IListItemRenderer;
			this.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, false, itemRenderer));
			//
			this.selectedIndex = itemRenderer.index;
		}
		protected function _itemRendererDoubleClickHandler(e:ButtonEvent):void {
			var itemRenderer:IListItemRenderer = e.target as IListItemRenderer;
			this.dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, false, false, itemRenderer));
		}

	}

}
