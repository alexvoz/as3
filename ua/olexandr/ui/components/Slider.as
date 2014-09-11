package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ua.olexandr.ui.Style;
	
	[Event(name="change",type="flash.events.Event")]
	public class Slider extends Component {
		protected var _handle:Sprite;
		protected var _back:Sprite;
		protected var _backClick:Boolean = true;
		protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;
		protected var _tick:Number = 0.01;
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		public function Slider(orientation:String = Slider.HORIZONTAL) {
			_orientation = orientation;
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number):void {
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}
		
		public override function draw():void {
			super.draw();
			drawBack();
			drawHandle();
		}
		
		public function set backClick(b:Boolean):void {
			_backClick = b;
			invalidate();
		}
		
		public function get backClick():Boolean {
			return _backClick;
		}
		
		public function set value(v:Number):void {
			_value = v;
			correctValue();
			positionHandle();
		
		}
		
		public function get value():Number {
			return Math.round(_value / _tick) * _tick;
		}
		
		public function get rawValue():Number {
			return _value;
		}
		
		public function set maximum(m:Number):void {
			_max = m;
			correctValue();
			positionHandle();
		}
		
		public function get maximum():Number {
			return _max;
		}
		
		public function set minimum(m:Number):void {
			_min = m;
			correctValue();
			positionHandle();
		}
		
		public function get minimum():Number {
			return _min;
		}
		
		public function set tick(t:Number):void {
			_tick = t;
		}
		
		public function get tick():Number {
			return _tick;
		}
		
		
		protected override function init():void {
			super.init();
			
			if (_orientation == HORIZONTAL) {
				setSize(100, 10);
			} else {
				setSize(10, 100);
			}
		}
		
		protected override function addChildren():void {
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_handle = new Sprite();
			_handle.filters = [getShadow(1)];
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			_handle.buttonMode = true;
			_handle.useHandCursor = true;
			addChild(_handle);
		}
		
		protected function drawBack():void {
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
			
			if (_backClick) {
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			} else {
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}
		
		protected function drawHandle():void {
			_handle.graphics.clear();
			_handle.graphics.beginFill(Style.BUTTON_FACE);
			if (_orientation == HORIZONTAL) {
				_handle.graphics.drawRect(1, 1, _height - 2, _height - 2);
			} else {
				_handle.graphics.drawRect(1, 1, _width - 2, _width - 2);
			}
			_handle.graphics.endFill();
			positionHandle();
		}
		
		protected function correctValue():void {
			if (_max > _min) {
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			} else {
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
		
		protected function positionHandle():void {
			var range:Number;
			if (_orientation == HORIZONTAL) {
				range = _width - _height;
				_handle.x = (_value - _min) / (_max - _min) * range;
			} else {
				range = _height - _width;
				_handle.y = _height - _width - (_value - _min) / (_max - _min) * range;
			}
		}
		
		protected function onBackClick(event:MouseEvent):void {
			if (_orientation == HORIZONTAL) {
				_handle.x = mouseX - _height / 2;
				_handle.x = Math.max(_handle.x, 0);
				_handle.x = Math.min(_handle.x, _width - _height);
				_value = _handle.x / (width - _height) * (_max - _min) + _min;
			} else {
				_handle.y = mouseY - _width / 2;
				_handle.y = Math.max(_handle.y, 0);
				_handle.y = Math.min(_handle.y, _height - _width);
				_value = (_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
			}
			dispatchEvent(new Event(Event.CHANGE));
		
		}
		
		protected function onDrag(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if (_orientation == HORIZONTAL) {
				_handle.startDrag(false, new Rectangle(0, 0, _width - _height, 0));
			} else {
				_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _width));
			}
		}
		
		protected function onDrop(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}
		
		protected function onSlide(event:MouseEvent):void {
			var oldValue:Number = _value;
			if (_orientation == HORIZONTAL) {
				_value = _handle.x / (width - _height) * (_max - _min) + _min;
			} else {
				_value = (_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
			}
			if (_value != oldValue) {
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
	}
}
