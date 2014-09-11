package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	[Event(name="select",type="flash.events.Event")]
	public class WheelMenu extends Component {
		protected var _borderColor:uint = 0xcccccc;
		protected var _buttons:Array;
		protected var _color:uint = 0xffffff;
		protected var _highlightColor:uint = 0xeeeeee;
		protected var _iconRadius:Number;
		protected var _innerRadius:Number;
		protected var _items:Array;
		protected var _numButtons:int;
		protected var _outerRadius:Number;
		protected var _selectedIndex:int = -1;
		protected var _startingAngle:Number = -90;
		
		public function WheelMenu(numButtons:int, outerRadius:Number = 80, iconRadius:Number = 60, innerRadius:Number = 10) {
			_numButtons = numButtons;
			_outerRadius = outerRadius;
			_iconRadius = iconRadius;
			_innerRadius = innerRadius;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			super();
		}
		
		public function hide():void {
			visible = false;
			if (stage != null) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			}
		}
		
		public function setItem(index:int, iconOrLabel:Object, data:Object = null):void {
			_buttons[index].setIcon(iconOrLabel);
			_items[index] = data;
		}
		
		public function show():void {
			parent.addChild(this);
			x = Math.round(parent.mouseX);
			y = Math.round(parent.mouseY);
			_selectedIndex = -1;
			visible = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
		}
		
		public function set borderColor(value:uint):void {
			_borderColor = value;
			for (var i:int = 0; i < _numButtons; i++) {
				_buttons[i].borderColor = _borderColor;
			}
		}
		
		public function get borderColor():uint {
			return _borderColor;
		}
		
		public function set color(value:uint):void {
			_color = value;
			for (var i:int = 0; i < _numButtons; i++) {
				_buttons[i].color = _color;
			}
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set highlightColor(value:uint):void {
			_highlightColor = value;
			for (var i:int = 0; i < _numButtons; i++) {
				_buttons[i].highlightColor = _highlightColor;
			}
		}
		
		public function get highlightColor():uint {
			return _highlightColor;
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function get selectedItem():Object {
			return _items[_selectedIndex];
		}
	
		
		protected override function init():void {
			super.init();
			_items = new Array();
			makeButtons();
			
			filters = [new DropShadowFilter(4, 45, 0, 1, 4, 4, .2, 4)];
		}
		
		protected function makeButtons():void {
			_buttons = new Array();
			for (var i:int = 0; i < _numButtons; i++) {
				var btn:ArcButton = new ArcButton(Math.PI * 2 / _numButtons, _outerRadius, _iconRadius, _innerRadius);
				btn.id = i;
				btn.rotation = _startingAngle + 360 / _numButtons * i;
				btn.addEventListener(Event.SELECT, onSelect);
				addChild(btn);
				_buttons.push(btn);
			}
		}
		
		protected function onAddedToStage(event:Event):void {
			hide();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onRemovedFromStage(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onSelect(event:Event):void {
			_selectedIndex = event.target.id;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		protected function onStageMouseUp(event:MouseEvent):void {
			hide();
		}
		
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Shape;
import ua.olexandr.ui.components.Label;

class ArcButton extends Sprite {
	
	public var id:int;
	
	protected var _arc:Number;
	protected var _bg:Shape;
	protected var _borderColor:uint = 0xcccccc;
	protected var _color:uint = 0xffffff;
	protected var _highlightColor:uint = 0xeeeeee;
	protected var _icon:DisplayObject;
	protected var _iconHolder:Sprite;
	protected var _iconRadius:Number;
	protected var _innerRadius:Number;
	protected var _outerRadius:Number;
	
	public function ArcButton(arc:Number, outerRadius:Number, iconRadius:Number, innerRadius:Number) {
		_arc = arc;
		_outerRadius = outerRadius;
		_iconRadius = iconRadius;
		_innerRadius = innerRadius;
		
		_bg = new Shape();
		addChild(_bg);
		
		_iconHolder = new Sprite();
		addChild(_iconHolder);
		
		drawArc(0xffffff);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	public function setIcon(iconOrLabel:Object):void {
		if (iconOrLabel == null)
			return;
		while (_iconHolder.numChildren > 0)
			_iconHolder.removeChildAt(0);
		if (iconOrLabel is Class) {
			_icon = new (iconOrLabel as Class)() as DisplayObject;
		} else if (iconOrLabel is DisplayObject) {
			_icon = iconOrLabel as DisplayObject;
		} else if (iconOrLabel is String) {
			_icon = new Label(null, 0, 0, iconOrLabel as String);
			(_icon as Label).draw();
		}
		if (_icon != null) {
			var angle:Number = _bg.rotation * Math.PI / 180;
			_icon.x = Math.round(-_icon.width / 2);
			_icon.y = Math.round(-_icon.height / 2);
			_iconHolder.addChild(_icon);
			_iconHolder.x = Math.round(Math.cos(angle + _arc / 2) * _iconRadius);
			_iconHolder.y = Math.round(Math.sin(angle + _arc / 2) * _iconRadius);
		}
	}
	
	public function set borderColor(value:uint):void {
		_borderColor = value;
		drawArc(_color);
	}
	
	public function get borderColor():uint {
		return _borderColor;
	}
	
	public function set color(value:uint):void {
		_color = value;
		drawArc(_color);
	}
	
	public function get color():uint {
		return _color;
	}
	
	public function set highlightColor(value:uint):void {
		_highlightColor = value;
	}
	
	public function get highlightColor():uint {
		return _highlightColor;
	}
	
	public override function set rotation(value:Number):void {
		_bg.rotation = value;
	}
	
	public override function get rotation():Number {
		return _bg.rotation;
	}

	
	protected function drawArc(color:uint):void {
		_bg.graphics.clear();
		_bg.graphics.lineStyle(2, _borderColor);
		_bg.graphics.beginFill(color);
		_bg.graphics.moveTo(_innerRadius, 0);
		_bg.graphics.lineTo(_outerRadius, 0);
		for (var i:Number = 0; i < _arc; i += .05) {
			_bg.graphics.lineTo(Math.cos(i) * _outerRadius, Math.sin(i) * _outerRadius);
		}
		_bg.graphics.lineTo(Math.cos(_arc) * _outerRadius, Math.sin(_arc) * _outerRadius);
		_bg.graphics.lineTo(Math.cos(_arc) * _innerRadius, Math.sin(_arc) * _innerRadius);
		for (i = _arc; i > 0; i -= .05) {
			_bg.graphics.lineTo(Math.cos(i) * _innerRadius, Math.sin(i) * _innerRadius);
		}
		_bg.graphics.lineTo(_innerRadius, 0);
		
		graphics.endFill();
	}
	
	protected function onMouseOver(event:MouseEvent):void {
		drawArc(_highlightColor);
	}
	
	protected function onMouseOut(event:MouseEvent):void {
		drawArc(_color);
	}
	
	protected function onMouseGoUp(event:MouseEvent):void {
		dispatchEvent(new Event(Event.SELECT));
	}
	
}
