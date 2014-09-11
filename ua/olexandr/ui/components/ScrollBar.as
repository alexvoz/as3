package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ua.olexandr.ui.Style;
	
	[Event(name="change",type="flash.events.Event")]
	public class ScrollBar extends Component {
		
		protected const DELAY_TIME:int = 500;
		protected const REPEAT_TIME:int = 100;
		protected const UP:String = "up";
		protected const DOWN:String = "down";
		
		protected var _autoHide:Boolean = false;
		protected var _upButton:PushButton;
		protected var _downButton:PushButton;
		protected var _scrollSlider:ScrollSlider;
		protected var _orientation:String;
		protected var _lineSize:int = 1;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		protected var _shouldRepeat:Boolean = false;
		
		public function ScrollBar(orientation:String) {
			_orientation = orientation;
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number):void {
			_scrollSlider.setSliderParams(min, max, value);
		}
		
		public function setThumbPercent(value:Number):void {
			_scrollSlider.setThumbPercent(value);
		}
		
		public override function draw():void {
			super.draw();
			if (_orientation == Slider.VERTICAL) {
				_scrollSlider.x = 0;
				_scrollSlider.y = 10;
				_scrollSlider.width = 10;
				_scrollSlider.height = _height - 20;
				_downButton.x = 0;
				_downButton.y = _height - 10;
			} else {
				_scrollSlider.x = 10;
				_scrollSlider.y = 0;
				_scrollSlider.width = _width - 20;
				_scrollSlider.height = 10;
				_downButton.x = _width - 10;
				_downButton.y = 0;
			}
			_scrollSlider.draw();
			if (_autoHide) {
				visible = _scrollSlider.thumbPercent < 1.0;
			} else {
				visible = true;
			}
		}
		
		public function set autoHide(value:Boolean):void {
			_autoHide = value;
			invalidate();
		}
		
		public function get autoHide():Boolean {
			return _autoHide;
		}
		
		public function set value(v:Number):void {
			_scrollSlider.value = v;
		}
		
		public function get value():Number {
			return _scrollSlider.value;
		}
		
		public function set minimum(v:Number):void {
			_scrollSlider.minimum = v;
		}
		
		public function get minimum():Number {
			return _scrollSlider.minimum;
		}
		
		public function set maximum(v:Number):void {
			_scrollSlider.maximum = v;
		}
		
		public function get maximum():Number {
			return _scrollSlider.maximum;
		}
		
		public function set lineSize(value:int):void {
			_lineSize = value;
		}
		
		public function get lineSize():int {
			return _lineSize;
		}
		
		public function set pageSize(value:int):void {
			_scrollSlider.pageSize = value;
			invalidate();
		}
		
		public function get pageSize():int {
			return _scrollSlider.pageSize;
		}
		
		
		protected override function addChildren():void {
			_scrollSlider = new ScrollSlider(_orientation);
			_scrollSlider.y = 10;
			_scrollSlider.addEventListener(Event.CHANGE, onChange);
			addChild(_scrollSlider);
			_upButton = new PushButton();
			addChild(_upButton);
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_upButton.setSize(10, 10);
			var upArrow:Shape = new Shape();
			_upButton.addChild(upArrow);
			
			_downButton = new PushButton();
			addChild(_downButton);
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			_downButton.setSize(10, 10);
			var downArrow:Shape = new Shape();
			_downButton.addChild(downArrow);
			
			if (_orientation == Slider.VERTICAL) {
				upArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
				upArrow.graphics.moveTo(5, 3);
				upArrow.graphics.lineTo(7, 6);
				upArrow.graphics.lineTo(3, 6);
				upArrow.graphics.endFill();
				
				downArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
				downArrow.graphics.moveTo(5, 7);
				downArrow.graphics.lineTo(7, 4);
				downArrow.graphics.lineTo(3, 4);
				downArrow.graphics.endFill();
			} else {
				upArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
				upArrow.graphics.moveTo(3, 5);
				upArrow.graphics.lineTo(6, 7);
				upArrow.graphics.lineTo(6, 3);
				upArrow.graphics.endFill();
				
				downArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
				downArrow.graphics.moveTo(7, 5);
				downArrow.graphics.lineTo(4, 7);
				downArrow.graphics.lineTo(4, 3);
				downArrow.graphics.endFill();
			}
		
		}
		
		protected override function init():void {
			super.init();
			if (_orientation == Slider.HORIZONTAL) {
				setSize(100, 10);
			} else {
				setSize(10, 100);
			}
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}
		
		protected function onUpClick(event:MouseEvent):void {
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goUp():void {
			_scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDownClick(event:MouseEvent):void {
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goDown():void {
			_scrollSlider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseGoUp(event:MouseEvent):void {
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}
		
		protected function onChange(event:Event):void {
			dispatchEvent(event);
		}
		
		protected function onDelayComplete(event:TimerEvent):void {
			if (_shouldRepeat) {
				_repeatTimer.start();
			}
		}
		
		protected function onRepeat(event:TimerEvent):void {
			if (_direction == UP) {
				goUp();
			} else {
				goDown();
			}
		}
	
	}
}

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import ua.olexandr.ui.components.Slider;
import ua.olexandr.ui.Style;

class ScrollSlider extends Slider {
	protected var _thumbPercent:Number = 1.0;
	protected var _pageSize:int = 1;
	
	public function ScrollSlider(orientation:String) {
		super(orientation);
	}
	
	public function setThumbPercent(value:Number):void {
		_thumbPercent = Math.min(value, 1.0);
		invalidate();
	}
	
	public function set pageSize(value:int):void {
		_pageSize = value;
		invalidate();
	}
	
	public function get pageSize():int {
		return _pageSize;
	}
	
	public function get thumbPercent():Number {
		return _thumbPercent;
	}
	
	
	protected override function init():void {
		super.init();
		setSliderParams(1, 1, 0);
		backClick = true;
	}
	
	protected override function drawHandle():void {
		var size:Number;
		_handle.graphics.clear();
		if (_orientation == HORIZONTAL) {
			size = Math.round(_width * _thumbPercent);
			size = Math.max(_height, size);
			_handle.graphics.beginFill(0, 0);
			_handle.graphics.drawRect(0, 0, size, _height);
			_handle.graphics.endFill();
			_handle.graphics.beginFill(Style.BUTTON_FACE);
			_handle.graphics.drawRect(1, 1, size - 2, _height - 2);
		} else {
			size = Math.round(_height * _thumbPercent);
			size = Math.max(_width, size);
			_handle.graphics.beginFill(0, 0);
			_handle.graphics.drawRect(0, 0, _width - 2, size);
			_handle.graphics.endFill();
			_handle.graphics.beginFill(Style.BUTTON_FACE);
			_handle.graphics.drawRect(1, 1, _width - 2, size - 2);
		}
		_handle.graphics.endFill();
		positionHandle();
	}
	
	protected override function positionHandle():void {
		var range:Number;
		if (_orientation == HORIZONTAL) {
			range = width - _handle.width;
			_handle.x = (_value - _min) / (_max - _min) * range;
		} else {
			range = height - _handle.height;
			_handle.y = (_value - _min) / (_max - _min) * range;
		}
	}
	
	protected override function onBackClick(event:MouseEvent):void {
		if (_orientation == HORIZONTAL) {
			if (mouseX < _handle.x) {
				if (_max > _min) {
					_value -= _pageSize;
				} else {
					_value += _pageSize;
				}
				correctValue();
			} else {
				if (_max > _min) {
					_value += _pageSize;
				} else {
					_value -= _pageSize;
				}
				correctValue();
			}
			positionHandle();
		} else {
			if (mouseY < _handle.y) {
				if (_max > _min) {
					_value -= _pageSize;
				} else {
					_value += _pageSize;
				}
				correctValue();
			} else {
				if (_max > _min) {
					_value += _pageSize;
				} else {
					_value -= _pageSize;
				}
				correctValue();
			}
			positionHandle();
		}
		dispatchEvent(new Event(Event.CHANGE));
	
	}
	
	protected override function onDrag(event:MouseEvent):void {
		stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
		if (_orientation == HORIZONTAL) {
			_handle.startDrag(false, new Rectangle(0, 0, _width - _handle.width, 0));
		} else {
			_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _handle.height));
		}
	}
	
	protected override function onSlide(event:MouseEvent):void {
		var oldValue:Number = _value;
		if (_orientation == HORIZONTAL) {
			if (_width == _handle.width) {
				_value = _min;
			} else {
				_value = _handle.x / (_width - _handle.width) * (_max - _min) + _min;
			}
		} else {
			if (_height == _handle.height) {
				_value = _min;
			} else {
				_value = _handle.y / (_height - _handle.height) * (_max - _min) + _min;
			}
		}
		if (_value != oldValue) {
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
}
