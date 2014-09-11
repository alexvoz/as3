package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ua.olexandr.ui.Style;
	
	[Event(name="select",type="flash.events.Event")]
	public class List extends Component {
		protected var _items:Array;
		protected var _itemHolder:Sprite;
		protected var _panel:Panel;
		protected var _listItemHeight:Number = 20;
		protected var _listItemClass:Class = ListItem;
		protected var _scrollbar:VScrollBar;
		protected var _selectedIndex:int = -1;
		protected var _defaultColor:uint = Style.LIST_DEFAULT;
		protected var _alternateColor:uint = Style.LIST_ALTERNATE;
		protected var _selectedColor:uint = Style.LIST_SELECTED;
		protected var _rolloverColor:uint = Style.LIST_ROLLOVER;
		protected var _alternateRows:Boolean = false;
		
		public function List(items:Array = null) {
			_items = items || [];
		}
		
		public override function draw():void {
			super.draw();
			
			_selectedIndex = Math.min(_selectedIndex, _items.length - 1);
			
			// panel
			_panel.setSize(_width, _height);
			_panel.color = _defaultColor;
			_panel.draw();
			
			// scrollbar
			_scrollbar.x = _width - 10;
			var contentHeight:Number = _items.length * _listItemHeight;
			_scrollbar.setThumbPercent(_height / contentHeight);
			var pageSize:Number = Math.floor(_height / _listItemHeight);
			_scrollbar.maximum = Math.max(0, _items.length - pageSize);
			_scrollbar.pageSize = pageSize;
			_scrollbar.height = _height;
			_scrollbar.draw();
			scrollToSelection();
		}
		
		public function addItem(item:Object):void {
			_items.push(item);
			invalidate();
			makeListItems();
			fillItems();
		}
		
		public function addItemAt(item:Object, index:int):void {
			index = Math.max(0, index);
			index = Math.min(_items.length, index);
			_items.splice(index, 0, item);
			invalidate();
			fillItems();
		}
		
		public function removeItem(item:Object):void {
			var index:int = _items.indexOf(item);
			removeItemAt(index);
		}
		
		public function removeItemAt(index:int):void {
			if (index < 0 || index >= _items.length)
				return;
			_items.splice(index, 1);
			invalidate();
			fillItems();
		}
		
		public function removeAll():void {
			_items.length = 0;
			invalidate();
			//makeListItems();
			fillItems();
		}
		
		public function set selectedIndex(value:int):void {
			if (value >= 0 && value < _items.length) {
				_selectedIndex = value;
//				_scrollbar.value = _selectedIndex;
			} else {
				_selectedIndex = -1;
			}
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedItem(item:Object):void {
			var index:int = _items.indexOf(item);
//			if(index != -1)
//			{
			selectedIndex = index;
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
//			}
		}
		
		public function get selectedItem():Object {
			if (_selectedIndex >= 0 && _selectedIndex < _items.length) {
				return _items[_selectedIndex];
			}
			return null;
		}
		
		public function set defaultColor(value:uint):void {
			_defaultColor = value;
			invalidate();
		}
		
		public function get defaultColor():uint {
			return _defaultColor;
		}
		
		public function set selectedColor(value:uint):void {
			_selectedColor = value;
			invalidate();
		}
		
		public function get selectedColor():uint {
			return _selectedColor;
		}
		
		public function set rolloverColor(value:uint):void {
			_rolloverColor = value;
			invalidate();
		}
		
		public function get rolloverColor():uint {
			return _rolloverColor;
		}
		
		public function set listItemHeight(value:Number):void {
			_listItemHeight = value;
			makeListItems();
			invalidate();
		}
		
		public function get listItemHeight():Number {
			return _listItemHeight;
		}
		
		public function set items(value:Array):void {
			_items = value;
			invalidate();
		}
		
		public function get items():Array {
			return _items;
		}
		
		public function set listItemClass(value:Class):void {
			_listItemClass = value;
			makeListItems();
			invalidate();
		}
		
		public function get listItemClass():Class {
			return _listItemClass;
		}
		
		public function set alternateColor(value:uint):void {
			_alternateColor = value;
			invalidate();
		}
		
		public function get alternateColor():uint {
			return _alternateColor;
		}
		
		public function set alternateRows(value:Boolean):void {
			_alternateRows = value;
			invalidate();
		}
		
		public function get alternateRows():Boolean {
			return _alternateRows;
		}
		
		public function set autoHideScrollBar(value:Boolean):void {
			_scrollbar.autoHide = value;
		}
		
		public function get autoHideScrollBar():Boolean {
			return _scrollbar.autoHide;
		}
	
		
		protected override function init():void {
			super.init();
			setSize(100, 100);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.RESIZE, onResize);
			makeListItems();
			fillItems();
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_panel = new Panel();
			addChild(_panel);
			_panel.color = _defaultColor;
			_itemHolder = new Sprite();
			_panel.content.addChild(_itemHolder);
			_scrollbar = new VScrollBar();
			_scrollbar.addEventListener(Event.CHANGE, onScroll);
			addChild(_scrollbar);
			_scrollbar.setSliderParams(0, 0, 0);
		}
		
		protected function makeListItems():void {
			var item:ListItem;
			while (_itemHolder.numChildren > 0) {
				item = ListItem(_itemHolder.getChildAt(0));
				item.removeEventListener(MouseEvent.CLICK, onSelect);
				_itemHolder.removeChildAt(0);
			}
			
			var numItems:int = Math.ceil(_height / _listItemHeight);
			//numItems = Math.min(numItems, _items.length);
			//numItems = Math.min(numItems, _itemHolder.numChildren);
			
			for (var i:int = 0; i < numItems; i++) {
				item = new _listItemClass();
				item.setSize(width, _listItemHeight);
				item.defaultColor = _defaultColor;
				item.y = i * _listItemHeight;
				_itemHolder.addChild(item);
				
				item.selectedColor = _selectedColor;
				item.rolloverColor = _rolloverColor;
				item.addEventListener(MouseEvent.CLICK, onSelect);
			}
		}
		
		protected function fillItems():void {
			if (_items) {
				var offset:int = _scrollbar.value;
				var numItems:int = Math.ceil(_height / _listItemHeight);
				//numItems = Math.min(numItems, _items.length);
				//numItems = Math.min(numItems, _itemHolder.numChildren);
				
				for (var i:int = 0; i < numItems; i++) {
					var item:ListItem = _itemHolder.getChildAt(i) as ListItem;
					if (offset + i < _items.length) {
						item.data = _items[offset + i];
						item.visible = true;
					} else {
						item.data = "";
						item.visible = false;
					}
					
					if (_alternateRows) {
						item.defaultColor = ((offset + i) % 2 == 0) ? _defaultColor : _alternateColor;
					} else {
						item.defaultColor = _defaultColor;
					}
					
					item.selected = offset + i == _selectedIndex;
				}
			}
		}
		
		protected function scrollToSelection():void {
			var numItems:int = Math.ceil(_height / _listItemHeight);
			if (_selectedIndex != -1) {
				if (_scrollbar.value > _selectedIndex) {
//                    _scrollbar.value = _selectedIndex;
				} else if (_scrollbar.value + numItems < _selectedIndex) {
					_scrollbar.value = _selectedIndex - numItems + 1;
				}
			} else {
				_scrollbar.value = 0;
			}
			fillItems();
		}
		
		protected function onSelect(event:Event):void {
			if (!(event.target is ListItem))
				return;
			
			var offset:int = _scrollbar.value;
			
			for (var i:int = 0; i < _itemHolder.numChildren; i++) {
				if (_itemHolder.getChildAt(i) == event.target) {
					_selectedIndex = i + offset;
					ListItem(_itemHolder.getChildAt(i)).selected = true;
				} else {
					ListItem(_itemHolder.getChildAt(i)).selected = false;
				}
			}
			
			dispatchEvent(new Event(Event.SELECT));
		}
		
		protected function onScroll(event:Event):void {
			fillItems();
		}
		
		protected function onMouseWheel(event:MouseEvent):void {
			_scrollbar.value -= event.delta;
			fillItems();
		}
		
		protected function onResize(event:Event):void {
			makeListItems();
			fillItems();
		}
		
	}
}