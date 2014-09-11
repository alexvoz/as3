package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ua.olexandr.ui.Style;
	
	[Event(name="change",type="flash.events.Event")]
	
	public class Knob extends Component {
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		public static const ROTATE:String = "rotate";
		
		protected var _knob:Sprite;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _mode:String = VERTICAL;
		protected var _mouseRange:Number = 100;
		protected var _precision:int = 1;
		protected var _radius:Number = 20;
		protected var _startX:Number;
		protected var _startY:Number;
		protected var _value:Number = 0;
		protected var _valueLabel:Label;
		
		public function Knob(label:String = "") {
			_labelText = label;
			super();
		}
		
		public override function draw():void {
			super.draw();
			
			drawKnob();
			
			_label.text = _labelText;
			_label.draw();
			_label.x = _radius - _label.width / 2;
			_label.y = 0;
			
			formatValueLabel();
			_valueLabel.x = _radius - _valueLabel.width / 2;
			_valueLabel.y = _radius * 2 + 20;
			
			_width = _radius * 2;
			_height = _radius * 2 + 40;
		}
		
		public function set maximum(m:Number):void {
			_max = m;
			correctValue();
			updateKnob();
		}
		
		public function get maximum():Number {
			return _max;
		}
		
		public function set minimum(m:Number):void {
			_min = m;
			correctValue();
			updateKnob();
		}
		
		public function get minimum():Number {
			return _min;
		}
		
		public function set value(v:Number):void {
			_value = v;
			correctValue();
			updateKnob();
		}
		
		public function get value():Number {
			return _value;
		}
		
		public function set mouseRange(value:Number):void {
			_mouseRange = value;
		}
		
		public function get mouseRange():Number {
			return _mouseRange;
		}
		
		public function set labelPrecision(decimals:int):void {
			_precision = decimals;
		}
		
		public function get labelPrecision():int {
			return _precision;
		}
		
		public function set showValue(value:Boolean):void {
			_valueLabel.visible = value;
		}
		
		public function get showValue():Boolean {
			return _valueLabel.visible;
		}
		
		public function set label(str:String):void {
			_labelText = str;
			draw();
		}
		
		public function get label():String {
			return _labelText;
		}
		
		public function set mode(value:String):void {
			_mode = value;
		}
		
		public function get mode():String {
			return _mode;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			_width = _radius * 2;
			_height = _radius * 2 + 40;
			invalidate();
		}
		
		
		protected override function init():void {
			super.init();
		}
		
		protected override function addChildren():void {
			_knob = new Sprite();
			_knob.buttonMode = true;
			_knob.useHandCursor = true;
			_knob.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addChild(_knob);
			
			_label = new Label();
			_label.autoSize = true;
			addChild(_label);
			
			_valueLabel = new Label();
			_valueLabel.autoSize = true;
			addChild(_valueLabel);
			
			_width = _radius * 2;
			_height = _radius * 2 + 40;
		}
		
		protected function drawKnob():void {
			_knob.graphics.clear();
			_knob.graphics.beginFill(Style.BACKGROUND);
			_knob.graphics.drawCircle(0, 0, _radius);
			_knob.graphics.endFill();
			
			_knob.graphics.beginFill(Style.BUTTON_FACE);
			_knob.graphics.drawCircle(0, 0, _radius - 2);
			_knob.graphics.endFill();
			
			_knob.graphics.beginFill(Style.BACKGROUND);
			var s:Number = _radius * .1;
			_knob.graphics.drawRect(_radius, -s, s * 1.5, s * 2);
			_knob.graphics.endFill();
			
			_knob.x = _radius;
			_knob.y = _radius + 20;
			updateKnob();
		}
		
		protected function updateKnob():void {
			_knob.rotation = -225 + (_value - _min) / (_max - _min) * 270;
			formatValueLabel();
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
		
		protected function formatValueLabel():void {
			var mult:Number = Math.pow(10, _precision);
			var val:String = (Math.round(_value * mult) / mult).toString();
			var parts:Array = val.split(".");
			if (parts[1] == null) {
				if (_precision > 0) {
					val += ".";
				}
				for (var i:uint = 0; i < _precision; i++) {
					val += "0";
				}
			} else if (parts[1].length < _precision) {
				for (i = 0; i < _precision - parts[1].length; i++) {
					val += "0";
				}
			}
			_valueLabel.text = val;
			_valueLabel.draw();
			_valueLabel.x = width / 2 - _valueLabel.width / 2;
		}
		
		protected function onMouseGoDown(event:MouseEvent):void {
			_startX = mouseX;
			_startY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMouseMoved(event:MouseEvent):void {
			var oldValue:Number = _value;
			if (_mode == ROTATE) {
				var angle:Number = Math.atan2(mouseY - _knob.y, mouseX - _knob.x);
				var rot:Number = angle * 180 / Math.PI - 135;
				while (rot > 360)
					rot -= 360;
				while (rot < 0)
					rot += 360;
				if (rot > 270 && rot < 315)
					rot = 270;
				if (rot >= 315 && rot <= 360)
					rot = 0;
				_value = rot / 270 * (_max - _min) + _min;
				if (_value != oldValue) {
					dispatchEvent(new Event(Event.CHANGE));
				}
				_knob.rotation = rot + 135;
				formatValueLabel();
			} else if (_mode == VERTICAL) {
				var diff:Number = _startY - mouseY;
				var range:Number = _max - _min;
				var percent:Number = range / _mouseRange;
				_value += percent * diff;
				correctValue();
				if (_value != oldValue) {
					updateKnob();
					dispatchEvent(new Event(Event.CHANGE));
				}
				_startY = mouseY;
			} else if (_mode == HORIZONTAL) {
				diff = _startX - mouseX;
				range = _max - _min;
				percent = range / _mouseRange;
				_value -= percent * diff;
				correctValue();
				if (_value != oldValue) {
					updateKnob();
					dispatchEvent(new Event(Event.CHANGE));
				}
				_startX = mouseX;
			}
		}
		
		protected function onMouseGoUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
	}
}