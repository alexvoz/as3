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
	import flash.geom.*;
	/**
	 * спрайт с механизмом отрисовки текстуры в произволные точки<br>
	 * реализация для FP10 (beginBitmapFill+drawTriangles) <br>
	 * 
	 * @author silin
	 */
	public class DistortImage10 extends Sprite
	{
		
		private var _texture:BitmapData;
		private var _smoothing:Boolean = false;
		private var _hseg:int;
		private var _vseg:int;
		
		private var _indecies:Vector.<int>;
		private var _uvtData:Vector.<Number>;
		private var _verticies:Vector.<Number>;
		private var _kX:Number;
		private var _kY:Number;
		
		
		/**
		 * constructor
		 * @param	texture			BitmapData  для отрисовки
		 * @param	hseg			число  разбивок по горизонтали
		 * @param	vseg			число  разбивок по вертикали
		 * @param	smoothing		нужно ли применять сглаживание (тормоза)
		 */
		public function DistortImage10( texture:BitmapData, hseg: int=0, vseg: int=0, smoothing:Boolean=false)
		{
			_texture = texture;
			_vseg = vseg;
			_hseg = hseg;
			_smoothing = smoothing;
			init();
		}

		/** 
		* рисует шейп по переданным точкам (начиная с TL по часовой)
		*/
		public function setTransform( x0:Number , y0:Number , x1:Number , y1:Number , x2:Number , y2:Number , x3:Number , y3:Number ): void
		{
			
			var dx30:Number = x3 - x0;
			var dy30:Number = y3 - y0;
			var dx21:Number = x2 - x1;
			var dy21:Number = y2 - y1;
			var len:int = _verticies.length;
			
			for (var i:int = 0; i < len; i+=2) 
			{
				
				var gx:Number = _kX * _uvtData[i];
				var gy:Number = _kY * _uvtData[i + 1];
				var bx:Number = x0 + gy *  dx30;
				var by:Number = y0 + gy *  dy30;
				
				_verticies[i] = bx + gx * (( x1 + gy * ( dx21 ) ) - bx );
				_verticies[i + 1] = by + gx * (( y1 + gy * ( dy21 ) ) - by );
				
			}
			render();
		}

		
		private function init(): void
		{
			
			_kX = (_hseg + 2) / (_hseg + 1);
			_kY = (_vseg + 2) / (_vseg + 1);
			
			_uvtData = new Vector.<Number>();
			_verticies = new Vector.<Number>();
			_indecies = new Vector.<int>();
			
			var ix:int;
			var iy:int;
			
			var segmW:Number = _texture.width / ( _hseg + 1 );
			var segmH:Number = _texture.height / ( _vseg + 1 );
			
			// точки сетки, минимально одна ячейка, два треуголника
			var xLen:int = _hseg +2;
			var yLen:int = _vseg +2;
			for (ix = 0; ix < xLen; ix++)
			{
				for (iy = 0; iy < yLen; iy++)
				{
					_verticies.push(ix * segmW, iy * segmH);
					_uvtData.push(ix / xLen, iy / yLen);
					//если не последний ряд-колонка,то добавляем треугольники
					if (ix < xLen - 1 && iy < yLen - 1)
					{
						_indecies.push(	
							iy + ix * yLen, iy + ix * yLen + 1,	iy + ( ix + 1 ) * yLen,
							iy + ( ix + 1 ) * yLen + 1,	iy + ( ix + 1 ) * yLen,	iy + ix * yLen + 1
						);
					}
				}
			}
			render();
		}
		
		private function render(): void
		{
			
			graphics.clear();
			graphics.beginBitmapFill( _texture, null, false, smoothing );
			graphics.drawTriangles(_verticies, _indecies, _uvtData);
			graphics.endFill();	
			
		}
		
		
		/**
		 * сглаживание
		 */
		public function get smoothing():Boolean { return _smoothing; }
		
		public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
		}
		
		/**
		 * BitmapData  для отрисовки<br>
		 * установка битмапа с другими размерами не предусмотрена
		 */
		public function get texture():BitmapData { return _texture; }
		
		public function set texture(value:BitmapData):void 
		{
			_texture = value;
			init();
		}
	}
}
