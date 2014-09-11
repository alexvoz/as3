package ua.olexandr.utils {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import ua.olexandr.geom.Circle;
	import flash.geom.Point;
	
	public class IntersectionUtils {
		
		/**
		 * пересекаются ли 2 объекта
		 * @see		http://www.mikechambers.com/blog/2009/06/24/using-bitmapdata-hittest-for-collision-detection/
		 * @param	dObj0
		 * @param	dObj1
		 * @param	threshold
		 * @return
		 */
		[Inline]
		public static function hitTest(dObj1:DisplayObject, dObj2:DisplayObject, threshold:Number = 255):Boolean {
			if (!dObj1.stage || !dObj2.stage)
				throw new Error("Both objects must be added in display list");
			
			var boundsIn1:Rectangle = dObj1.getBounds(dObj1);
			var boundsOut1:Rectangle = dObj1.getBounds(dObj1.stage);
			
			var matrix1:Matrix = dObj1.transform.matrix.clone();
			matrix1.tx = -boundsIn1.x;
			matrix1.ty = -boundsIn1.y;
			
			var bmpData1:BitmapData = new BitmapData(boundsOut1.width, boundsOut1.height, true, 0);
			bmpData1.draw(dObj1, matrix1);
			
			var point1:Point = new Point(boundsOut1.x, boundsOut1.y);
			
			
			var boundsIn2:Rectangle = dObj2.getBounds(dObj2);
			var boundsOut2:Rectangle = dObj2.getBounds(dObj2.stage);
			
			var matrix2:Matrix = dObj2.transform.matrix.clone();
			matrix2.tx = -boundsIn2.x;
			matrix2.ty = -boundsIn2.y;
			
			var bmpData2:BitmapData = new BitmapData(boundsOut2.width, boundsOut2.height, true, 0);
			bmpData2.draw(dObj2, matrix2);
			
			var point2:Point = new Point(boundsOut2.x, boundsOut2.y);
			
			
			var hit:Boolean = bmpData1.hitTest(point1, threshold, bmpData2, point2, threshold);
			
			
			bmpData1.dispose();
			bmpData2.dispose();
			
			
			return hit;
		}
		
		/**
		 * пересекаются ли два круга
		 */
		[Inline]
		public static function circleToCircle(c1:Circle, c2:Circle):Boolean {
			return (c1.radius + c2.radius) * (c1.radius + c2.radius) <=
				((c1.x - c2.x) * (c1.x - c2.x)) + ((c1.y - c2.y) * (c1.y - c2.y));
		}
		
		/**
		 * пересекаются ли точка с кругом
		 */
		[Inline]
		public static function pointToCircle(point:Point, circle:Circle):Boolean {
			return (circle.radius * circle.radius) >
				(point.x - circle.x) * (point.x - circle.x) + (point.y - circle.y) * (point.y - circle.y);
		}
		
		/**
		 * пересекаются ли две линии 
		 */
		[Inline]
		public static function lineToLine(p11:Point, p12:Point, p21:Point, p22:Point):Boolean {
			// решаем систему методом Крамера
			var _d:Number = (p12.x - p11.x) * (p21.y - p22.y) - (p21.x - p22.x) * (p12.y - p11.y);
			
			if (_d == 0) 
				return false; // Отрезки либо параллельны, либо полностью/частично совпадают
			
			var _d1:Number = (p21.x - p11.x) * (p21.y - p22.y) - (p21.x - p22.x) * (p21.y - p11.y);
			var _d2:Number = (p12.x - p11.x) * (p21.y - p11.y) - (p21.x - p11.x) * (p12.y - p11.y);
			
			var _t1:Number = _d1 / _d;
			var _t2:Number = _d2 / _d;
			
			return _t1 >= 0 && _t1 <= 1 && _t2 >= 0 && _t2 <= 1;
		}
		
		
		
		/**
		 * Проверка пересечения двух линий
		 * @param	p1
		 * @param	p2
		 * @param	p3
		 * @param	p4
		 * @return
		 */
		/*public static function intersectLines(p1:Point, p2:Point, p3:Point, p4:Point):Point {
			var x1:Number = p1.x;
			var y1:Number = p1.y;
			var x4:Number = p4.x;
			var y4:Number = p4.y;
			
			var dx1:Number = p2.x - x1;
			var dx2:Number = p3.x - x4;
			
			if (!dx1 && !dx2)
				return null;
			
			var m1:Number = (p2.y - y1) / dx1;
			var m2:Number = (p3.y - y4) / dx2;
			
			if (!dx1)
				return new Point(x1, m2 * (x1 - x4) + y4);
			
			if (!dx2)
				return new Point(x4, m1 * (x4 - x1) + y1);
			
			var xInt:Number = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2);
			var yInt:Number = m1 * (xInt - x1) + y1;
			
			return new Point(xInt, yInt);
		}*/
	
	}
}