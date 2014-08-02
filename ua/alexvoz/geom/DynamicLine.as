package ua.alexvoz.geom  {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class DynamicLine extends Sprite {
		private var _total:int;
		private var _i:int;
		private var _x1:Number;
		private var _x2:Number;
		private var _y1:Number;
		private var _y2:Number;
		private var _color:uint;
		private var _stroke:Number;
		private var _shape:Shape;
		
		public function DynamicLine(x1:Number, y1:Number, x2:Number, y2:Number, num:int = 20, color:uint = 0xFF0000, stroke:Number = 1) {
			_total = num;
			_i = 1;
			_x1 = x1;
			_x2 = x2;
			_y1 = y1;
			_y2 = y2;
			_color = color
			_stroke = stroke
		}
		
		public function drawLine():void {
			_shape = new Shape();
			_shape.graphics.lineStyle(_stroke, _color);
			_shape.graphics.moveTo(_x1, _y1);
			addChild(_shape);
			addEventListener(Event.ENTER_FRAME, lineHandler);
		}
		
		private function lineHandler(e:Event):void {
			var _x:Number = _x1 + (_x2 - _x1) / _total * _i;
			var _y:Number = _y1 + (_y2 - _y1) / _total * _i;
			_shape.graphics.lineTo(_x, _y);
			_shape.graphics.moveTo(_x, _y);
			if (_i == _total) removeEventListener(Event.ENTER_FRAME, lineHandler);
				else _i++;
		}
		
	}

}