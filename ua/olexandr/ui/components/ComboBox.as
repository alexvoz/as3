package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="select",type="flash.events.Event")]
	public class ComboBox extends Component {
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		protected var _defaultLabel:String = "";
		protected var _dropDownButton:PushButton;
		protected var _items:Array;
		protected var _labelButton:PushButton;
		protected var _list:List;
		protected var _numVisibleItems:int = 6;
		protected var _open:Boolean = false;
		protected var _openPosition:String = BOTTOM;
		protected var _stage:Stage;
		
		public function ComboBox(defaultLabel:String = "", items:Array = null) {
			_defaultLabel = defaultLabel;
			_items = items || [];
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function addItem(item:Object):void {
			_list.addItem(item);
		}
		
		public function addItemAt(item:Object, index:int):void {
			_list.addItemAt(item, index);
		}
		
		public function removeItem(item:Object):void {
			_list.removeItem(item);
		}
		
		public function removeItemAt(index:int):void {
			_list.removeItemAt(index);
		}
		
		public function removeAll():void {
			_list.removeAll();
		}
		
		public override function draw():void {
			super.draw();
			_labelButton.setSize(_width - _height + 1, _height);
			_labelButton.draw();
			
			_dropDownButton.setSize(_height, _height);
			_dropDownButton.draw();
			_dropDownButton.x = _width - height;
			
			_list.setSize(_width, _numVisibleItems * _list.listItemHeight);
		}
		
		public function set selectedIndex(value:int):void {
			_list.selectedIndex = value;
			setLabelButtonLabel();
		}
		
		public function get selectedIndex():int {
			return _list.selectedIndex;
		}
		
		public function set selectedItem(item:Object):void {
			_list.selectedItem = item;
			setLabelButtonLabel();
		}
		
		public function get selectedItem():Object {
			return _list.selectedItem;
		}
		
		public function set defaultColor(value:uint):void {
			_list.defaultColor = value;
		}
		
		public function get defaultColor():uint {
			return _list.defaultColor;
		}
		
		public function set selectedColor(value:uint):void {
			_list.selectedColor = value;
		}
		
		public function get selectedColor():uint {
			return _list.selectedColor;
		}
		
		public function set rolloverColor(value:uint):void {
			_list.rolloverColor = value;
		}
		
		public function get rolloverColor():uint {
			return _list.rolloverColor;
		}
		
		public function set listItemHeight(value:Number):void {
			_list.listItemHeight = value;
			invalidate();
		}
		
		public function get listItemHeight():Number {
			return _list.listItemHeight;
		}
		
		public function set openPosition(value:String):void {
			_openPosition = value;
		}
		
		public function get openPosition():String {
			return _openPosition;
		}
		
		public function set defaultLabel(value:String):void {
			_defaultLabel = value;
			setLabelButtonLabel();
		}
		
		public function get defaultLabel():String {
			return _defaultLabel;
		}
		
		public function set numVisibleItems(value:int):void {
			_numVisibleItems = value;
			invalidate();
		}
		
		public function get numVisibleItems():int {
			return _numVisibleItems;
		}
		
		public function set items(value:Array):void {
			_list.items = value;
		}
		
		public function get items():Array {
			return _list.items;
		}
		
		public function set listItemClass(value:Class):void {
			_list.listItemClass = value;
		}
		
		public function get listItemClass():Class {
			return _list.listItemClass;
		}
		
		public function set alternateColor(value:uint):void {
			_list.alternateColor = value;
		}
		
		public function get alternateColor():uint {
			return _list.alternateColor;
		}
		
		public function set alternateRows(value:Boolean):void {
			_list.alternateRows = value;
		}
		
		public function get alternateRows():Boolean {
			return _list.alternateRows;
		}
		
		public function set autoHideScrollBar(value:Boolean):void {
			_list.autoHideScrollBar = value;
			invalidate();
		}
		
		public function get autoHideScrollBar():Boolean {
			return _list.autoHideScrollBar;
		}
		
		public function get isOpen():Boolean {
			return _open;
		}
		
		
		protected override function init():void {
			super.init();
			setSize(100, 20);
			setLabelButtonLabel();
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_list = new List(_items);
			_list.autoHideScrollBar = true;
			_list.addEventListener(Event.SELECT, onSelect);
			
			_labelButton = new PushButton();
			_labelButton.addEventListener(MouseEvent.CLICK, onDropDown);
			addChild(_labelButton);
			
			_dropDownButton = new PushButton("+");
			_dropDownButton.addEventListener(MouseEvent.CLICK, onDropDown);
			addChild(_dropDownButton);
		}
		
		protected function setLabelButtonLabel():void {
			if (selectedItem == null) {
				_labelButton.label = _defaultLabel;
			} else if (selectedItem is String) {
				_labelButton.label = selectedItem as String;
			} else if (selectedItem.hasOwnProperty("label") && selectedItem.label is String) {
				_labelButton.label = selectedItem.label;
			} else {
				_labelButton.label = selectedItem.toString();
			}
		}
		
		protected function removeList():void {
			if (_stage.contains(_list))
				_stage.removeChild(_list);
			_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			_dropDownButton.label = "+";
		}
		
		protected function onDropDown(event:MouseEvent):void {
			_open = !_open;
			if (_open) {
				var point:Point = new Point();
				if (_openPosition == BOTTOM) {
					point.y = _height;
				} else {
					point.y = -_numVisibleItems * _list.listItemHeight;
				}
				point = this.localToGlobal(point);
				_list.move(point.x, point.y);
				_stage.addChild(_list);
				_stage.addEventListener(MouseEvent.CLICK, onStageClick);
				_dropDownButton.label = "-";
			} else {
				removeList();
			}
		}
		
		protected function onStageClick(event:MouseEvent):void {
			// ignore clicks within buttons or list
			if (event.target == _dropDownButton || event.target == _labelButton)
				return;
			if (new Rectangle(_list.x, _list.y, _list.width, _list.height).contains(event.stageX, event.stageY))
				return;
			
			_open = false;
			removeList();
		}
		
		protected function onSelect(event:Event):void {
			_open = false;
			_dropDownButton.label = "+";
			if (stage != null && stage.contains(_list)) {
				stage.removeChild(_list);
			}
			setLabelButtonLabel();
			dispatchEvent(event);
		}
		
		protected function onAddedToStage(event:Event):void {
			_stage = stage;
		}
		
		protected function onRemovedFromStage(event:Event):void {
			removeList();
		}
		
	}
}