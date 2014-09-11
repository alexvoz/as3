package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	
	public class HUISlider extends UISlider {
		
		public function HUISlider(label:String = "") {
			_sliderClass = HSlider;
			super(label);
		}
		
		public override function draw():void {
			super.draw();
			_slider.x = _label.width + 5;
			_slider.y = height / 2 - _slider.height / 2;
			_slider.width = width - _label.width - 50 - 10;
			
			_valueLabel.x = _slider.x + _slider.width + 5;
		}
		
		
		protected override function init():void {
			super.init();
			setSize(200, 18);
		}
		
		protected override function positionLabel():void {
			_valueLabel.x = _slider.x + _slider.width + 5;
		}
		
	}
}