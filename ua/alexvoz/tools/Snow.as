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
	public class Snow extends Sprite {
		public var snowClass:Class = Snowflake; //класс снежинки
		public var count:Number = 200; // количество снежинок
		public var snowWidth:Number; // высота стены снега
		public var snowHeight:Number; // ширина стены снега
		public var speedMin:Number = 1; // минимальная скорость
		public var speedMax:Number = 3; // максимальная скорость
		public var scaleMin:Number = .5; // минимальный размер в процентах
		public var scaleMax:Number = 1; // максимальный размер в процентах
		public var alphaMin:Number = .75; // минимальный уровень прозрачности
		public var alphaMax:Number = 1; // максимальный уровень прозрачности
		public var amplitudeMin:Number = 10; // максимальная амплитуда колебания
		public var amplitudeMax:Number = 20; // максимальная амплитуда колебания
		public var amplitudeTimeMin:Number = 2 // минимальный период одного колебания
		public var amplitudeTimeMax:Number = 5; // максимальный период одного колебания
		public var direction:Number = 1; // направление движения. вверх = -1, вниз = 1
		public var rotateIt:Boolean = false; // флаг вращения в плоскости
		public var rotateSpeedMin:Number = 5; // минимальная скорость вращения в плоскости
		public var rotateSpeedMax:Number = 10; // максимальная скорость вращения в плоскости
		public var rotateXIt:Boolean = false; // флаг вращения в пространсве по оси X
		public var rotateXSpeedMin:Number = 5; // минимальная скорость вращения в пространсве по оси X
		public var rotateXSpeedMax:Number = 10; // максимальная скорость вращения в пространсве по оси X
		public var rotateYIt:Boolean = false; // флаг вращения в пространсве по оси Y
		public var rotateYSpeedMin:Number = 5; // минимальная скорость вращения в пространсве по оси Y
		public var rotateYSpeedMax:Number = 10; // максимальная скорость вращения в пространсве по оси Y
		
		public function Snow(w:Number, h:Number) {
			snowWidth = w;
			snowHeight = h;
			if (stage) addedHandler(null)
				else addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(e:Event):void {
			if (e) removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		public function run():void {
			for (var i:Number = 0; i < count; i++) {
				var _particle:DisplayObject = new snowClass();
				var _particleMC:MovieClip = _particle as MovieClip;
				if (_particleMC && _particleMC.totalFrames > 1)
					_particleMC.gotoAndStop(Math.round(Math.random() * _particleMC.totalFrames));
				var _mc:ParticleCont = new ParticleCont();
				if (_particleMC) _mc.addChild(_particleMC);
					else _mc.addChild(_particle);
				_mc.x = _mc.initX = Math.round(Math.random() * snowWidth);
				_mc.y = Math.round(Math.random() * snowHeight);
				_mc.scaleX = _mc.scaleY = Math.random() * (scaleMax - scaleMin) + scaleMin;
				_mc.alpha = Math.random() * (alphaMax - alphaMin) + alphaMin;
				_mc.speedY = Math.random() * (speedMax - speedMin) + speedMin;
				_mc.amplitudeMax = amplitudeMin + Math.random() * (amplitudeMax - amplitudeMin);
				_mc.amplitudeTime = (amplitudeTimeMin + Math.random() * (amplitudeTimeMax - amplitudeTimeMin)) * 10;
				_mc.amplitudeF = Boolean(Math.round(Math.random()));
				if (rotateIt) {
					_mc.rotationZ = Math.random() * 360;
					_mc.rotationSpeed = rotateSpeedMin + Math.random() * (rotateSpeedMax - rotateSpeedMin);
				}
				if (rotateXIt) {
					_mc.rotationX = -180 + Math.random() * 180;
					_mc.rotationXSpeed = rotateXSpeedMin + Math.random() * (rotateXSpeedMax - rotateXSpeedMin);
				}
				if (rotateYIt) {
					_mc.rotationY = -180 + Math.random() * 180;
					_mc.rotationYSpeed = rotateYSpeedMin + Math.random() * (rotateYSpeedMax - rotateYSpeedMin);
				}
				addChild(_mc);
			}
			addEventListener(Event.ENTER_FRAME, moveSnow);
		}
		
		private function moveSnow(e:Event):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var _mc:ParticleCont = this.getChildAt(i) as ParticleCont;
				_mc.y += _mc.speedY * direction;
				_mc.x = _mc.initX + Math.cos(_mc.y / _mc.amplitudeTime) * _mc.amplitudeMax;
				/*if (_mc.amplitudeF) {
					_mc.x += _mc.amplitudeTime;
					if (_mc.x >= _mc.initX + _mc.amplitudeMax) {
						_mc.amplitudeF = false;
					}
				} else {
					_mc.x -= _mc.amplitudeTime;
					if (_mc.x <= _mc.initX - _mc.amplitudeMax) {
						_mc.amplitudeF = true;
					}
				} */
				if (direction > 0) {
					if (_mc.y > snowHeight + _mc.height) {
						_mc.x = _mc.initX = Math.round(Math.random() * snowWidth);
						_mc.y = 0 - _mc.height;
					}
				} else {
					if (_mc.y < 0 - _mc.height) {
					_mc.x = _mc.initX = Math.round(Math.random() * snowWidth);
					_mc.y = snowHeight + _mc.height;
					}
				}
				if (rotateIt) _mc.rotationZ += _mc.rotationSpeed;
				if (rotateXIt) _mc.rotationX += _mc.rotationXSpeed;
				if (rotateYIt) _mc.rotationY += _mc.rotationYSpeed;
			}
		}
		
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, moveSnow);
			for (var i:int = 0; i < this.numChildren; i++) {
				this.removeChildAt(0);
			}
		}
		
	}

}

import flash.display.Sprite;

internal class Snowflake extends Sprite {
	
	static private const RADIUS:Number = 2;
	
	public function Snowflake() {
		var _mc:Sprite = new Sprite();
		_mc.graphics.beginFill(0xFFFFFF);
		_mc.graphics.drawCircle(RADIUS, RADIUS, RADIUS * 2);
		_mc.graphics.endFill();
		addChild(_mc);
	}
}

internal class ParticleCont extends Sprite {
	public var initX:Number;
	public var initY:Number;
	public var speedY:Number;
	public var amplitudeMax:Number;
	public var amplitudeF:Boolean;
	public var amplitudeTime:Number;
	public var rotationSpeed:Number;
	public var rotationXSpeed:Number;
	public var rotationYSpeed:Number;
}
