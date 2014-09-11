/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.bitmap
{
	
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
	import silin.utils.Color;
    
	
	/**
	 * 
	 * битмап с механизмом создания/отрисовки системы частиц<br>
	 * предустановки для взрыва и дыма<br>
	 * идея и прототип: http://lab.andre-michelle.com/particle-explosion
	 * 
	 * @author silin
	 */
    public class ExplosionBitmap extends Bitmap
    {
		public static const EXPLOSION:String = "explosion";
		public static const SMOKE:String = "smoke";
		
		private static const EXPLOSION_TOTAL_COUNT:int = 2000;
		private static const EXPLOSION_FRAME_COUNT:int = 200;
		private static const EXPLOSION_INIT_RADIUS:int = 16;
		private static const EXPLOSION_VELOCITY:Number = 1;
		private static const EXPLOSION_DAMP_ENERGY:Number = 0.96;
		private static const EXPLOSION_CHAOTIC_MOVE:Number = 0.3;
		private static const EXPLOSION_DAMP_MOVE:Number = 0.98;
		private static const EXPLOSION_BLUR:int = 2;
		
		private static const SMOKE_TOTAL_COUNT:int = 2000;
		private static const SMOKE_FRAME_COUNT:int = 50;
		private static const SMOKE_INIT_RADIUS:int = 90;
		private static const SMOKE_VELOCITY:Number = 0.5;
		private static const SMOKE_DAMP_ENERGY:Number = 0.995;
		private static const SMOKE_CHAOTIC_MOVE:Number = 0.2;
		private static const SMOKE_DAMP_MOVE:Number = 0.97;
		private static const SMOKE_ALPHA:Number = 0.85;
		private static const SMOKE_ALPHA_DEVIATION:Number = 0.25;
		private static const SMOKE_BLUR:int = 8;
		
		
		/**
		 * направленность по горизонтали
		 */
		public var wind:Number = 0;
		/**
		 * исходный радиус облака
		 */
		public var initRadius:int = 20;
		/**
		 * максимальная начальная скорость частиц
		 */
		public var initVelocity:Number = 2;
		/**
		 * общее количество частиц
		 */
		public var totalCount:int = 2000;
		/**
		 * число частиц, вводимых в счет на каждом такте
		 */
		public var perFrameCount:int = 200;
		/**
		 * коэффициент затухания энергии частиц
		 */
		public var energyDamp:Number = 0.97;
		/**
		 * коэффициент затухания скорости частиц
		 */
		public var dampMove:Number = 0.99;
		/**
		 * коэффициент хаотичого измения траетории
		 */
		public var chaoticMove:Number = 0.3;// 0.1825;
		//цвета взрыва
		private var _fireColors:Array = [0, 0, 0x403030, 0x602000, 0xFF4000, 0xFFFF00, 0xFFFFFF];
		//цвет дыма
		private var _smokeColor:int = 0xF9F8E3;
		
		//битмапДата для промежуточной отрисовки
		private var _buffer:BitmapData;
		//блур, величина блура сильно влияет на результат
        private var _blur:BlurFilter = new BlurFilter();
		//текущий массив раскраски
		private var _colors:Array = [];
		//текущий массив систем частиц
		private var _explosions:Array = [];
		private var _type:String;
		/**
		 * constructor
		 * @param	width		размеры
		 * @param	height
		 * @param	type		EXPLOSION | SMOKE : установка набора пааметров генератора
		 */
        public function ExplosionBitmap(width:int = 300, height:int = 300, type:String = EXPLOSION)
        {
 			
            _buffer = new BitmapData(width, height, false, 0);
			super(new BitmapData(width, height, true, 0));
			this.type = type;
        }
		
		/**
		 * создает еземпляр ExplosionBitmap 
		 * @param	type	тип создаваемого ExplosionBitmap
		 * @param	half	полусфера
		 * @return
		 */
		
		public static function getExplosion(type:String = EXPLOSION, half:Boolean = false):ExplosionBitmap
		{
			var expl:ExplosionBitmap = new ExplosionBitmap();
			expl.type = type;
			expl.addExplosion(expl.width / 2, expl.height / 2, half);
			return expl;
		}
		
		/**
		 * создает систему частиц с центром в [x,y]
		 * @param	x		координаты
		 * @param	y
		 * @param	half	полусфера (верхняя)
		 */
        public function addExplosion(x:int, y:int, half:Boolean=false) : void
        {
			
            _explosions.push(new Explosion(this, x, y, type, half));
			if (!hasEventListener(Event.ENTER_FRAME))
			{
				addEventListener(Event.ENTER_FRAME, render);
			}
        }
		//TODO: destroy вставлено наспех, надо смотреть внимательно
		public function destroy():void
		{
			clear();
			removeEventListener(Event.ENTER_FRAME, render);
			bitmapData.dispose();
			bitmapData = null;
		}
		
		/**
		 * убирает все подчистую
		 */
		public function clear():void
		{
			for (var i:int = 0; i < _explosions.length; i++) 
			{
				var expl:Explosion = _explosions[i];
				expl.clear();
			}
			_buffer.fillRect(_buffer.rect, 0);
			bitmapData.fillRect(bitmapData.rect, 0);
		}
		
		/**
		 * переводит систему в режим ускоренного завершения процесса<br>
		 * за счет уменьшения коэффициента ослабления
		 */
		public function fastEnd():void
		{
			for (var i:int = 0; i < _explosions.length; i++) 
			{
				var expl:Explosion = _explosions[i];
				expl.weak();
			}
		}
		
        private function render(evnt:Event) : void
        {
			
			for (var i:int = 0; i < _explosions.length; i++) 
			{
				
				var expl:Explosion = _explosions[i];
				expl.render(_buffer);
				if (expl.done) //все частицы догорели
				{
					_explosions.splice(i, 1);
				}
				
			}
			
			if (_explosions.length == 0)
			{
				removeEventListener(Event.ENTER_FRAME, render);
				dispatchEvent(new Event(Event.COMPLETE));
				_buffer.fillRect(_buffer.rect, 0);
				bitmapData.fillRect(bitmapData.rect, 0);
				
			}else
			{
				
				
				//будем мурыжить только реальную часть, актуально для больших битмапов
				//TODO: однако осталось неясно есть ли выгода тратится на getColorBoundsRect 
				//при том что при интенсивном применении весь ректангл и покажет
				var rect:Rectangle = _buffer.getColorBoundsRect(0xFFFFFF, 0, false);
				var point:Point = new Point(rect.x, rect.y);
				
				
				_buffer.applyFilter(_buffer, rect, point, _blur);
				bitmapData.copyPixels(_buffer, rect, point);
				bitmapData.paletteMap(bitmapData, rect, point, [], [], _colors, []);
			}
			
           
        }
		/**
		 * установка параметров генератора для предустанвленных вариантов (EXPLOSION, SMOKE)
		 */
		public function get type():String { return _type; }
		public function set type(value:String):void 
		{
			_type = value;
			//переписываем статические переменные
			switch(type)
			{
				case EXPLOSION:
					_colors =  Color.getGradientArray(
					_fireColors, 
					[0, 0, 1, 1, 1, 1, 1],
					[0, 34, 68, 74, 85, 136, 255]);
					_blur.blurX = EXPLOSION_BLUR;
					_blur.blurY = EXPLOSION_BLUR;
					initRadius = EXPLOSION_INIT_RADIUS;
					initVelocity = EXPLOSION_VELOCITY;
					totalCount = EXPLOSION_TOTAL_COUNT;
					perFrameCount = EXPLOSION_FRAME_COUNT;
					energyDamp = EXPLOSION_DAMP_ENERGY;
					dampMove = EXPLOSION_DAMP_MOVE;
					chaoticMove = EXPLOSION_CHAOTIC_MOVE;
				break;
				case SMOKE:
					_colors = Color.getGradientArray(
					[_smokeColor, smokeColor, smokeColor, smokeColor, smokeColor], 
					[0, SMOKE_ALPHA - SMOKE_ALPHA_DEVIATION / 2, SMOKE_ALPHA + SMOKE_ALPHA_DEVIATION / 2, SMOKE_ALPHA, 1],
					[0, 64, 192, 220, 255]);
					_blur.blurX = SMOKE_BLUR;
					_blur.blurY = SMOKE_BLUR;
					initRadius = SMOKE_INIT_RADIUS;
					initVelocity = SMOKE_VELOCITY;
					totalCount = SMOKE_TOTAL_COUNT;
					perFrameCount = SMOKE_FRAME_COUNT;
					energyDamp = SMOKE_DAMP_ENERGY;
					dampMove = SMOKE_DAMP_MOVE;
					chaoticMove = SMOKE_CHAOTIC_MOVE;
				break;
			}
		}
		/**
		 * цвет дыма (для режима SMOKE)
		 */
		public function get smokeColor():int { return _smokeColor; }
		public function set smokeColor(value:int):void 
		{
			_smokeColor = value;
			if (type == SMOKE)
			{
				_colors = Color.getGradientArray(
				[_smokeColor, smokeColor, smokeColor, smokeColor, smokeColor], 
				[0, SMOKE_ALPHA - SMOKE_ALPHA_DEVIATION / 2, SMOKE_ALPHA + SMOKE_ALPHA_DEVIATION / 2, SMOKE_ALPHA, 1],
				[0, 64, 192, 220, 255]);
			}
		}
		/**
		 * цвета взрыва (для ркжима EXPLOSION)
		 */
		public function get fireColors():Array { return _fireColors; }
		
		public function set fireColors(value:Array):void 
		{
			_fireColors = value;
			if (type == EXPLOSION)
			{
				_colors =  Color.getGradientArray(
					_fireColors, 
					[0, 0, 1, 1, 1, 1, 1],
					[0, 34, 68, 74, 85, 136, 255]);
			}
		}
    }
}
//==========================================================
//Нюанс: 
//для mxmlc и CS3 такой вариант размещения "внутренних" классов годится,
//а CS4 не хочет в таком виде есть эти классы, надо выносить в отдельные файлы
//==========================================================
import flash.display.BitmapData;
import flash.geom.Point;
import silin.bitmap.ExplosionBitmap;

class Explosion 
{
	
	private const RANDOMIZE:Number = 1;
	
	private var _eachFrameCount:int = 100;
	private var _currArr:Array = [];
	private var _totalArr:Array = [];
	


	public function Explosion(owner:ExplosionBitmap, x:Number, y:Number, type:String=ExplosionBitmap.EXPLOSION, half:Boolean=false)
	{
		_eachFrameCount = owner.perFrameCount;
		
		var velocity:Number = owner.initVelocity;
		var radius:Number = owner.initRadius;
		//для дыма всегда полусфера
		//if (type == ExplosionBitmap.SMOKE) half = true;
		
		for (var i:int = 0; i < owner.totalCount; i++) 
		{
			var fi:Number = Math.random() * Math.PI * (half ? -1 : 2);
			var dv:Number = Math.random() * velocity;
			var rnd:Number = Math.random();
			
			if (type == ExplosionBitmap.SMOKE) 
			{
				//для дыма ослабляем плотность в центре
				rnd = Math.sqrt(rnd);
			}
			var dr:Number = rnd * radius;
			
			var  p:Particle = new Particle();
			p.sx = x + dr * Math.cos(fi);
			p.sy = y + dr * Math.sin(fi);
			
			p.vx = dv * Math.cos(fi) + owner.wind * Math.random();
			p.vy = dv * Math.sin(fi);
			//чтоб не слишком одинаковые были
			p.vx += RANDOMIZE * (1 - 2 * Math.random());
			p.vy += RANDOMIZE * (1 - 2 * Math.random());
			
			p.energyDamp = owner.energyDamp;
			p.chaoticMove = owner.chaoticMove;
			p.moveDamp = owner.dampMove;
			
			if (type == ExplosionBitmap.SMOKE)
			{
				//чтоб не слишком круглый был
				p.sy += (0.5 + Math.random()) * dr * (1 - Math.abs(Math.cos(fi))) / 2;
				p.energy-= Math.random() / 2;
			}
			
			
			_totalArr.push(p);
		}
		
	}
	
	public function clear():void
	{
		_currArr = [];
		_totalArr = [];
	}
	
	public function weak():void
	{
		var i:int;
		for (i = 0; i < _currArr.length; i++) 
		{
			Particle(_currArr[i]).energyDamp = 0.925;
		}
		_totalArr = [];
	}
	/**
	 * расчет и расстановка  пикселей-инедксов в bmd
	 * @param	bmp
	 */
	public function render(bmd:BitmapData) : void
	{
		
		//берем очередную порцию, если есть что брать
		if (_totalArr.length >= _eachFrameCount)
		{
			_currArr = _currArr.concat(_totalArr.splice( -_eachFrameCount));
		}
		//считаем текущий набор
		for (var i:int = 0; i < _currArr.length; i++) 
		{
			
			var p:Particle = _currArr[i];
			p.render();
			if (p.energy < 0.05)
			{
				_currArr.splice(i, 1);
			}
			bmd.setPixel(p.sx, p.sy, int(p.energy * 255));
		}
	}
	//все частицы отработали
	public function get done():Boolean 
	{ 
		return _currArr.length==0; 

	}
}
/////////////////

class Particle 
{
	public var sx : Number;
	public var sy : Number;
	public var vx : Number;
	public var vy : Number;
	public var energy : Number = 1;
	public var energyDamp:Number;
	public var moveDamp:Number;
	public var chaoticMove:Number;
	
	
	public function render():void
	{
		vx += chaoticMove * (2 * Math.random() - 1);
		vy += chaoticMove * (2 * Math.random() - 1);
		energy *= energyDamp;
		sx += vx;
		sy += vy;
		vx *=  moveDamp;
		vy *=  moveDamp;
	}
}