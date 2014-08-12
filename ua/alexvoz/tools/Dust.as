package ua.alexvoz.tools {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
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
	public class Dust extends Sprite {
		private var _minSize:Number = 1;
		private var _maxSize:Number = 3;
		private var _minSpeed:Number = .3;
		private var _maxSpeed:Number = 1;
		private var _minAlpha:Number = .2;
		private var _maxAlpha:Number = 1;
		private var _ampAngle:Number = 30;
		private var _count:Number = 1000;
		private var _particle:DisplayObject;
		private var _width:Number;
		private var _height:Number;
		private var _chanceChange:Number = .05;
		private var _particleClass:Class = Particle;
		
		public function Dust(width:Number = 200, height:Number = 200) {
			_width = width;
			_height = height;
		}
		
		public function run():void {
			for (var i:int = 0; i < _count; i++) {
				var _particle:DisplayObject = new _particleClass();
				if (_particleClass is MovieClip) {
					try { if (_particle['totalFrames'] > 1) _particle['gotoAndStop'](Math.round(Math.random() * _particle['totalFrames']));
					} catch (e:Error) { trace(e.message) };
				}
				var _mc:MovieClip = new MovieClip();
				_mc.addChild(_particle);
				_mc.alpha = randomValue(_minAlpha, _maxAlpha);
				_mc.width = _mc.height = randomValue(_minSize, _maxSize);
				_mc.x = Math.round(randomValue(0, _width));
				_mc.y = Math.round(randomValue(0, _height));
				_mc.direction = randomValue(0, 360);
				_mc.speed = randomValue(_minSpeed, _maxSpeed);
				addChild(_mc);
			}
			addEventListener(Event.ENTER_FRAME, exitFrame);
		}
		
		private function exitFrame(e:Event):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var _mc:MovieClip = this.getChildAt(i) as MovieClip;
				var _rad:Number = (_mc.direction * Math.PI) / 180;
				var _deltaX:Number = _mc.speed * Math.cos(_rad);
				var _deltaY:Number = _mc.speed * Math.sin(_rad);
				_mc.x += _deltaX;
				_mc.y += _deltaY;
				if (_mc.x < 0 || _mc.x > _width || _mc.y < 0 || _mc.y > _height) _mc.direction = (_mc.direction + 90) % 360;
				if (Math.random() < _chanceChange) {
					_mc.direction += randomValue(-_ampAngle, _ampAngle);
					_mc.speed = randomValue(_minSpeed, _maxSpeed);
					_mc.alpha = randomValue(_minAlpha, _maxAlpha);
				}
			}
		}
		
		private function randomValue(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
		}
		
		public function get chanceChange():Number {
			return _chanceChange;
		}
		
		public function set chanceChange(value:Number):void {
			_chanceChange = value;
		}
		
		public function get minSize():Number {
			return _minSize;
		}
		
		public function set minSize(value:Number):void {
			_minSize = value;
		}
		
		public function get maxSize():Number {
			return _maxSize;
		}
		
		public function set maxSize(value:Number):void {
			_maxSize = value;
		}
		
		public function get minSpeed():Number {
			return _minSpeed;
		}
		
		public function set minSpeed(value:Number):void {
			_minSpeed = value;
		}
		
		public function get maxSpeed():Number {
			return _maxSpeed;
		}
		
		public function set maxSpeed(value:Number):void {
			_maxSpeed = value;
		}
		
		public function get minAlpha():Number {
			return _minAlpha;
		}
		
		public function set minAlpha(value:Number):void {
			_minAlpha = value;
		}
		
		public function get maxAlpha():Number {
			return _maxAlpha;
		}
		
		public function set maxAlpha(value:Number):void {
			_maxAlpha = value;
		}
		
		public function get count():Number {
			return _count;
		}
		
		public function set count(value:Number):void {
			_count = value;
		}
		
		public override function get width():Number {
			return _width;
		}
		
		public override function set width(value:Number):void {
			_width = value;
		}
		
		public override function get height():Number {
			return _height;
		}
		
		public override function set height(value:Number):void {
			_height = value;
		}
		
		public function get particleClass():Class {
			return _particleClass;
		}
		
		public function set particleClass(value:Class):void {
			_particleClass = value;
		}
	}

}

import flash.display.Sprite;

internal class Particle extends Sprite {
	
	static private const RADIUS:Number = 2;
	
	public function Particle() {
		var _mc:Sprite = new Sprite();
		_mc.graphics.beginFill(0x999999);
		_mc.graphics.drawCircle(RADIUS / 2, RADIUS / 2, RADIUS);
		_mc.graphics.endFill();
		addChild(_mc);
	}
}
