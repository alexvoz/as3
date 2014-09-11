package ua.olexandr.ui.charts {
	import flash.display.DisplayObjectContainer;
	
	public class LineChart extends Chart {
		protected var _lineWidth:Number = 1;
		protected var _lineColor:uint = 0x999999;
		
		public function LineChart(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Array = null) {
			super(parent, xpos, ypos, data);
		}
		
		public function set lineWidth(value:Number):void {
			_lineWidth = value;
			invalidate();
		}
		
		public function get lineWidth():Number {
			return _lineWidth;
		}
		
		public function set lineColor(value:uint):void {
			_lineColor = value;
			invalidate();
		}
		
		public function get lineColor():uint {
			return _lineColor;
		}
		
		
		protected override function drawChart():void {
			var border:Number = 2;
			var lineWidth:Number = (_width - border) / (_data.length - 1);
			var chartHeight:Number = _height - border;
			_chartHolder.x = 0;
			_chartHolder.y = _height;
			var xpos:Number = border;
			var max:Number = getMaxValue();
			var min:Number = getMinValue();
			var scale:Number = chartHeight / (max - min);
			_chartHolder.graphics.lineStyle(_lineWidth, _lineColor);
			_chartHolder.graphics.moveTo(xpos, (_data[0] - min) * -scale);
			xpos += lineWidth;
			for (var i:int = 1; i < _data.length; i++) {
				if (_data[i] != null) {
					_chartHolder.graphics.lineTo(xpos, (_data[i] - min) * -scale);
				}
				xpos += lineWidth;
			}
		}
		
	}
}