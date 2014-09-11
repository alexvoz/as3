/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.geom
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author silin
	 */
	public class CatmullRom 
	{
		public function CatmullRom()
		{
			throw(new Error("CatmullRom is static"));
		}
		/**
		 * считает массив сглаженных точек
		 * @param	points			массив исходных точек
		 * @param	loop			закольцованность
		 * @param	iterations		число итераций на сегмент
		 * @return
		 */
		public  static function spline(controlPoints:Array/*Point*/, 
										loop:Boolean = false, 
										iterations:int = 16):Array/*Point*/
		{
			var i:int;
			var result:Array = [];
			var arr:Array = controlPoints.concat();
			var len:int = loop ? arr.length : arr.length - 1;
			if (iterations < 1) iterations = 1;
			
			if (!loop)
			{
				arr.unshift(arr[0]);
				arr.push(arr[arr.length - 1]);
			}
			
			var step:Number = 1 / iterations;
			
			for (i = 0; i < len; i++)
			{ 
				var p0:Point = arr[i];
				var p1:Point = arr[(i + 1) % arr.length];
				var p2:Point = arr[(i + 2) % arr.length];
				var p3:Point = arr[(i + 3) % arr.length];
				
				// вариант счета с приблизительно равным расстоянием между  точками
				// не кошерно смотрится, если надо что-то равномерное, тогда
				//var tol:Number = 4;
				//step = tol / Point.distance(p1, p2);
				
				for (var t:Number = 0; t < 1; t += step)
				{ 	
					
					var t2:Number = t * t;
					var t3:Number = t2 * t;
					var tX:Number = 0.5 * ((2 * p1.x) + ( -p0.x + p2.x) * t + 
									(2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 + 
									( -p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3);
					var tY:Number = 0.5 * ((2 * p1.y) + ( -p0.y + p2.y) * t + 
									(2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 + 
									( -p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3);
					result.push(new Point(tX, tY));
				}
			}
			
			tX = 0.5 * ((2 * p1.x) + ( -p0.x + p2.x) + 
				(2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) + 
				( -p0.x + 3 * p1.x - 3 * p2.x + p3.x));
			tY = 0.5 * ((2 * p1.y) + ( -p0.y + p2.y) + 
				(2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) + 
				( -p0.y + 3 * p1.y - 3 * p2.y + p3.y));
			result.push(new Point(tX, tY));
				
			return result;
			//trace( "result : " + result.length );
			//return simplifyRadialDist(result);
			
		}
		
		public static function  simplifyRadialDist(points:Array/*Point*/, tolerance:Number=8):Array/*Point*/ {

			var prevPoint:Point = points[0];
			var newPoints:Array/*Point*/ = [prevPoint];
			var len:int = points.length;
			var	i:int;
			var	point:Point;

			for (i = 1; i < len; i += 1) {
				point = points[i];
				if (Point.distance(point, prevPoint) > tolerance) {
					newPoints.push(point);
					prevPoint = point;
				}
			}

			if (prevPoint !== point) {
				newPoints.push(point);
			}
			trace( "newPoints : " + newPoints.length );
			return newPoints;
			
		}

		
		/*
		public static function DouglasPeucker(PointList:Array, epsilon:Number):Array
		{
			var res:Array = [];
			
			return res;
		}
		*/
	}

}

/*

function DouglasPeucker(PointList[], epsilon)
 //Находим точку с максимальным расстоянием от прямой между первой и последней точками набора
 dmax = 0
 index = 0
 for i = 2 to (length(PointList) - 1)
  d = PerpendicularDistance(PointList[i], Line(PointList[1], PointList[end])) 
  if d > dmax
   index = i
   dmax = d
  end
 end
 
 //Если максимальная дистанция больше, чем epsilon, то рекурсивно вызываем её на участках
 if dmax >= epsilon
  //Recursive call
  recResults1[] = DouglasPeucker(PointList[1...index], epsilon)
  recResults2[] = DouglasPeucker(PointList[index...end], epsilon)
  
  // Строим итоговый набор точек
  ResultList[] = {recResults1[1...end-1] recResults2[1...end]}
 else
  ResultList[] = {PointList[1], PointList[end]}
 end
 
 // Возвращаем результат
 return ResultList[]
end

*/