package ua.olexandr.ui.charts {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import ua.olexandr.ui.components.Component;
	import ua.olexandr.ui.components.Label;
	import ua.olexandr.ui.components.Panel;
	
	public class Chart extends Component {
		protected var _data:Array;
		protected var _chartHolder:Shape;
		protected var _maximum:Number = 100;
		protected var _minimum:Number = 0;
		protected var _autoScale:Boolean = true;
		protected var _maxLabel:Label;
		protected var _minLabel:Label;
		protected var _showScaleLabels:Boolean = false;
		protected var _labelPrecision:int = 0;
		protected var _panel:Panel;
		
		public function Chart(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Array = null) {
			_data = data;
			super(parent, xpos, ypos);
		}
		
		public override function draw():void {
			super.draw();
			_panel.setSize(width, height);
			_panel.draw();
			_chartHolder.graphics.clear();
			if (_data != null) {
				drawChart();
				
				var mult:Number = Math.pow(10, _labelPrecision);
				var maxVal:Number = Math.round(maximum * mult) / mult;
				_maxLabel.text = maxVal.toString();
				_maxLabel.draw();
				_maxLabel.x = -_maxLabel.width - 5;
				_maxLabel.y = -_maxLabel.height * 0.5;
				
				var minVal:Number = Math.round(minimum * mult) / mult;
				_minLabel.text = minVal.toString();
				_minLabel.draw();
				_minLabel.x = -_minLabel.width - 5;
				_minLabel.y = height - _minLabel.height * 0.5;
			}
		}
		
		public function set data(value:Array):void {
			_data = value;
			invalidate();
		}
		
		public function get data():Array {
			return _data;
		}
		
		public function set maximum(value:Number):void {
			_maximum = value;
			invalidate();
		}
		
		public function get maximum():Number {
			if (_autoScale)
				return getMaxValue();
			return _maximum;
		}
		
		public function set minimum(value:Number):void {
			_minimum = value;
			invalidate();
		}
		
		public function get minimum():Number {
			if (_autoScale)
				return getMinValue();
			return _minimum;
		}
		
		public function set autoScale(value:Boolean):void {
			_autoScale = value;
			invalidate();
		}
		
		public function get autoScale():Boolean {
			return _autoScale;
		}
		
		public function set showScaleLabels(value:Boolean):void {
			_showScaleLabels = value;
			if (_showScaleLabels) {
				addChild(_maxLabel);
				addChild(_minLabel);
			} else {
				if (contains(_maxLabel))
					removeChild(_maxLabel);
				if (contains(_minLabel))
					removeChild(_minLabel);
			}
		}
		
		public function get showScaleLabels():Boolean {
			return _showScaleLabels;
		}
		
		public function set labelPrecision(value:int):void {
			_labelPrecision = value;
			invalidate();
		}
		
		public function get labelPrecision():int {
			return _labelPrecision;
		}
		
		public function set gridSize(value:int):void {
			_panel.gridSize = value;
			invalidate();
		}
		
		public function get gridSize():int {
			return _panel.gridSize;
		}
		
		public function set showGrid(value:Boolean):void {
			_panel.showGrid = value;
			invalidate();
		}
		
		public function get showGrid():Boolean {
			return _panel.showGrid;
		}
		
		public function set gridColor(value:uint):void {
			_panel.gridColor = value;
			invalidate();
		}
		
		public function get gridColor():uint {
			return _panel.gridColor;
		}
		
		
		protected override function init():void {
			super.init();
			setSize(200, 100);
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_panel = new Panel(this);
			
			_chartHolder = new Shape();
			_panel.content.addChild(_chartHolder);
			
			_maxLabel = new Label();
			_minLabel = new Label();
		}
		
		protected function drawChart():void {
		}
		
		protected function getMaxValue():Number {
			if (!_autoScale)
				return _maximum;
			var maxValue:Number = Number.NEGATIVE_INFINITY;
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i] != null) {
					maxValue = Math.max(_data[i], maxValue);
				}
			}
			return maxValue;
		}
		
		protected function getMinValue():Number {
			if (!_autoScale)
				return _minimum;
			var minValue:Number = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i] != null) {
					minValue = Math.min(_data[i], minValue);
				}
			}
			return minValue;
		}
		
	}
}