package ru.cartoonizer.states 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import ru.cartoonizer.ImageBox;
	import ru.cartoonizer.ResourceParser;
	import ru.cartoonizer.vo.IResourceVO;
	import ru.cartoonizer.vo.MenuItemVO;
	import ru.cartoonizer.vo.ResourceDeleteVO;
	import ru.cartoonizer.vo.ResourceElementVO;
	import ru.cartoonizer.vo.ResourcePreviewVO;
	import ru.scarbo.data.ClassLibrary;
	import ru.cartoonizer.ContentLoader;
	import ru.scarbo.gui.collections.ButtonBar;
	import ru.scarbo.gui.collections.PageTileList;
	import ru.scarbo.gui.collections.TileList;
	import ru.scarbo.gui.containers.Application;
	import ru.scarbo.gui.controls.Button;
	import ru.scarbo.gui.controls.ButtonSkin;
	import ru.scarbo.gui.core.BasicFormat;
	import ru.scarbo.gui.core.BasicMask;
	import ru.scarbo.gui.events.ButtonEvent;
	import ru.scarbo.gui.events.ListEvent;
	import ru.scarbo.gui.utils.Pagenator;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class State2 extends State
	{	
		public var typeUrl:String;
		
		private var _colorBox:TileList;
		private var _elementBox:PageTileList;
		private var _menuBar:ButtonBar;
		private var _context:LoaderContext;
		private var _resourceManager:ResourceParser;
		private var _selectedMenu:MenuItemVO;
		private var _imageBox:ImageBox;
		private var _colorsText:TextField;
		private var _faceColor:uint;
		private var _elementsBindable:Object;
		
		public function get image():ImageBox { return this._imageBox; }
		
		public function State2() 
		{
			super();
			this._elementsBindable = { };
			this._resourceManager = new ResourceParser();
			this._context = new LoaderContext(false, ApplicationDomain.currentDomain);
			ContentLoader.loader.addEventListener(BulkProgressEvent.COMPLETE, this._completeSwfHandler);
		}
		
		override protected function _build():void {
			this._createColorsText();
			this._createImageBox();
			this._createColorBox();
			this._createElementBox();
			this._createMenuBar();
			this._createNextButton();
			//
			super._build();
		}
		
		/****COLORS TEXT****/
		private function _createColorsText():void {
			this._colorsText = new TextField();
			this._colorsText.autoSize = TextFieldAutoSize.LEFT;
			this._colorsText.mouseEnabled = false;
			this._colorsText.defaultTextFormat = new BasicFormat('font:Calibri,color:#000000,size:18,bold:true');
			this._colorsText.text = 'Выбери нужный оттенок:';
			this._colorsText.x = 41;
			this._colorsText.y = 525;
			this._colorsText.visible = false;
			this.addChild(this._colorsText);
		}
		
		/****IMAGE STAGE****/
		private function _createImageBox():void {
			this._imageBox = new ImageBox();
			this._imageBox.numContainers = Application.application.confXML..button.length();
			this._imageBox.x = Main.IMAGE_X;
			this._imageBox.y = Main.IMAGE_Y;
			this.addChild(this._imageBox);
		}
		
		
		/*****ОБНОВЛЯЕМ ЭЛЕМЕНТЫ ЗАВИСИМЫЕ ОТ ЦВЕТА ЛИЦА****/
		private function get faceColor():uint { return this._faceColor; }
		private function set faceColor(value:uint):void {
			this._faceColor = value;
			this._executeBindabling();
		}
		private function _executeBindabling():void {
			for (var key:String in this._elementsBindable) {
				var weight:uint = Number(key);
				var arr:Array = this._getCopyElement(this._elementsBindable[key]);
				//
				var element:ResourceElementVO = arr[0] as ResourceElementVO;
				var child:DisplayObject = element.child;
				child.x = child.y = 0;
				this._imageBox.addChildAt(child, weight);
			}
		}
		private function _getCopyElement(array:Array):Array {
			var arr:Array = [];
			for each(var item:ResourceElementVO in array) {
				if (item.copyColor == this._faceColor) {
					arr.push(item);
					break;
				}
			}
			if (arr.length > 0) {
				return arr;
			}else {
				return [array[0]];
			}
		}
		
		
		/****COLOR BOX****/
		private function _createColorBox():void {
			this._colorBox = new TileList();
			this._colorBox.setSize(280, 100);
			this._colorBox.columnCount = 9;
			this._colorBox.columnWidth = this._colorBox.rowHeight = 24;
			this._colorBox.columnGap = 6;
			this._colorBox.rowGap = 5;
			this._colorBox.x = 45;
			this._colorBox.y = 555;
			this.addChild(this._colorBox);
			//
			this._colorBox.addEventListener(ListEvent.CHANGE, _colorChangeHandler);
		}
		private function _colorChangeHandler(e:ListEvent):void {
			var element:ResourceElementVO = e.itemRenderer.data as ResourceElementVO;
			var child:DisplayObject = element.child;
			child.x = child.y = 0;
			this._imageBox.addChildAt(child, this._selectedMenu.weight);
			if (this._selectedMenu.id == 'face') this.faceColor = element.color;
		}
		
		/****ELEMENTS TILE LIST****/
		private function _createElementBox():void {
			var pagenator:Pagenator = new Pagenator();
			pagenator.x = 335;
			pagenator.y = 600;
			this.addChild(pagenator);
			//
			this._elementBox = new PageTileList();
			this._elementBox.columnCount = 4;
			this._elementBox.rowCount = 4;
			this._elementBox.columnWidth = 70;
			this._elementBox.rowHeight = 73;
			this._elementBox.columnGap = 2;
			this._elementBox.rowGap = 2;
			this._elementBox.pagenator = pagenator;
			this._elementBox.x = 335;
			this._elementBox.y = 270;
			this.addChild(this._elementBox);
			//
			this._elementBox.addEventListener(ListEvent.CHANGE, _elementChangeHandler);
		}
		private function _elementChangeHandler(e:ListEvent):void {
			this._colorBox.selectedIndex = -1;
			if (e.itemRenderer.data is ResourcePreviewVO) {
				var resource:ResourcePreviewVO = e.itemRenderer.data as ResourcePreviewVO;
				if (resource.elements_copy.length > 0) {
					this._elementsBindable[this._selectedMenu.weight] = resource.elements_copy;
					this._colorBox.dataProvider = this._getCopyElement(resource.elements_copy);
					this._colorBox.selectedIndex = 0;
				}else {
					this._colorBox.dataProvider = resource.elements;
					this._colorBox.selectedIndex = 0;
				}
			}
			else if(e.itemRenderer.data is ResourceDeleteVO) {
				this._imageBox.addChildAt(null, this._selectedMenu.weight);
			}
		}
		
		/****MENU BAR****/
		private function _createMenuBar():void {
			this._menuBar = new ButtonBar();
			this._menuBar.setSize(164, 500);
			this._menuBar.rowHeight = 41;
			this._menuBar.rowGap = 1;
			this._menuBar.x = 653;
			this._menuBar.y = 238;
			this.addChild(this._menuBar);
			//
			this._menuBar.addEventListener(ListEvent.CHANGE, _navigationChangeHandler);
			this._menuBar.dataProvider = this._getNavigation();
			this._menuBar.selectedIndex = 0;
		}
		private function _navigationChangeHandler(e:ListEvent):void {
			this._selectedMenu = e.itemRenderer.data as MenuItemVO;
			var resources:Array = this._resourceManager.getResources(this._selectedMenu.id);
			if (resources) {
				this._setElements(resources);
			}else {
				ContentLoader.add(this._selectedMenu.url, { context:this._context, id:this._selectedMenu.id }, false);
				ContentLoader.start();
			}
		}
		private function _completeSwfHandler(e:BulkProgressEvent):void {
			var loader:BulkLoader = (e.target as BulkLoader);
			var id:String = this._selectedMenu.id;
			this._resourceManager.addResource(loader.getSprite(id, true), id);
			this._setElements(this._resourceManager.getResources(id));
		}
		private function _setElements(array:Array):void {
			this._elementBox.dataProvider = array;
			this._elementBox.selectedIndex = -1;
			this._colorBox.selectedIndex = -1;
			this._colorBox.dataProvider = null;
			this._colorsText.visible = (array[0].elements.length > 1) ? true : false;
		}
		
		/****NEXT BUTTON****/
		private function _createNextButton():void {
			var nextButton:Button = new Button();
			nextButton.label = 'Готово';
			nextButton.setSize(200, 71);
			nextButton.setSkin(new ButtonSkin(new Bitmap(ClassLibrary.getBitmapData('NextButtonUpSkin')), 'font:Calibri,color:#ffffff,size:35,bold:true'), 0);
			nextButton.setSkin(new ButtonSkin(new Bitmap(ClassLibrary.getBitmapData('NextButtonOverSkin')), 'font:Calibri,color:#333333,size:35,bold:true'), 1);
			nextButton.setSkin(null, 2);
			nextButton.x = 632;
			nextButton.y = 667;
			nextButton.addEventListener(ButtonEvent.CLICK, this._nextButtonClickHandler);
			this.addChild(nextButton);
		}
		
		private function _nextButtonClickHandler(e:ButtonEvent):void {
			this.dispatchEvent(new Event('COMPLETE'));
		}
		
		/*****UTILS*****/
		private function _getNavigation():Array {
			var array:Array = [];
			for each(var item:XML in Application.application.confXML..button) {
				var upSkin:ButtonSkin = new ButtonSkin(new Bitmap(ClassLibrary.getBitmapData('ButtonUpSkin')), 'font:Calibri,color:#333333,size:21,bold:true');
				var overSkin:ButtonSkin = new ButtonSkin(new Bitmap(ClassLibrary.getBitmapData('ButtonOverSkin')), 'font:Calibri,color:#333333,size:21,bold:true');
				var downSkin:ButtonSkin = new ButtonSkin(new Bitmap(ClassLibrary.getBitmapData('ButtonPressSkin')), 'font:Calibri,color:#ffffff,size:21,bold:true');
				var selectedSkin:ButtonSkin = new ButtonSkin(new Bitmap(ClassLibrary.getBitmapData('ButtonPressSkin')), 'font:Calibri,color:#ffffff,size:21,bold:true');
				//
				var menuItem:MenuItemVO = new MenuItemVO();
				menuItem.id = String(item.@id);
				menuItem.label = String(item.@label);
				menuItem.url = Main.BASE_URL + this.typeUrl + String(item.@url);
				menuItem.weight = int(item.@weight);
				menuItem.icons = { 0: upSkin, 1:overSkin, 2:downSkin, 3:selectedSkin };
				array.push(menuItem);
			}
			return array;
		}
	}

}