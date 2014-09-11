package ua.olexandr.display.effects {
	import flash.display.Sprite;
	import flash.events.Event;
	import ua.olexandr.tools.tweener.Tweener;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Snow extends Sprite {
		
		private const TIME_OF_SHOW:Number = 2; 		// время появления снега
		private const AMPLITUDE_STEP:Number = .2; 	// шаг амплитуды колебания
		
		
		private var _vos:Array;
		
		private var _width:Number; 					// высота стены снега
		private var _height:Number;					// ширина стены снега
		
		private var _count:int;
		private var _speedMin:Number;
		private var _speedMax:Number;
		private var _scaleMin:Number;
		private var _scaleMax:Number;
		private var _alphaMin:Number;
		private var _alphaMax:Number;
		private var _amplitudeMax:Number;
		
		/**
		 * 
		 * @param	count			количество снежинок
		 * @param	speedMin		минимальная скорость
		 * @param	speedMax		максимальная скорость
		 * @param	scaleMin		минимальный размер в процентах
		 * @param	scaleMax		максимальный размер в процентах
		 * @param	alphaMin		минимальный уровень прозрачности
		 * @param	alphaMax		максимальный уровень прозрачности
		 * @param	amplitudeMax	максимальная амплитуда колебания
		 */
		public function Snow(count:int = 100, speedMin:Number = .2, speedMax:Number = 1, scaleMin:Number = .1, scaleMax:Number = .5, alphaMin:Number = .5, alphaMax:Number = .75, amplitudeMax:Number = 3):void {
			setSize(100, 100);
			
			_count = count;
			_speedMin = speedMin;
			_speedMax = speedMax;
			_scaleMin = scaleMin;
			_scaleMax = scaleMax;
			_alphaMin = alphaMin;
			_alphaMax = alphaMax;
			_amplitudeMax = amplitudeMax;
			
			_vos = [];
			
			for (var i:int = 0; i < _count; i++) {
				var _sf:Snowflake = new Snowflake();
				var _s:Number = Math.random() * (_scaleMax - _scaleMin) + _scaleMin;
				_sf.scaleX = _s;
				_sf.scaleY = _s;
				_sf.alpha = 0;
				_sf.x = Math.round(Math.random() * _width);
				_sf.y = Math.round(Math.random() * _height);
				addChild(_sf);
				
				var _a:Number = Math.random() * (_alphaMax - _alphaMin) + _alphaMin;
				Tweener.addTween(_sf, TIME_OF_SHOW, { alpha:_a } );
				
				var _speedY:Number = Math.random() * (_speedMax - _speedMin) + _speedMin;
				var _ampM:int = Math.round(Math.random() * _amplitudeMax);
				var _ampF:Boolean = Math.random() > .5;
				_vos[i] = new SnowflakeVO(_sf.x, _speedY, _ampM, _ampF);
				
				_sf.addEventListener(Event.ENTER_FRAME, snowflakeEFHandler);
			}
		}
		
		public function setSize(w:Number, h:Number):void {
			_width = w;
			_height = h;
		}
		
		
		private function snowflakeEFHandler(e:Event):void {
			var _sf:Snowflake = e.target as Snowflake;
			var _vo:SnowflakeVO = _vos[getChildIndex(_sf)] as SnowflakeVO;
			
			_sf.y += _vo.speedY;
			if (_vo.ampF) {
				_sf.x += AMPLITUDE_STEP;
				if (_sf.x >= _vo.x + _vo.ampM)
					_vo.ampF = false;
			} else {
				_sf.x -= AMPLITUDE_STEP;
				if (_sf.x <= _vo.x - _vo.ampM)
					_vo.ampF = true;
			}
			
			if (_sf.y > height) {
				_sf.x = Math.round(Math.random() * width);
				_sf.y = -_sf.height;
			}
		}
		
	}
	
}


import flash.display.Shape;

internal class Snowflake extends Shape {
	
	public function Snowflake(color:uint = 0xFFFFFF, radius:Number = 2) {
		graphics.beginFill(color);
		graphics.drawCircle(radius, radius, radius * 2);
		graphics.endFill();
	}
	
}

internal class SnowflakeVO {
	
	public var x:Number;
	public var speedY:Number;
	public var ampM:int;
	public var ampF:Boolean;
	
	public function SnowflakeVO(x:Number, sy:Number, am:int, af:Boolean) {
		this.x = x;
		this.speedY = sy;
		this.ampM = am;
		this.ampF = af;
	}
}