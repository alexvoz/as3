package ua.olexandr.ui.charts {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import ua.olexandr.ui.components.Label;
	
	public class PieChart extends Chart {
		protected var _sprite:Sprite;
		protected var _beginningAngle:Number = 0;
		protected var _colors:Array = [0xff9999, 0xffff99, 0x99ff99, 0x99ffff, 0x9999ff, 0xff99ff, 0xffcccc, 0xffffcc, 0xccffcc, 0xccffff, 0xccccff, 0xffccff, 0xff6666, 0xffff66, 0x99ff66, 0x66ffff, 0x6666ff, 0xff66ff, 0xffffff];
		
		public function PieChart(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Array = null) {
			super(parent, xpos, ypos, data);
		}
		
		public function set colors(value:Array):void {
			_colors = value;
			invalidate();
		}
		
		public function get colors():Array {
			return _colors;
		}
		
		public function set beginningAngle(value:Number):void {
			_beginningAngle = value;
			invalidate();
		}
		
		public function get beginningAngle():Number {
			return _beginningAngle;
		}
	
		
		protected override function init():void {
			super.init();
			setSize(160, 120);
		}
		
		protected override function addChildren():void {
			super.addChildren();
			_sprite = new Sprite();
			_panel.content.addChild(_sprite);
		}
		
		protected override function drawChart():void {
			var radius:Number = Math.min(width - 40, height - 40) / 2;
			_sprite.x = width / 2;
			_sprite.y = height / 2;
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(0, 0x666666, 1);
			while (_sprite.numChildren > 0)
				_sprite.removeChildAt(0);
			
			var total:Number = getDataTotal();
			var startAngle:Number = _beginningAngle * Math.PI / 180;
			for (var i:int = 0; i < _data.length; i++) {
				var percent:Number = getValueForData(i) / total;
				var endAngle:Number = startAngle + Math.PI * 2 * percent;
				drawArc(startAngle, endAngle, radius, getColorForData(i));
				makeLabel((startAngle + endAngle) * 0.5, radius + 10, getLabelForData(i));
				startAngle = endAngle;
			}
		}
		
		protected function makeLabel(angle:Number, radius:Number, text:String):void {
			var label:Label = new Label(_sprite, 0, 0, text);
			label.x = Math.cos(angle) * radius;
			label.y = Math.sin(angle) * radius - label.height / 2;
			if (label.x < 0) {
				label.x -= label.width;
			}
		}
		
		protected function drawArc(startAngle:Number, endAngle:Number, radius:Number, color:uint):void {
			_sprite.graphics.beginFill(color);
			_sprite.graphics.moveTo(0, 0);
			for (var i:Number = startAngle; i < endAngle; i += .01) {
				_sprite.graphics.lineTo(Math.cos(i) * radius, Math.sin(i) * radius);
			}
			_sprite.graphics.lineTo(Math.cos(endAngle) * radius, Math.sin(endAngle) * radius);
			_sprite.graphics.lineTo(0, 0);
			_sprite.graphics.endFill();
		}
		
		protected function getLabelForData(index:int):String {
			if (!(_data[index] is Number) && _data[index].label != null) {
				return _data[index].label;
			}
			var value:Number = Math.round(getValueForData(index) * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision);
			return value.toString();
		}
		
		protected function getColorForData(index:int):uint {
			if ((!_data[index] is Number) && _data[index].color != null) {
				return _data[index].color;
			}
			if (index < _colors.length) {
				return _colors[index];
			}
			return Math.random() * 0xffffff;
		}
		
		protected function getValueForData(index:int):Number {
			if (_data[index] is Number) {
				return _data[index];
			}
			if (_data[index].value != null) {
				return _data[index].value;
			}
			return NaN;
		}
		
		protected function getDataTotal():Number {
			var total:Number = 0;
			for (var i:int = 0; i < _data.length; i++) {
				total += getValueForData(i);
			}
			return total;
		}
		
	}
}