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
		public var minSize:Number = 1;
		public var maxSize:Number = 3;
		public var minSpeed:Number = .3;
		public var maxSpeed:Number = 1;
		public var minAlpha:Number = .2;
		public var maxAlpha:Number = 1;
		public var ampAngle:Number = 30;
		public var count:Number = 1000;
		public var particle:DisplayObject;
		public var widthCont:Number;
		public var heightCont:Number;
		public var chanceChange:Number = .05;
		public var particleClass:Class = Particle;
		
		public function Dust(width:Number = 200, height:Number = 200) {
			widthCont = width;
			heightCont = height;
		}
		
		public function run():void {
			for (var i:int = 0; i < count; i++) {
				var _particle:DisplayObject = new particleClass();
				if (particleClass is MovieClip) {
					try { if (_particle['totalFrames'] > 1) _particle['gotoAndStop'](Math.round(Math.random() * _particle['totalFrames']));
					} catch (e:Error) { trace(e.message) };
				}
				var _mc:MovieClip = new MovieClip();
				_mc.addChild(_particle);
				_mc.alpha = randomValue(minAlpha, maxAlpha);
				_mc.width = _mc.height = randomValue(minSize, maxSize);
				_mc.x = randomValue(0, widthCont);
				_mc.y = randomValue(0, heightCont);
				_mc.direction = randomValue(0, 360);
				_mc.speed = randomValue(minSpeed, maxSpeed);
				addChild(_mc);
			}
			addEventListener(Event.ENTER_FRAME, moveParticles);
		}
		
		private function moveParticles(e:Event):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var _mc:MovieClip = this.getChildAt(i) as MovieClip;
				var _rad:Number = (_mc.direction * Math.PI) / 180;
				var _deltaX:Number = _mc.speed * Math.cos(_rad);
				var _deltaY:Number = _mc.speed * Math.sin(_rad);
				_mc.x += _deltaX;
				_mc.y += _deltaY;
				if (_mc.x < 0 || _mc.x > widthCont || _mc.y < 0 || _mc.y > heightCont) _mc.direction = (_mc.direction + 90) % 360;
				if (Math.random() < chanceChange) {
					_mc.direction += randomValue(-ampAngle, ampAngle);
					_mc.speed = randomValue(minSpeed, maxSpeed);
					_mc.alpha = randomValue(minAlpha, maxAlpha);
				}
			}
		}
		
		private function randomValue(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
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
