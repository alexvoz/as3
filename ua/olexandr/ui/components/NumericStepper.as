package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="change",type="flash.events.Event")]
	public class NumericStepper extends Component {
		protected const DELAY_TIME:int = 500;
		protected const UP:String = "up";
		protected const DOWN:String = "down";
		protected var _minusBtn:PushButton;
		
		protected var _repeatTime:int = 100;
		protected var _plusBtn:PushButton;
		protected var _valueText:InputText;
		protected var _value:Number = 0;
		protected var _step:Number = 1;
		protected var _labelPrecision:int = 1;
		protected var _maximum:Number = Number.POSITIVE_INFINITY;
		protected var _minimum:Number = Number.NEGATIVE_INFINITY;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		
		public function NumericStepper() {
			
		}
		
		public override function draw():void {
			_plusBtn.x = _width - 16;
			_minusBtn.x = _width - 32;
			_valueText.text = (Math.round(_value * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision)).toString();
			_valueText.width = _width - 32;
			_valueText.draw();
		}
		
		public function set value(val:Number):void {
			if (val <= _maximum && val >= _minimum) {
				_value = val;
				invalidate();
			}
		}
		
		public function get value():Number {
			return _value;
		}
		
		public function set step(value:Number):void {
			if (value < 0) {
				throw new Error("NumericStepper step must be positive.");
			}
			_step = value;
		}
		
		public function get step():Number {
			return _step;
		}
		
		public function set labelPrecision(value:int):void {
			_labelPrecision = value;
			invalidate();
		}
		
		public function get labelPrecision():int {
			return _labelPrecision;
		}
		
		public function set maximum(value:Number):void {
			_maximum = value;
			if (_value > _maximum) {
				_value = _maximum;
				invalidate();
			}
		}
		
		public function get maximum():Number {
			return _maximum;
		}
		
		public function set minimum(value:Number):void {
			_minimum = value;
			if (_value < _minimum) {
				_value = _minimum;
				invalidate();
			}
		}
		
		public function get minimum():Number {
			return _minimum;
		}
		
		public function get repeatTime():int {
			return _repeatTime;
		}
		
		public function set repeatTime(value:int):void {
			// shouldn't be any need to set it faster than 10 ms. guard against negative.
			_repeatTime = Math.max(value, 10);
			_repeatTimer.delay = _repeatTime;
		}
		
		
		protected override function init():void {
			super.init();
			setSize(80, 16);
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(_repeatTime);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}
		
		protected override function addChildren():void {
			_valueText = new InputText("0", onValueTextChange);
			_valueText.restrict = "-0123456789.";
			addChild(_valueText);
			
			_minusBtn = new PushButton("-");
			_minusBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMinus);
			_minusBtn.setSize(16, 16);
			addChild(_minusBtn);
			
			_plusBtn = new PushButton("+");
			_plusBtn.addEventListener(MouseEvent.MOUSE_DOWN, onPlus);
			_plusBtn.setSize(16, 16);
			addChild(_plusBtn);
		}
		
		protected function increment():void {
			if (_value + _step <= _maximum) {
				_value += _step;
				invalidate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function decrement():void {
			if (_value - _step >= _minimum) {
				_value -= _step;
				invalidate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function onMinus(event:MouseEvent):void {
			decrement();
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onPlus(event:MouseEvent):void {
			increment();
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMouseGoUp(event:MouseEvent):void {
			_delayTimer.stop();
			_repeatTimer.stop();
		}
		
		protected function onValueTextChange(event:Event):void {
			event.stopImmediatePropagation();
			var newVal:Number = Number(_valueText.text);
			if (newVal <= _maximum && newVal >= _minimum) {
				_value = newVal;
				invalidate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function onDelayComplete(event:TimerEvent):void {
			_repeatTimer.start();
		}
		
		protected function onRepeat(event:TimerEvent):void {
			if (_direction == UP) {
				increment();
			} else {
				decrement();
			}
		}
		
	}
}