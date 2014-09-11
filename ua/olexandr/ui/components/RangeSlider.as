package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="change",type="flash.events.Event")]
	public class RangeSlider extends Component {
		
		public static const ALWAYS:String = "always";
		public static const BOTTOM:String = "bottom";
		public static const HORIZONTAL:String = "horizontal";
		public static const LEFT:String = "left";
		public static const MOVE:String = "move";
		public static const NEVER:String = "never";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const VERTICAL:String = "vertical";
		
		protected var _back:Sprite;
		protected var _highLabel:Label;
		protected var _highValue:Number = 100;
		protected var _labelMode:String = ALWAYS;
		protected var _labelPosition:String;
		protected var _labelPrecision:int = 0;
		protected var _lowLabel:Label;
		protected var _lowValue:Number = 0;
		protected var _maximum:Number = 100;
		protected var _maxHandle:Sprite;
		protected var _minimum:Number = 0;
		protected var _minHandle:Sprite;
		protected var _orientation:String = VERTICAL;
		protected var _tick:Number = 1;
		
		public function RangeSlider(orientation:String) {
			_orientation = orientation;
			super();
		}
		
		public override function draw():void {
			super.draw();
			drawBack();
			drawHandles();
		}
		
		public function set minimum(value:Number):void {
			_minimum = value;
			_maximum = Math.max(_maximum, _minimum);
			_lowValue = Math.max(_lowValue, _minimum);
			_highValue = Math.max(_highValue, _minimum);
			positionHandles();
		}
		
		public function get minimum():Number {
			return _minimum;
		}
		
		public function set maximum(value:Number):void {
			_maximum = value;
			_minimum = Math.min(_minimum, _maximum);
			_lowValue = Math.min(_lowValue, _maximum);
			_highValue = Math.min(_highValue, _maximum);
			positionHandles();
		}
		
		public function get maximum():Number {
			return _maximum;
		}
		
		public function set lowValue(value:Number):void {
			_lowValue = value;
			_lowValue = Math.min(_lowValue, _highValue);
			_lowValue = Math.max(_lowValue, _minimum);
			positionHandles();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get lowValue():Number {
			return Math.round(_lowValue / _tick) * _tick;
		}
		
		public function set highValue(value:Number):void {
			_highValue = value;
			_highValue = Math.max(_highValue, _lowValue);
			_highValue = Math.min(_highValue, _maximum);
			positionHandles();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get highValue():Number {
			return Math.round(_highValue / _tick) * _tick;
		}
		
		public function set labelMode(value:String):void {
			_labelMode = value;
			_highLabel.visible = (_labelMode == ALWAYS);
			_lowLabel.visible = (_labelMode == ALWAYS);
		}
		
		public function get labelMode():String {
			return _labelMode;
		}
		
		public function set labelPosition(value:String):void {
			_labelPosition = value;
			updateLabels();
		}
		
		public function get labelPosition():String {
			return _labelPosition;
		}
		
		public function set labelPrecision(value:int):void {
			_labelPrecision = value;
			updateLabels();
		}
		
		public function get labelPrecision():int {
			return _labelPrecision;
		}
		
		public function set tick(value:Number):void {
			_tick = value;
			updateLabels();
		}
		
		public function get tick():Number {
			return _tick;
		}
	
		
		protected override function init():void {
			super.init();
			if (_orientation == HORIZONTAL) {
				setSize(110, 10);
				_labelPosition = TOP;
			} else {
				setSize(10, 110);
				_labelPosition = RIGHT;
			}
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_minHandle = new Sprite();
			_minHandle.filters = [getShadow(1)];
			_minHandle.addEventListener(MouseEvent.MOUSE_DOWN, onDragMin);
			_minHandle.buttonMode = true;
			_minHandle.useHandCursor = true;
			addChild(_minHandle);
			
			_maxHandle = new Sprite();
			_maxHandle.filters = [getShadow(1)];
			_maxHandle.addEventListener(MouseEvent.MOUSE_DOWN, onDragMax);
			_maxHandle.buttonMode = true;
			_maxHandle.useHandCursor = true;
			addChild(_maxHandle);
			
			_lowLabel = new Label(this);
			_highLabel = new Label(this);
			_lowLabel.visible = (_labelMode == ALWAYS);
		}
		
		protected function drawBack():void {
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
		}
		
		protected function drawHandles():void {
			_minHandle.graphics.clear();
			_minHandle.graphics.beginFill(Style.BUTTON_FACE);
			_maxHandle.graphics.clear();
			_maxHandle.graphics.beginFill(Style.BUTTON_FACE);
			if (_orientation == HORIZONTAL) {
				_minHandle.graphics.drawRect(1, 1, _height - 2, _height - 2);
				_maxHandle.graphics.drawRect(1, 1, _height - 2, _height - 2);
			} else {
				_minHandle.graphics.drawRect(1, 1, _width - 2, _width - 2);
				_maxHandle.graphics.drawRect(1, 1, _width - 2, _width - 2);
			}
			_minHandle.graphics.endFill();
			positionHandles();
		}
		
		protected function positionHandles():void {
			var range:Number;
			if (_orientation == HORIZONTAL) {
				range = _width - _height * 2;
				_minHandle.x = (_lowValue - _minimum) / (_maximum - _minimum) * range;
				_maxHandle.x = _height + (_highValue - _minimum) / (_maximum - _minimum) * range;
			} else {
				range = _height - _width * 2;
				_minHandle.y = _height - _width - (_lowValue - _minimum) / (_maximum - _minimum) * range;
				_maxHandle.y = _height - _width * 2 - (_highValue - _minimum) / (_maximum - _minimum) * range;
			}
			updateLabels();
		}
		
		protected function updateLabels():void {
			_lowLabel.text = getLabelForValue(lowValue);
			_highLabel.text = getLabelForValue(highValue);
			_lowLabel.draw();
			_highLabel.draw();
			
			if (_orientation == VERTICAL) {
				_lowLabel.y = _minHandle.y + (_width - _lowLabel.height) * 0.5;
				_highLabel.y = _maxHandle.y + (_width - _highLabel.height) * 0.5;
				if (_labelPosition == LEFT) {
					_lowLabel.x = -_lowLabel.width - 5;
					_highLabel.x = -_highLabel.width - 5;
				} else {
					_lowLabel.x = _width + 5;
					_highLabel.x = _width + 5;
				}
			} else {
				_lowLabel.x = _minHandle.x - _lowLabel.width + _height;
				_highLabel.x = _maxHandle.x;
				if (_labelPosition == BOTTOM) {
					_lowLabel.y = _height + 2;
					_highLabel.y = _height + 2;
				} else {
					_lowLabel.y = -_lowLabel.height;
					_highLabel.y = -_highLabel.height;
				}
				
			}
		}
		
		protected function getLabelForValue(value:Number):String {
			var str:String = (Math.round(value * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision)).toString();
			if (_labelPrecision > 0) {
				var decimal:String = str.split(".")[1] || "";
				if (decimal.length == 0)
					str += ".";
				for (var i:int = decimal.length; i < _labelPrecision; i++) {
					str += "0";
				}
			}
			return str;
		}
		
		protected function onDragMin(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMinSlide);
			if (_orientation == HORIZONTAL) {
				_minHandle.startDrag(false, new Rectangle(0, 0, _maxHandle.x - _height, 0));
			} else {
				_minHandle.startDrag(false, new Rectangle(0, _maxHandle.y + _width, 0, _height - _maxHandle.y - _width * 2));
			}
			if (_labelMode == MOVE) {
				_lowLabel.visible = true;
				_highLabel.visible = true;
			}
		}
		
		protected function onDragMax(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMaxSlide);
			if (_orientation == HORIZONTAL) {
				_maxHandle.startDrag(false, new Rectangle(_minHandle.x + _height, 0, _width - _height - _minHandle.x - _height, 0));
			} else {
				_maxHandle.startDrag(false, new Rectangle(0, 0, 0, _minHandle.y - _width));
			}
			if (_labelMode == MOVE) {
				_lowLabel.visible = true;
				_highLabel.visible = true;
			}
		}
		
		protected function onDrop(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMinSlide);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMaxSlide);
			stopDrag();
			if (_labelMode == MOVE) {
				_lowLabel.visible = false;
				_highLabel.visible = false;
			}
		}
		
		protected function onMinSlide(event:MouseEvent):void {
			var oldValue:Number = _lowValue;
			if (_orientation == HORIZONTAL) {
				_lowValue = _minHandle.x / (_width - _height * 2) * (_maximum - _minimum) + _minimum;
			} else {
				_lowValue = (_height - _width - _minHandle.y) / (height - _width * 2) * (_maximum - _minimum) + _minimum;
			}
			if (_lowValue != oldValue) {
				dispatchEvent(new Event(Event.CHANGE));
			}
			updateLabels();
		}
		
		protected function onMaxSlide(event:MouseEvent):void {
			var oldValue:Number = _highValue;
			if (_orientation == HORIZONTAL) {
				_highValue = (_maxHandle.x - _height) / (_width - _height * 2) * (_maximum - _minimum) + _minimum;
			} else {
				_highValue = (_height - _width * 2 - _maxHandle.y) / (_height - _width * 2) * (_maximum - _minimum) + _minimum;
			}
			if (_highValue != oldValue) {
				dispatchEvent(new Event(Event.CHANGE));
			}
			updateLabels();
		}
		
	}
}