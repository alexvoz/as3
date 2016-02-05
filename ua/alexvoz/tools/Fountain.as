package ua.alexvoz.tools {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class Fountain extends Sprite {
		public var particleClass:Class = Particle;
		public var countMax:int = 150;
		public var baseAngle:Number = -90;
		public var ampAngle:Number = 40;
		public var speedMin:Number = 40;
		public var speedMax:Number = 25;
		public var speedRotMin:Number = -10;
		public var speedRotMax:Number = 10;
		public var scaleMin:Number = 0.1;
		public var scaleMax:Number = 1.0;
		public var durationMin:Number = 0.01;
		public var durationMax:Number = 0.03;
		public var lengthFlight:Number = 600;
		public var xPos:Number = 0;
		public var yPos:Number = 0;
		public var gravityMax:Number = 4;
		public var gravityMin:Number = 2;
		public var playFrames:Boolean = true;
		
		private var _timer:int;
		
		public function Fountain() {
			//initialize some vars?
		}
		
		public function run():void {
			addEventListener(Event.ENTER_FRAME, moveParticle);
			startGenerate();
		}
		
		private function startGenerate():void {
			if (this.numChildren < countMax) newParticle();
			var _duration:Number = durationMin + Math.random() * (durationMax - durationMin);
			_timer = setTimeout(startGenerate, _duration * 1000);
		}
		
		public function stay():void {
			clearTimeout(_timer);
		}
		
		private function newParticle():void {
			var _particle:DisplayObject = new particleClass();
			if (_particle is MovieClip)
				try { if (_particle['totalFrames'] > 1) _particle[playFrames ? 'gotoAndPlay' : 'gotoAndStop'](Math.round(Math.random() * _particle['totalFrames']));
				} catch (e:Error) { trace(e.message) };
			var _mc:ParticleCont = new ParticleCont();
			_mc.addChild(_particle);
			_mc.angle = baseAngle - ampAngle/2 + Math.round(Math.random() * ampAngle);
			_mc.rotation = Math.round(Math.random() * 360);
			_mc.scaleX = _mc.scaleY = scaleMin + Math.random() * (scaleMax - scaleMin);
			_mc.speed = speedMin + (_mc.scaleX / scaleMax) * (speedMax - speedMin);
			var _rad:Number = (_mc.angle * Math.PI) / 180;
			_mc.speedX = _mc.speed * Math.cos(_rad);
			_mc.speedY = _mc.speed * Math.sin(_rad);
			_mc.speedRot = speedRotMin + Math.round(Math.random() * (speedRotMax - speedRotMin));
			_mc.gravity = gravityMin + Math.round(Math.random() * (gravityMax - gravityMin));
			_mc.x = xPos;
			_mc.y = yPos;
			addChild(_mc);
		}
		
		private function moveParticle(e:Event):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var _mc:ParticleCont = this.getChildAt(i) as ParticleCont;
				_mc.x += _mc.speedX;
				_mc.y += _mc.speedY;
				_mc.rotation += _mc.speedRot;
				_mc.speedY += _mc.gravity;
				if (Math.sqrt(Math.pow(_mc.x, 2) + Math.pow(_mc.y, 2)) > lengthFlight) {
					removeChild(_mc);
					_mc = null;
				}
			}
			if (this.numChildren == 0) removeEventListener(Event.ENTER_FRAME, moveParticle);
		}
		
	}

}

import flash.display.Sprite;

internal class Particle extends Sprite {
	
	static private const HEIGHT:Number = 100;
	static private const WIDTH:Number = 40;
	
	public function Particle() {
		var _mc:Sprite = new Sprite();
		var _color:uint = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFFFFFF][Math.round(Math.random() * 5)];
		_mc.graphics.beginFill(_color);
		_mc.graphics.drawRect( -WIDTH / 2, -HEIGHT / 2, WIDTH, HEIGHT);
		_mc.graphics.endFill();
		addChild(_mc);
	}
}

internal class ParticleCont extends Sprite {
	public var angle:Number;
	public var speed:Number;
	public var speedX:Number;
	public var speedY:Number;
	public var gravity:Number;
	public var speedRot:Number;
}
