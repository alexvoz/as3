package ua.olexandr.utils {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class GeomUtils{
		
		/**
		 * Перевод из полярной системы в декартовую
		 * @param	length
		 * @param	angle
		 * @return
		 */
		[Inline]
		public static function polarToCartesian(length:Number, angle:Number):Point {
			//return (Point.polar(rad, degreesToRadians(theta)));     
			
			var _point:Point = new Point();
			_point.x = length * Math.cos(angle)
			_point.y = length * Math.sin(angle)
			return _point;
		}
		
		/**
		 * Перевод из градусов в радианы
		 * @param	degrees радианы
		 * @return радианы
		 */
		[Inline]
		public static function degreesToRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		
		/**
		 * Перевод из радиан в градусы
		 * @param	radians радианы
		 * @return градусы
		 */
		[Inline]
		public static function radiansToDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		
		/**
		 * Возвращает угол в радианах между двумя точками
		 * @param	p1
		 * @param	p2
		 * @return
		 */
		[Inline]
		public static function getRadiansBetweenPoints(p1:Point, p2:Point):Number {
			return Math.atan2(p2.y - p1.y, p2.x - p1.x);
		}
		
		/**
		 * Возвращает угол в градусах между двумя точками
		 * @param	p1
		 * @param	p2
		 * @return
		 */
		[Inline]
		public static function getDegreesBetweenPoints(p1:Point, p2:Point):Number {
			return radiansToDegrees(getRadiansBetweenPoints(p1, p2));
		}
		
		
		/**
		 * Возвращает короткий угол в радианах между двумя углами
		 * @param	angleFrom радианы
		 * @param	angleTo радианы
		 * @return радианы
		 */
		[Inline]
		public static function getShortestRadians(angleFrom:Number, angleDelta:Number):Number {
			var _delta:Number = angleDelta - angleFrom;
			return Math.atan2(Math.sin(_delta), Math.cos(_delta));
		}      
		
		/**
		 * Возвращает короткий угол в градусах между двумя углами
		 * @param	angleFrom градусы
		 * @param	angleTo градусы
		 * @return радианы
		 */
		[Inline]
		public static function getShortestDegrees(angleFrom:Number, angleDelta:Number):Number {
			var _af:Number = degreesToRadians(angleFrom);
			var _at:Number = degreesToRadians(angleDelta);
			
			return radiansToDegrees(getShortestRadians(_af, _at));
		}      
		
	}
}