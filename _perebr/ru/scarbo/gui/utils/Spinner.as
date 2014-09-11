package ru.scarbo.gui.utils 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ru.scarbo.gui.core.BasicContainer;
	import ru.scarbo.gui.core.BasicSprite;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class Spinner extends BasicContainer 
	{
		private var _numTicks:uint;
		private var _widthTick:Number;
		private var _colorTick:uint;
		private var _size:Number;
		private var _innerSize:Number;
		
		private var _timer:Timer;
		private var _speed:uint;
		private var _count:uint;
		
		public function Spinner() 
		{
			super();
			//
			this.widthTick = 3;
			this.numTicks = 30;
			this.size = 60;
			this.innerSize = 12;
			this.colorTick = 0x66AAFF;
			this._speed = 60;
		}
		
		public function set numTicks(value:uint):void 
		{
			if (this._numTicks != value) {
				this._numTicks = value;
				this.changed = true;
			}
		}
		public function set widthTick(value:Number):void 
		{
			if (this._widthTick != value) {
				this._widthTick = value;
				this.changed = true;
			}
		}
		public function set colorTick(value:uint):void 
		{
			if (this._colorTick != value) {
				this._colorTick = value;
				this.changed = true;
			}
		}
		public function set size(value:Number):void 
		{
			if (this._size != value) {
				this._size = value;
				this._width = this._height = this._size;
				this.changed = true;
			}
		}
		public function set innerSize(value:Number):void {
			if (this._innerSize != value) {
				this._innerSize = value;
				this.changed = true;
			}
		}
		
		public function start():void {
			this._count = (this._numTicks > 0) ? this._numTicks : 0;
			if (!this._timer) {
				this._timer = new Timer(this._speed);
				this._timer.addEventListener(TimerEvent.TIMER, this._updateHandler);
				this._timer.start();
				this._updateHandler();
			}
			this.visible = true;
		}
		public function stop():void {
			if (this._timer) {
				this._timer.stop();
				this._timer.removeEventListener(TimerEvent.TIMER, this._updateHandler);
				this._timer = null;
			}
			this.visible = false;
		}
		
		private function _updateHandler(e:TimerEvent = null):void {
			this._count++;
			for (var i:uint = 0; i < this.numChildren; i++) {
				var tick:RoundedTick = this.getChildAt(i) as RoundedTick;
				var _alpha:Number = (this._count - i) % this._numTicks;
				tick.alpha = 1 - 0.045 * _alpha;
			}
			if (e) this.dispatchEvent(e.clone());
		}
		
		override protected function _draw():void {
			var radius:Number = this._size / 2;
			var angle:Number = 2 * Math.PI / this._numTicks;
			var widthTick:Number = (this._widthTick != -1) ? this._widthTick : this._size / 10;
			var currentAngle:Number = 0;
			this.removeAllChildren();
			//
			for (var i:uint = 0; i < this._numTicks; i++) {
				var xStart:Number = radius + Math.sin(currentAngle) * ((this._numTicks + this._innerSize) * widthTick / 2 / Math.PI);
				var yStart:Number = radius - Math.cos(currentAngle) * ((this._numTicks + this._innerSize) * widthTick / 2 / Math.PI);
				var xEnd:Number = radius + Math.sin(currentAngle) * (radius - widthTick);
				var yEnd:Number = radius - Math.cos(currentAngle) * (radius - widthTick);
				
				var tick:RoundedTick = new RoundedTick(xStart, yStart, xEnd, yEnd, widthTick, this._colorTick);
				tick.alpha = .3 + .7 * i / this._numTicks;
				this.addChild(tick);
				currentAngle += angle;
			}
			//
			super._draw();
		}
	}

}

import flash.display.Graphics;
import flash.display.Shape;
class RoundedTick extends Shape
{
	public function RoundedTick(fromX:Number, fromY:Number, toX:Number, toY:Number, tickWidth:int, tickColor:uint)
	{
		var g:Graphics = this.graphics;
		g.lineStyle(tickWidth, tickColor, 1, false, 'normal', 'rounded');
		g.moveTo(fromX, fromY);
		g.lineTo(toX, toY);
	}
}