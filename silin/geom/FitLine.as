/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.geom
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	
	
	
	/**
	 * сглаживание массива точек <br>
	 * в виде массива точек кривой в стиле curveTo [(cX,cY),(aX,aY),..,(cX,cY)]<br>
	 * и/или как Path Дембицкого
	 * 
	 * @author 
	 */
	public class FitLine
	{
		
		
		public static const CUBIC:String = "cubic";
		public static const QUADRATIC:String = "quadratic";
		
		private var _path:Path;
		private var _fitMode:String = QUADRATIC;
		private var _fitPoints:Array;
		private var _srcPoints:Array;
		private var _fitCoeff:Number = 0.38;
		
		/**
		 * constructor 
		 * @param	points		массив исходных точек
		 * @param	coeff		коэффициент сглаживания
		 * @param	fitMode		режим подгонки QUADRATIC | CUBIC (безье второго и третьего порядка)
		 */
		public function FitLine(points:Array, coeff:Number=0.38, fitMode:String=QUADRATIC) 
		{
			_fitCoeff = coeff;
			_fitMode = fitMode;
			_srcPoints = points;
			calculateFitArray();
			_path=new Path(_fitPoints);
		}
		
		
		/**
		 * рисует в graphics кривую  по сглаженным точкам (с помощью curveTo)
		 * @param	: Graphics
		 */
		public function drawFitLine(graphics:Graphics):void
		{
			graphics.moveTo(Point(_fitPoints[0]).x, Point(_fitPoints[0]).y);
			for (var i:int = 1; i < _fitPoints.length-1; i+=2) 
			{
				var cPoint:Point = _fitPoints[i];
				var aPoint:Point = _fitPoints[i + 1];
				graphics.curveTo(cPoint.x, cPoint.y, aPoint.x, aPoint.y);
			}
		}
		/*=================================
		 * PRIVATE
		 * ==============================*/
		
		private function update():void
		{
			calculateFitArray();
			_path.points = _fitPoints;
			//_path.update();
		}
		 
		//расчет точек
		private function calculateFitArray():void
		{
			var i:int;
			var dir:Number;
			var dist:Number;
			_fitPoints = [_srcPoints[0]];
			if (_srcPoints.length < 2) 
			{
				_fitPoints = [];
				return;
			}else if (_srcPoints.length == 2)
			{
				_fitPoints[2] = _srcPoints[1];
				_fitPoints[1] = midLine(_srcPoints[0], _srcPoints[1]);
				return;
			}
			
			
			switch(fitMode)
			{
				case QUADRATIC:
					
					var cPoint:Point = Point.interpolate(new Point((3 * _srcPoints[1].x - _srcPoints[2].x) / 2, 
															(3 * _srcPoints[1].y - _srcPoints[2].y) / 2), 
												new Point((_srcPoints[0].x + _srcPoints[1].x) / 2, 
															(_srcPoints[0].y + _srcPoints[1].y) / 2), _fitCoeff);
				
					for (i = 1; i < _srcPoints.length - 1; i++)
					{
						_fitPoints.push(cPoint);
						_fitPoints.push(_srcPoints[i]);
						
						dist = _fitCoeff * Point.distance(_srcPoints[i], _srcPoints[i + 1]); 
						dir = Math.atan2(_srcPoints[i].y - cPoint.y, _srcPoints[i].x - cPoint.x);
						cPoint = new Point(_srcPoints[i].x + dist * Math.cos(dir), _srcPoints[i].y + dist * Math.sin(dir));
					}
					
					_fitPoints.push(cPoint);
					_fitPoints.push(_srcPoints[i]);
					break;
				
				case CUBIC:
					var af:Array = [_srcPoints[0]];
					var ab:Array = [null];
					for (i = 1; i < _srcPoints.length - 1; i++)
					{
						dir = Math.atan2(_srcPoints[i - 1].y - _srcPoints[i + 1].y, 
													_srcPoints[i - 1].x - _srcPoints[i + 1].x);
						dist = _fitCoeff * Point.distance(_srcPoints[i - 1], _srcPoints[i]);
						ab[i] = new Point(_srcPoints[i].x + dist * Math.cos(dir), _srcPoints[i].y + dist * Math.sin(dir));
						dist = _fitCoeff * Point.distance(_srcPoints[i + 1], _srcPoints[i]);
						dir += Math.PI;
						dist = _fitCoeff * Point.distance(_srcPoints[i + 1], _srcPoints[i]);
						af[i] = new Point(_srcPoints[i].x + dist * Math.cos(dir), _srcPoints[i].y + dist * Math.sin(dir));
					}
					ab.push(_srcPoints[_srcPoints.length - 1]);
					for (i = 0; i < _srcPoints.length - 1; i++)
					{
						addBezier (_fitPoints, _srcPoints[i], af[i], ab[i + 1], _srcPoints[i + 1]);
						
					}
					break;
			}
		}
		
		
		
		
		/*=============================================
		 * утитилиты для кубического сглаживания
		 * =========================================*/
		//пересечение отрезков
		private static function intersect2Lines(p1:Point, p2:Point, p3:Point, p4:Point):Point 
		{
			var x1:Number = p1.x, y1:Number = p1.y, x4:Number = p4.x, y4:Number = p4.y;
			var dx1:Number = p2.x - x1, dx2:Number = p3.x - x4;
			if (!(dx1 || dx2)) 
			{
				return null;
			}
			
			var m1:Number = (p2.y - y1) / dx1;
			var m2:Number = (p3.y - y4) / dx2;
			if (!dx1)
			{
				return new Point(x1, m2 * (x1 - x4) + y4);
			}else if (!dx2) 
			{
				return new Point(x4, m1 * (x4 - x1) + y1);
			}
			var xInt:Number = ( -m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2) || p1.x;
			var yInt:Number = m1 * (xInt - x1) + y1;
			return new Point(xInt, yInt);
		}
		
		//середина отрезка
		private static function midLine(a:Point, b:Point):Point {
			return new Point((a.x + b.x)/2, (a.y + b.y)/2);
		}
		
		private static function bezierSplit(p0:Point, p1:Point, p2:Point, p3:Point):Object {
			
			var p01:Point = midLine (p0, p1);
			var p12:Point = midLine (p1, p2);
			var p23:Point = midLine (p2, p3);
			var p02:Point = midLine (p01, p12);
			var p13:Point = midLine (p12, p23);
			var p03:Point = midLine (p02, p13);
			return {
				b0:{a:p0,  b:p01, c:p02, d:p03},
				b1:{a:p03, b:p13, c:p23, d:p3 }  
			}
		}
		//мельчим пока не впишемся в точность
		private static function addBezier(arr:Array, a:Point, b:Point, c:Point, d:Point):void 
		{
			
			var tolerance:int = 4;
			var s:Point = intersect2Lines(a, b, c, d);
			if (!s) return;
			var dx:Number = (a.x + d.x + s.x * 4 - (b.x + c.x) * 3)/8;
			var dy:Number = (a.y + d.y + s.y * 4 - (b.y + c.y) * 3)/8;
			if (dx*dx + dy*dy > tolerance) {
				var halves:Object = bezierSplit (a, b, c, d);
				var b0:Object = halves.b0; 
				var b1:Object = halves.b1;
				addBezier(arr, a, b0.b, b0.c, b0.d);
				addBezier(arr, b1.a,  b1.b, b1.c, d);
			} else 
			{
				arr.push(s);
				arr.push(d);
			}
		}
		
		/*=======================================
		 * GET|SET
		 * ======================================*/

		/**
		 * коэффициент подгонки, 0.05..0.95
		 */
		public function get fitCoeff():Number { return _fitCoeff; }
		public function set fitCoeff(value:Number):void 
		{
			if (value < 0.05) value = 0.05;
			if (value > 0.95) value = 0.95;
			_fitCoeff = value;
			update();
		}
		/**
		 * режим подгонки QUADRATIC | CUBIC (безье второго и третьего порядка)<br>
		 * (default=QUADRATIC)
		 */
		public function get fitMode():String { return _fitMode; }
		
		public function set fitMode(value:String):void 
		{
			
			if (_fitMode == value ) return;
			
			if (value != QUADRATIC && value != CUBIC)
			{
				throw(new Error("unsupported mode: " + value));
			}
			
			_fitMode = value;
			update();
		}
		
		/**
		 * массив  точек сглаженной кривой в стиле curveTo  [cX,cY,aX,aY,..,cX,cY]
		 */
		public function get fitPoints():Array { return _fitPoints; }
		
		/**
		 * массив исходных точек 
		 */
		public function set srcPoints(value:Array):void
		{
			_srcPoints = value;
			update();
		}
		/**
		 * Path сглаженной кривой
		 */
		public function get path():Path { return _path; }
		
		
		
	}
	
}