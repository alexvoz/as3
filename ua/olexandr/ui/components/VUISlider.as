package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	
	public class VUISlider extends UISlider {
		
		public function VUISlider(label:String = "") {
			_sliderClass = VSlider;
			super(label);
		}
		
		public override function draw():void {
			super.draw();
			_label.x = width / 2 - _label.width / 2;
			
			_slider.x = width / 2 - _slider.width / 2;
			_slider.y = _label.height + 5;
			_slider.height = height - _label.height - _valueLabel.height - 10;
			
			_valueLabel.x = width / 2 - _valueLabel.width / 2;
			_valueLabel.y = _slider.y + _slider.height + 5;
		}
		
		public override function get width():Number {
			if (_label == null)
				return _width;
			return Math.max(_width, _label.width);
		}
		
		
		protected override function init():void {
			super.init();
			setSize(20, 146);
		}
		
		protected override function positionLabel():void {
			_valueLabel.x = width / 2 - _valueLabel.width / 2;
		}
		
	}
}