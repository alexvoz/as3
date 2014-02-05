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
	public class Firework extends Sprite {
		private var _particleClass:Class = Particle;
		private var _countMax:int = 50;
		private var _baseAngle:Number = -90;
		private var _ampAngle:Number = 180;
		private var _speedMin:Number = 1;
		private var _speedMax:Number = 10;
		private var _speedRotMin:Number = -10;
		private var _speedRotMax:Number = 10;
		private var _scaleMin:Number = 0.1;
		private var _scaleMax:Number = 1.0;
		private var _durationMin:Number = 0.05;
		private var _durationMax:Number = 0.1;
		private var _lengthFlight:Number = 600;
		private var _xPos:Number = 0;
		private var _yPos:Number = 0;
		private var _timer:int;
		
		public function Firework() {
			if (stage) addedHandler(null)
				else addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(e:Event):void {
			if (e) removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		public function run():void {
			addEventListener(Event.ENTER_FRAME, moveParticle);
			startGenerate();
		}
		
		private function startGenerate():void {
			if (this.numChildren < _countMax) newParticle();
			var _duration:Number = _durationMin + Math.random() * (_durationMax - _durationMin);
			_timer = setTimeout(startGenerate, _duration * 1000);
		}
		
		public function stay():void {
			clearTimeout(_timer);
		}
		
		private function newParticle():void {
			var _particle:DisplayObject = new _particleClass();
			if (_particle is MovieClip) 
				try { if (_particle['totalFrames'] > 1) _particle['gotoAndStop'](Math.round(Math.random() * _particle['totalFrames']));
				} catch (e:Error) { trace(e.message) };
			var _mc:MovieClip = new MovieClip();
			_mc.addChild(_particle);
			_mc.angle = _baseAngle - _ampAngle/2 + Math.round(Math.random() * _ampAngle);
			_mc.rotation = Math.round(Math.random() * 360);
			_mc.scaleX = _mc.scaleY = _scaleMin + Math.random() * (_scaleMax - _scaleMin);
			_mc.speed = _speedMin + (_mc.scaleX / _scaleMax) * (_speedMax - _speedMin);
			_mc.speedRot = _speedRotMin + Math.round(Math.random() * (_speedRotMax - _speedRotMin));
			//_mc.addEventListener(Event.ENTER_FRAME, moveParticle);
			_mc.x = _xPos;
			_mc.y = _yPos;
			addChild(_mc);
		}
		
		private function moveParticle(e:Event):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var _mc:MovieClip = this.getChildAt(i) as MovieClip;
				var _rad:Number = (_mc.angle * Math.PI) / 180;
				var _deltaX:Number = _mc.speed * Math.cos(_rad);
				var _deltaY:Number = _mc.speed * Math.sin(_rad);
				_mc.x += _deltaX;
				_mc.y += _deltaY;
				_mc.rotation += _mc.speedRot;
				if (Math.sqrt(Math.pow(_mc.x, 2) + Math.pow(_mc.y, 2)) > _lengthFlight) {
					_mc.removeEventListener(Event.ENTER_FRAME, moveParticle);
					removeChild(_mc);
				}
			}
			if (this.numChildren == 0) removeEventListener(Event.ENTER_FRAME, moveParticle);
		}
		
		public function get particleClass():Class {
			return _particleClass;
		}
		
		public function set particleClass(value:Class):void {
			_particleClass = value;
		}
		
		public function get countMax():int {
			return _countMax;
		}
		
		public function set countMax(value:int):void {
			_countMax = value;
		}
		
		public function get baseAngle():Number {
			return _baseAngle;
		}
		
		public function set baseAngle(value:Number):void {
			_baseAngle = value;
		}
		
		public function get ampAngle():Number {
			return _ampAngle;
		}
		
		public function set ampAngle(value:Number):void {
			_ampAngle = value;
		}
		
		public function get speedMin():Number {
			return _speedMin;
		}
		
		public function set speedMin(value:Number):void {
			_speedMin = value;
		}
		
		public function get speedMax():Number {
			return _speedMax;
		}
		
		public function set speedMax(value:Number):void {
			_speedMax = value;
		}
		
		public function get speedRotMin():Number {
			return _speedRotMin;
		}
		
		public function set speedRotMin(value:Number):void {
			_speedRotMin = value;
		}
		
		public function get speedRotMax():Number {
			return _speedRotMax;
		}
		
		public function set speedRotMax(value:Number):void {
			_speedRotMax = value;
		}
		
		public function get scaleMin():Number {
			return _scaleMin;
		}
		
		public function set scaleMin(value:Number):void {
			_scaleMin = value;
		}
		
		public function get scaleMax():Number {
			return _scaleMax;
		}
		
		public function set scaleMax(value:Number):void {
			_scaleMax = value;
		}
		
		public function get durationMin():Number {
			return _durationMin;
		}
		
		public function set durationMin(value:Number):void {
			_durationMin = value;
		}
		
		public function get durationMax():Number {
			return _durationMax;
		}
		
		public function set durationMax(value:Number):void {
			_durationMax = value;
		}
		
		public function get lengthFlight():Number {
			return _lengthFlight;
		}
		
		public function set lengthFlight(value:Number):void {
			_lengthFlight = value;
		}
		
		public function get xPos():Number {
			return _xPos;
		}
		
		public function set xPos(value:Number):void {
			_xPos = value;
		}
		
		public function get yPos():Number {
			return _yPos;
		}
		
		public function set yPos(value:Number):void {
			_yPos = value;
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