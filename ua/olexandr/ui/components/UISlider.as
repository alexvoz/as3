package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	[Event(name="change",type="flash.events.Event")]
	public class UISlider extends Component {
		protected var _label:Label;
		protected var _valueLabel:Label;
		protected var _slider:Slider;
		protected var _precision:int = 1;
		protected var _sliderClass:Class;
		protected var _labelText:String;
		protected var _tick:Number = 1;
		
		public function UISlider(label:String = "") {
			_labelText = label;
			super();
			formatValueLabel();
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number):void {
			_slider.setSliderParams(min, max, value);
		}
		
		public override function draw():void {
			super.draw();
			_label.text = _labelText;
			_label.draw();
			formatValueLabel();
		}
		
		public function set value(v:Number):void {
			_slider.value = v;
			formatValueLabel();
		}
		
		public function get value():Number {
			return _slider.value;
		}
		
		public function set maximum(m:Number):void {
			_slider.maximum = m;
		}
		
		public function get maximum():Number {
			return _slider.maximum;
		}
		
		public function set minimum(m:Number):void {
			_slider.minimum = m;
		}
		
		public function get minimum():Number {
			return _slider.minimum;
		}
		
		public function set labelPrecision(decimals:int):void {
			_precision = decimals;
		}
		
		public function get labelPrecision():int {
			return _precision;
		}
		
		public function set label(str:String):void {
			_labelText = str;
			//invalidate();
			draw();
		}
		
		public function get label():String {
			return _labelText;
		}
		
		public function set tick(t:Number):void {
			_tick = t;
			_slider.tick = _tick;
		}
		
		public function get tick():Number {
			return _tick;
		}
		
		
		protected override function addChildren():void {
			_label = new Label(this, 0, 0);
			_slider = new _sliderClass(this, 0, 0, onSliderChange);
			_valueLabel = new Label(this);
		}
		
		protected function formatValueLabel():void {
			if (isNaN(_slider.value)) {
				_valueLabel.text = "NaN";
				return;
			}
			var mult:Number = Math.pow(10, _precision);
			var val:String = (Math.round(_slider.value * mult) / mult).toString();
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
			positionLabel();
		}
		
		protected function positionLabel():void {
		
		}
		
		protected function onSliderChange(event:Event):void {
			formatValueLabel();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}