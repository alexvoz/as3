package ua.olexandr.ui.components.forRemove {
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	public class IndicatorLight extends Component {
		protected var _color:uint;
		protected var _lit:Boolean = false;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _lite:Shape;
		protected var _timer:Timer;
		
		public function IndicatorLight(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, color:uint = 0xff0000, label:String = "") {
			_color = color;
			_labelText = label;
			super(parent, xpos, ypos);
		}
		
		public override function draw():void {
			super.draw();
			drawLite();
			
			_label.text = _labelText;
			_label.x = 12;
			_label.y = (10 - _label.height) / 2;
			_width = _label.width + 12;
			_height = 10;
		}
		
		public function flash(interval:int = 500):void {
			if (interval < 1) {
				_timer.stop();
				isLit = false;
				return;
			}
			_timer.delay = interval;
			_timer.start();
		}
		
		public function set isLit(value:Boolean):void {
			_timer.stop();
			_lit = value;
			drawLite();
		}
		
		public function get isLit():Boolean {
			return _lit;
		}
		
		public function set color(value:uint):void {
			_color = value;
			draw();
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function get isFlashing():Boolean {
			return _timer.running;
		}
		
		public function set label(str:String):void {
			_labelText = str;
			draw();
		}
		
		public function get label():String {
			return _labelText;
		}
	
		
		protected override function init():void {
			super.init();
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		protected override function addChildren():void {
			_lite = new Shape();
			addChild(_lite);
			
			_label = new Label(this, 0, 0, _labelText);
			draw();
		}
		
		protected function drawLite():void {
			var colors:Array;
			if (_lit) {
				colors = [0xffffff, _color];
			} else {
				colors = [0xffffff, 0];
			}
			
			_lite.graphics.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(10, 10, 0, -2.5, -2.5);
			_lite.graphics.beginGradientFill(GradientType.RADIAL, colors, [1, 1], [0, 255], matrix);
			_lite.graphics.drawCircle(5, 5, 5);
			_lite.graphics.endFill();
		}
		
		protected function onTimer(event:TimerEvent):void {
			_lit = !_lit;
			draw();
		}
		
	}
}