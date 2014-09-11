package ua.olexandr.ui.charts {
	import flash.display.DisplayObjectContainer;
	
	public class BarChart extends Chart {
		protected var _spacing:Number = 2;
		protected var _barColor:uint = 0x999999;
		
		public function BarChart(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Array = null) {
			super(parent, xpos, ypos, data);
		}
		
		public function set spacing(value:Number):void {
			_spacing = value;
			invalidate();
		}
		
		public function get spacing():Number {
			return _spacing;
		}
		
		public function set barColor(value:uint):void {
			_barColor = value;
			invalidate();
		}
		
		public function get barColor():uint {
			return _barColor;
		}
		
		
		protected override function drawChart():void {
			var border:Number = 2;
			var totalSpace:Number = _spacing * _data.length;
			var barWidth:Number = (_width - border - totalSpace) / _data.length;
			var chartHeight:Number = _height - border;
			_chartHolder.x = 0;
			_chartHolder.y = _height;
			var xpos:Number = border;
			var max:Number = getMaxValue();
			var min:Number = getMinValue();
			var scale:Number = chartHeight / (max - min);
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i] != null) {
					_chartHolder.graphics.beginFill(_barColor);
					_chartHolder.graphics.drawRect(xpos, 0, barWidth, (_data[i] - min) * -scale);
					_chartHolder.graphics.endFill();
				}
				xpos += barWidth + _spacing;
			}
		}
		
	}
}