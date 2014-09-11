/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.geom
{
	import flash.geom.Point;
	
	/**
	 * сегмент кривой Безье
	 */
	public class PathSegment 
	{
		private var _p0:Point;
		private var _p1:Point;
		private var _p2:Point;
		
		private var _length:Number;
		
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		
		private var _sqrt_a:Number;
		private var _sqrt_c:Number;
		
		
		/**
		 * constructor
		 * @param	p0	точки кривой Безье
		 * @param	p1
		 * @param	p2
		 */
		public function PathSegment(p0:Point, p1:Point, p2:Point) 
		{
			_p0 = p0;
			_p1 = p1;
			_p2 = p2;
			
			var a1:Number = _p0.x - 2 * _p1.x + _p2.x;
			if (!a1) a1 = 1e-6;
			var a2:Number = _p0.y - 2 * _p1.y + _p2.y;
			if (!a2) a2 = 1e-6;
			var a3:Number = _p0.x - _p1.x;
			var a4:Number = _p0.y - _p1.y;
			
			_a = 4 * (a1 * a1 + a2 * a2);
			_b = -8 * (a1 * a3 + a2 * a4);
			_c = 4 * (a3 * a3 + a4 * a4);
			
			_sqrt_c = Math.sqrt(_c);
			_sqrt_a = Math.sqrt(_a);
			
			
			var d:Number = Math.sqrt(_c + _b + _a);
			
			var a2t:Number = _a*2;
			_length = (2 * _sqrt_a * (d * (_b + a2t) - _sqrt_c * _b) + 
					(_b * _b - 4 * _a * _c) * (Math.log(2 * _sqrt_c + _b / _sqrt_a) - 
					Math.log(2 * d + (_b + a2t) / _sqrt_a))) / (8 * Math.pow(_a, (3 / 2)));
		}
		
		
		
		/**
		 * расчет параметров точки на сегменте
		 * @param	pos 	позиция, px
		 * @return
		 */
		public function getPoint(pos:Number):PathPoint
		{
			
			var st:Number = 1;
			var f:Number = 1;
			var targ:Number = length;
			var max_i:Number = 100; 
			
			
			while (Math.abs(targ - pos) > 1e-6 && max_i-->0)
			{
				var d:Number = Math.sqrt(_c + f * (_b + _a * f));
				var a2i:Number = _a * 2 * f;
				targ = (2 * _sqrt_a * (d * (_b + a2i) - _sqrt_c * _b) + 
					(_b * _b - 4 * _a * _c) * (Math.log(2 * _sqrt_c + _b / _sqrt_a) - 
					Math.log(2 * d + (_b + a2i) / _sqrt_a))) / (8 * Math.pow(_a, (3 / 2)));
				st /= 2;
				f += targ < pos ? st : (targ > pos ? -st : 0);
				
			}
			
			var z:Number = 1 - f;
			var zz:Number = z * z;
			var fz2:Number = 2 * f * z;
			var ff:Number = f * f;
			
			var x:Number = _p2.x * ff + _p1.x * fz2 + _p0.x * zz;
			var y:Number = _p2.y * ff + _p1.y * fz2 + _p0.y * zz;
			var r:Number = Math.atan2(_p0.y - _p1.y + (2 * _p1.y - _p0.y - _p2.y) * f, 
									_p0.x - _p1.x + (2 * _p1.x - _p0.x - _p2.x) * f) / (Math.PI / 180);
			
			return new PathPoint(x, y, r);
		}
		/**
		 * длина сегмента
		 */
		public function get length():Number { return _length; }
		
		
	}
	
}