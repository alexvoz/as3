/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.gadgets
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import silin.filters.WaveMap;
	
	
	

	/**
	 * отражение визуального объекта<br>
	 * 
	 * 
	 * @author silin
	 */
	public class Reflection extends Sprite
	{
		//объект для отрисовки
		private var _target:DisplayObject;
		//матрица отрисовки (sclaeY=-1)
		private var _reflMatrix:Matrix;
		//битмап отражения
		private var _reflBmp:Bitmap;
		//вспомогательный шейп, нужен для маски копирования отражения
		private var _mask:Shape;
		//альфа маска, используется при копировании
		private var _maskBmd:BitmapData;
		//DisplacementMapFilter для зыби
		private var _waveMap:WaveMap;
		//какая часть объекта попадает в отражение
		private var _ratio:Number = 0.65;
		//коэффициент для зыби
		private var _waveScale:Number = 0;
		//наклон
		private var _skew:Number = 0;
		
		
		/**
		 * 
		 * @param	displayObject	объект, отражение которого нужно получить
		 * @param	ratio			коэффициент, определяющий сколько высоты объекта попадает в отражеие , 0..1
		 * @param	scale			масштаб самого отражения, 0..1
		 * @param	skew			наклон, -1..1
		 * @param	waveScale		масштаб волнения
		 */
		public function Reflection(displayObject:DisplayObject, ratio:Number = 0.65, skew:Number = 0, waveScale:Number = 0) 
		
		{
			
			_target = displayObject;
			
			
			
			_reflBmp = new Bitmap();
			addChild(_reflBmp);
			
			_reflMatrix = new Matrix();
			_reflMatrix.scale(1, -1);
			_reflMatrix.translate(0, _target.height);
			
			_mask = new Shape();
			_waveMap = new WaveMap(_target.width, _target.height);
			_waveMap.scale = _waveScale;
			
			if (waveScale > 0)
			{
				addEventListener(Event.ENTER_FRAME, updateWave);
				filters = [_waveMap.filter];
			}
			
			_ratio = ratio;
			update();
			
		}
		
		/**
		 * перерисовывает объект
		 */
		public function update():void
		{
			createMask();
			drawTarget();
		}
		
		private function updateWave(e:Event):void
		{
			
			_waveMap.shift(1 + 2 * Math.random());
			filters = [_waveMap.filter];
				
			
			
		}
		
		private function drawTarget():void
		{
			var targetBitmatData:BitmapData = new BitmapData(_target.width, _target.height);
			targetBitmatData.draw(_target, _reflMatrix);
			_reflBmp.bitmapData = new BitmapData(_target.width, _target.height, true, 0x00000000);
			_reflBmp.bitmapData.copyPixels(targetBitmatData, targetBitmatData.rect, new Point(), _maskBmd, new Point(), true);
		}
		
		private function createMask():void
		{
			var colors:Array = [0xFF000000, 0xFF000000, 0xFF000000];
			var alphas:Array = [1, 0.05, 0];
			var mtrx:Matrix = new Matrix();
			mtrx.createGradientBox(_target.width, _target.height,Math.PI/2);
			var ratios:Array = [0x00, _ratio*0xDD, _ratio * 0xFF];
			_mask.graphics.clear();
			_mask.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mtrx);
			_mask.graphics.drawRect(0, 0, _target.width, _target.height);
			_maskBmd=new BitmapData(_target.width, _target.height, true, 0x00000000);
			_maskBmd.draw(_mask);
			
		}
		/**
		 * продольный размер волн (default=20)
		 */
		public function get vaweHeight():Number { return _waveMap.waveHeigth }
		public function set vaweHeight(value:Number):void
		{
			
			_waveMap.waveHeigth = value;
		}
		/**
		 * коэффициент, определяющий видимую часть отражения , 0..1
		 */
		public function get ratio():Number { return _ratio; }
		public function set ratio(value:Number):void 
		{
			_ratio = value;
			update();
		}
		/**
		 * масштаб волн, px
		 * если задано ненудевое значение, запускаем рендеринг на enterFrame
		 */
		public function get waveScale():Number { return _waveScale; }
		public function set waveScale(value:Number):void 
		{
			_waveScale = value;
			if (_waveScale > 0)
			{
				addEventListener(Event.ENTER_FRAME, updateWave);
				_waveMap.scale = _waveScale;
				filters = [_waveMap.filter];
				
			}else
			{
				_waveMap.scale = 0;
				removeEventListener(Event.ENTER_FRAME, updateWave);
				filters = [];
			}
			
		}
		
		/**
		 * наклон, -1..1
		 */
		public function get skew():Number { return _skew; }
		public function set skew(value:Number):void 
		{
			
			_skew = value;
			var mtrx:Matrix = transform.matrix;
			mtrx.c = _skew;
			transform.matrix = mtrx;
			
		}
		/**
		 * граница плавного перехода , 0..1 от высоты (default = 0.25)
		 */
		public function get waveOffset(): Number
		{
			return _waveMap.offset;
		}
		public function set waveOffset(value:Number):void
		{
			
			_waveMap.offset = value;
			
		}
		
	}
	
}