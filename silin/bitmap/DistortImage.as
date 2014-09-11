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
	 * спрайт с механизмом отрисовки текстуры  в произволные точки <br>
	 * реализован через beginBitmapFill
	 * 
	 * @author silin
	 */
	public class DistortImage extends Sprite
	{
		
		private var _texture:BitmapData;
		private var _smoothing:Boolean = false;
		private var _hseg:int;
		private var _vseg:int;
		private var _points:Array/*GridPoint*/=[];
		private var _triangles:Array = [];
		//обраnные величины размеров
		private var _iW:Number;
		private var _iH:Number;
		
		
		/**
		 * constructor
		 * @param	texture			BitmapData  для отрисовки
		 * @param	hseg			число  разбивок по горизонтали
		 * @param	vseg			число  разбивок по вертикали
		 * @param	smoothing		нужно ли применять сглаживание (тормоза)
		 */
		public function DistortImage( texture:BitmapData, hseg: int=0, vseg: int=0, smoothing:Boolean=false)
		{
			_texture = texture;
			_vseg = vseg;
			_hseg = hseg;
			_smoothing = smoothing;
			init();
		}
		/**
		 * 
		 * @param	arr
		 */
		public function setTransformByArray(arr:Array):void
		{
			setTransform(arr[0].x, arr[0].y, arr[1].x, arr[1].y, arr[2].x, arr[2].y, arr[3].x, arr[3].y);
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
			
			
			for (var i:int = 0; i < _points.length; i++) 
			{
				
				var point:GridPoint = _points[i];
				var gx:Number =  _iW * point.x;
				var gy:Number =  _iH * point.y;
				var bx:Number = x0 + gy * ( dx30 );
				var by:Number = y0 + gy * ( dy30 );

				point.sx = bx + gx * (( x1 + gy * ( dx21 ) ) - bx );
				point.sy = by + gx * (( y1 + gy * ( dy21 ) ) - by );
			}
			render();
		}

		
		private function init(): void
		{	
			_iW = 1 / _texture.width;
			_iH = 1 / _texture.height;
			_points = [];
			_triangles = [];
			var ix:int;
			var iy:int;
			var segmW:Number = _texture.width / ( _hseg + 1 );
			var segmH:Number = _texture.height / ( _vseg + 1 );
			
			// точки сетки, минимально: одна ячейка, два треуголника
			var xLen:int = _hseg +2;
			var yLen:int = _vseg +2;
			for (ix = 0; ix < xLen; ix++)
			{
				for (iy = 0; iy < yLen; iy++)
				{
					_points.push(new GridPoint(ix * segmW, iy * segmH));
				}
			}
			
			// треугольники, по два на каждую ячейку
			for (ix = 0; ix < xLen - 1; ix++)
			{
				for (iy = 0; iy < yLen - 1; iy++)
				{
					addTriangle( 
						_points[iy + ix * yLen],
						_points[iy + ix * yLen + 1],
						_points[iy + ( ix + 1 ) * yLen]
					);
					addTriangle( 
						_points[iy + ( ix + 1 ) * yLen + 1],
						_points[iy + ( ix + 1 ) * yLen],
						_points[iy + ix * yLen + 1]
					);
				}
			}
			render();
		}
		
		//считаем матрицу и пихаем треугольник в массив
		private function addTriangle( p0:GridPoint, p1:GridPoint, p2:GridPoint ):void
		{
			var mtrx:Matrix = new Matrix();
			
			mtrx.tx = -p0.y * (_texture.width / (p1.y - p0.y));
			mtrx.ty = -p0.x * (_texture.height / (p2.x - p0.x));
			mtrx.b = _texture.height / (p2.x - p0.x);
			mtrx.c = _texture.width / (p1.y - p0.y);
		
			_triangles.push(new GridTriangle(p0, p1, p2, mtrx));
		}
		
		//заливает треугольники битмапом
		private function render(): void
		{
			
			var mtrx:Matrix = new Matrix();
			//var i:Number = _triangles.length;
			
			graphics.clear();
			//while ( --i > -1 )
			for (var i:int = 0; i < _triangles.length; i++) 
			{
				
				var tri:GridTriangle = _triangles[ i ];
				var p0:GridPoint = tri.p0;
				var p1:GridPoint = tri.p1;
				var p2:GridPoint = tri.p2;
				
				
				var tX:Number = p0.sx;
				var tY:Number = p0.sy;
				
				mtrx.a = ( p1.sx - tX) * _iW;
				mtrx.b = ( p1.sy - tY) * _iW;
				mtrx.c = ( p2.sx - tX ) * _iH;
				mtrx.d = ( p2.sy - tY ) * _iH;
				mtrx.tx = tX;
				mtrx.ty = tY;
				
				
				graphics.beginBitmapFill( _texture, concat(mtrx, tri.matrix), false, _smoothing );
				graphics.moveTo( tX, tY );
				graphics.lineTo( p1.sx, p1.sy );
				graphics.lineTo( p2.sx, p2.sy );
				graphics.endFill();
			}
		}
		
		private function concat(m1:Matrix, m2:Matrix):Matrix 
		{
			
			var mtrx:Matrix = new Matrix();
			mtrx.a  = m1.c * m2.b;
			mtrx.b  = m1.d * m2.b;
			mtrx.c  = m1.a * m2.c;
			mtrx.d  = m1.b * m2.c;
			mtrx.tx = m1.a * m2.tx + m1.c * m2.ty + m1.tx;
			mtrx.ty = m1.b * m2.tx + m1.d * m2.ty + m1.ty;	
			return mtrx;
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
/////////////////////////////////////////////////////////////////////////
import flash.geom.Matrix;

class GridPoint
{
	public var x:Number;
	public var y:Number;
	public var sx:Number;
	public var sy:Number;
	public function GridPoint(x:Number=0, y:Number=0)
	{
		this.x = x;
		this.y = y;
		this.sx = x;
		this.sy = y;
	}
}
////////////////////////////////////////////////////////////////////////
class GridTriangle
{
	public var p0:GridPoint;
	public var p1:GridPoint;
	public var p2:GridPoint;
	public var matrix:Matrix;
	public function GridTriangle(p0:GridPoint, p1:GridPoint, p2:GridPoint, matrix:Matrix)
	{
		this.p0 = p0;
		this.p1 = p1;
		this.p2 = p2;
		this.matrix = matrix;
	}
}
////////////////////////////////////////////////////////////////////////