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
		public var widthCont:Number;
		public var heightCont:Number;
		public var chanceChange:Number = .05;
		public var particleClass:Class = Particle;
		private var _vecParticles:Vector.<ParticleCont> = new Vector.<ParticleCont>();
		
		public function Dust(width:Number = 200, height:Number = 200) {
			widthCont = width;
			heightCont = height;
		}
		
		public function run():void {
			for (var i:int = 0; i < count; i++) {
				var _particle:DisplayObject = new particleClass();
				var _particleMC:MovieClip = _particle as MovieClip;
				if (_particleMC && _particleMC.totalFrames > 1)
					_particleMC.gotoAndStop(Math.round(Math.random() * _particleMC.totalFrames));
				//if (particleClass is MovieClip) {
					//try { if (_particle['totalFrames'] > 1) _particle['gotoAndStop'](Math.round(Math.random() * _particle['totalFrames']));
					//} catch (e:Error) { trace(e.message) };
				//}				
				var _mc:ParticleCont = new ParticleCont();
				_mc.addChild(_particle);
				_mc.alpha = randomValue(minAlpha, maxAlpha);
				_mc.width = _mc.height = randomValue(minSize, maxSize);
				_mc.x = randomValue(0, widthCont);
				_mc.y = randomValue(0, heightCont);
				_mc.angle = randomValue(0, 360);
				_mc.speed = randomValue(minSpeed, maxSpeed);
				_vecParticles.push(_mc);
				addChild(_mc);
			}
			addEventListener(Event.ENTER_FRAME, moveParticles);
		}
		
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, moveParticles);
			for (var i:int = 0; i < _vecParticles.length; i++) {
				removeChild(_vecParticles[i]);
			}
			_vecParticles = new Vector.<ParticleCont>();
		}
		
		private function moveParticles(e:Event):void {
			for (var i:int = 0; i < numChildren; i++) {
				var _rad:Number = (_vecParticles[i].angle * Math.PI) / 180;
				var _deltaX:Number = _vecParticles[i].speed * Math.cos(_rad);
				var _deltaY:Number = _vecParticles[i].speed * Math.sin(_rad);
				_vecParticles[i].x += _deltaX;
				_vecParticles[i].y += _deltaY;
				if (_vecParticles[i].x < 0 || _vecParticles[i].x > widthCont || _vecParticles[i].y < 0 || _vecParticles[i].y > heightCont) 
					_vecParticles[i].angle = (_vecParticles[i].angle + 90) % 360;
				if (Math.random() < chanceChange) {
					_vecParticles[i].angle += randomValue(-ampAngle, ampAngle);
					_vecParticles[i].speed = randomValue(minSpeed, maxSpeed);
					_vecParticles[i].alpha = randomValue(minAlpha, maxAlpha);
				}
			}
		}
		
		private function randomValue(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
		}
		
	}

}

import flash.display.Shape;

internal class Particle extends Shape {
	
	static private const RADIUS:Number = 1;
	
	public function Particle() {
		graphics.beginFill(0x999999);
		graphics.drawCircle(RADIUS, RADIUS, RADIUS * 2);
		graphics.endFill();
	}
	
}

import flash.display.Sprite;

internal class ParticleCont extends Sprite {
	
	public var angle:Number;
	public var speed:Number;
	
}
