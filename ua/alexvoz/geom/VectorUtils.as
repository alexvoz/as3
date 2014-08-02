package ua.alexvoz.geom {
	import flash.geom.Point;
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class VectorUtils {
		
		public function VectorUtils() {
			
		}
		
		static public function returnVectorLength(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.sqrt(Math.pow((x2 - x1), 2) + Math.pow((y2 - y1), 2));
		}
		
		static public function returnVectorAngleDeg(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.atan2(y2 - y2, x2 - x1) * 180 / Math.PI;
		}
		
		static public function returnVectorAngleRad(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.atan2(y2 - y2, x2 - x1);
		}
		
		static public function returnXYtoVector(x:Number, y:Number, length:Number, angle:Number = NaN, angleIsRad:Boolean = false):Point {
			if (!angleRad) angle = angle * Math.PI / 180;
			x += Math.abs(length) * Math.cos(angle);
			y += Math.abs(length) * Math.sin(angle);
			return new Point(x, y);
		}
		
	}

}