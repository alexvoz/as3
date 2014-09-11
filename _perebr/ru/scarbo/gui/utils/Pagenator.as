package ru.scarbo.gui.utils 
{
	import ru.scarbo.data.ClassLibrary;
	import ru.scarbo.gui.collections.ButtonBar;
	import ru.scarbo.gui.controls.ButtonSkin;
	import ru.scarbo.gui.controls.IconButton;
	import ru.scarbo.gui.core.BasicContainer;
	import ru.scarbo.gui.core.Direction;
	import ru.scarbo.gui.events.ButtonEvent;
	import ru.scarbo.gui.events.ListEvent;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class Pagenator extends BasicContainer implements IPagenator
	{
		private var _direction:String;
		private var _numPages:uint;
		
		private var _buttonBar:ButtonBar;
		private var _prevButton:IconButton;
		private var _nextButton:IconButton;
		
		public function Pagenator() 
		{
			super();
			this.direction = Direction.HORIZONTAL;
		}
		
		override protected function _createChildren():void {
			this._buttonBar = new ButtonBar();
			this._buttonBar.setSize(240, 28);
			this._buttonBar.rowHeight = 28;
			this._buttonBar.rowGap = 2;
			this._buttonBar.addEventListener(ListEvent.ITEM_CLICK, this._itemClickHandler);
			this.addChild(this._buttonBar);
			//
			this._prevButton = new IconButton();
			this._prevButton.icon = ClassLibrary.getDisplayObject('PagenatorPrevButtonSkin');
			this._prevButton.addEventListener(ButtonEvent.CLICK, this._navigationHandler);
			this._prevButton.visible = false;
			this._prevButton.x = 240;
			this.addChild(this._prevButton);
			//
			this._nextButton = new IconButton();
			this._nextButton.icon = ClassLibrary.getDisplayObject('PagenatorNextButtonSkin');
			this._nextButton.addEventListener(ButtonEvent.CLICK, this._navigationHandler);
			this._nextButton.visible = false;
			this._nextButton.x = 270;
			this.addChild(this._nextButton);
		}
		
		override protected function _destroy():void {
			this._buttonBar.removeEventListener(ListEvent.ITEM_CLICK, this._itemClickHandler);
			this._prevButton.removeEventListener(ButtonEvent.CLICK, this._navigationHandler);
			this._nextButton.removeEventListener(ButtonEvent.CLICK, this._navigationHandler);
			//
			super._destroy();
		}
		
		public function set direction(value:String):void {
			this._direction = value;
			this._buttonBar.direction = value;
		}
		public function set numPages(value:uint):void {
			this._numPages = value;
			this._buttonBar.dataProvider = this._getDataProvider;
			this.selectedIndex = 0;
		}
		
		public function get selectedIndex():int { return this._buttonBar.selectedIndex; }
		public function set selectedIndex(value:int):void {
			if (value >= 0 && value < this._numPages) {
				trace(value);
				this._buttonBar.selectedIndex = value;
				this.dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}
		}
		
		
		private function _itemClickHandler(e:ListEvent):void {
			this.selectedIndex = e.itemRenderer.index;
		}
		private function _navigationHandler(e:ButtonEvent):void {
			if (e.target == this._prevButton) {
				this.selectedIndex--;
			}else {
				this.selectedIndex++;
			}
		}
		
		private function get _getDataProvider():Array {
			var array:Array = [];
			for (var i:uint = 0; i < this._numPages; i++) {
				var upSkin:ButtonSkin = new ButtonSkin(ClassLibrary.getDisplayObject('PagenatorButtonUpSkin'), 'font:Calibri,color:#0033CC,size:21,bold:true');
				var overSkin:ButtonSkin = new ButtonSkin(ClassLibrary.getDisplayObject('PagenatorButtonOverSkin'), 'font:Calibri,color:#ffffff,size:21,bold:true');
				var downSkin:ButtonSkin = new ButtonSkin(ClassLibrary.getDisplayObject('PagenatorButtonOverSkin'), 'font:Calibri,color:#ffffff,size:21,bold:true');
				var selectedSkin:ButtonSkin = new ButtonSkin(ClassLibrary.getDisplayObject('PagenatorButtonOverSkin'), 'font:Calibri,color:#ffffff,size:21,bold:true');
				var item:Object = { };
				item.label = (i + 1).toString();
				item.icons = { 0: upSkin, 1:overSkin, 2:downSkin, 3:selectedSkin };
				array.push(item);
			}
			if (this._numPages > 1) {
				this._prevButton.visible = this._nextButton.visible = true;
			}else {
				this._prevButton.visible = this._nextButton.visible = false;
			}
			//
			return array;
		}
	}

}