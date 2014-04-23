package ua.alexvoz.tools {
	import com.greensock.TweenLite;
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
		private var _snowClass:Class = Snowflake;//класс снежинки
		private var _count:Number = 200;// количество снежинок
		private var _snowWidth:Number;// высота стены снега
		private var _snowHeight:Number;// ширина стены снега
		private var _duration:Number = 2;// время появления снега
		private var _speedMin:Number = 1;// минимальная скорость
		private var _speedMax:Number = 3;// максимальная скорость
		private var _scaleMin:Number = .5;// минимальный размер в процентах
		private var _scaleMax:Number = 1;// максимальный размер в процентах
		private var _alphaMin:Number = 75;// минимальный уровень прозрачности
		private var _alphaMax:Number = 100;// максимальный уровень прозрачности
		private var _amplitudeMax:Number = 8;// максимальная амплитуда колебания
		private var _amplitudeMin:Number = 4;// максимальная амплитуда колебания
		private var _amplitudeStep:Number = .2;// шаг амплитуды колебания
		
		public function Snow(w:Number, h:Number) {
			_snowWidth = w;
			_snowHeight = h;
			if (stage) addedHandler(null)
			else addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(e:Event):void {
			if (e) removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		public function run():void {
			for (var i:Number = 0; i < _count; i++) {
				var _do:DisplayObject = new _snowClass();
				var _doMc:MovieClip = _do as MovieClip;
				if (_doMc && _doMc.totalFrames > 1)
					_doMc.gotoAndStop(Math.round(Math.random() * _doMc.totalFrames));
				var _mc:MovieClip = new MovieClip();
				_mc.addChild(_do);
				_mc.x = _mc.initX = Math.round(Math.random() * _snowWidth);
				_mc.y = Math.round(Math.random() * _snowHeight);
				_mc.scaleX = _mc.scaleY = Math.random() * (_scaleMax - _scaleMin) + _scaleMin;
				//_mc.alpha = 0;
				//var needAlpha:Number = Math.round(Math.random() * (_alphaMax - _alphaMin) + _alphaMin);
				//TweenLite.to(_mc, _duration, { alpha:needAlpha } );
				_mc.speedY = Math.random() * (_speedMax - _speedMin) + _speedMin;
				_mc.amplitudeMax = _amplitudeMin + Math.round(Math.random() * (_amplitudeMax - _amplitudeMin));
				_mc.amplitudeF = Boolean(Math.round(Math.random()));
				addChild(_mc);
			}
			addEventListener(Event.ENTER_FRAME, moveSnow);
		}
		
		private function moveSnow(e:Event):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var _mc:MovieClip = this.getChildAt(i) as MovieClip;
				_mc.y += _mc.speedY;
				if (_mc.amplitudeF) {
					_mc.x += _amplitudeStep;
					if (_mc.x >= _mc.initX + _mc.amplitudeMax) {
						_mc.amplitudeF = false;
					}
				} else {
					_mc.x -= _amplitudeStep;
					if (_mc.x <= _mc.initX - _mc.amplitudeMax) {
						_mc.amplitudeF = true;
					}
				}
				if (_mc.y > _snowHeight + _mc.height) {
					_mc.x = _mc.initX = Math.round(Math.random() * _snowWidth);
					_mc.y = 0 - _mc.height;
				}
			}
		}
		
		public function get snowClass():Class {
			return _snowClass;
		}
		
		public function set snowClass(value:Class):void {
			_snowClass = value;
		}
		
		public function get count():Number {
			return _count;
		}
		
		public function set count(value:Number):void {
			_count = value;
		}
		
		public function get snowWidth():Number {
			return _snowWidth;
		}
		
		public function set snowWidth(value:Number):void {
			_snowWidth = value;
		}
		
		public function get snowHeight():Number {
			return _snowHeight;
		}
		
		public function set snowHeight(value:Number):void {
			_snowHeight = value;
		}
		
		public function get duration():Number {
			return _duration;
		}
		
		public function set duration(value:Number):void {
			_duration = value;
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
		
		public function get alphaMin():Number {
			return _alphaMin;
		}
		
		public function set alphaMin(value:Number):void {
			_alphaMin = value;
		}
		
		public function get alphaMax():Number {
			return _alphaMax;
		}
		
		public function set alphaMax(value:Number):void {
			_alphaMax = value;
		}
		
		public function get amplitudeMax():Number {
			return _amplitudeMax;
		}
		
		public function set amplitudeMax(value:Number):void {
			_amplitudeMax = value;
		}
		
		public function get amplitudeStep():Number {
			return _amplitudeStep;
		}
		
		public function set amplitudeStep(value:Number):void {
			_amplitudeStep = value;
		}
		
		public function get amplitudeMin():Number {
			return _amplitudeMin;
		}
		
		public function set amplitudeMin(value:Number):void {
			_amplitudeMin = value;
		}
		
	}

}

import flash.display.Sprite;

internal class Snowflake extends Sprite {
	
	static private const DIAMETER:Number = 2;
	static private const RADIUS:Number = DIAMETER * .5;
	
	public function Snowflake() {
		var _mc:Sprite = new Sprite();
		_mc.graphics.beginFill(0xFFFFFF);
		_mc.graphics.drawCircle(RADIUS, RADIUS, DIAMETER);
		_mc.graphics.endFill();
		addChild(_mc);
	}
}
