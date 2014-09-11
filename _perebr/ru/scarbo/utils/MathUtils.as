package ru.scarbo.utils 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author scarbo
	 */
	public class MathUtils
	{
		public static const DEG_TO_RAD:Number = 0.0174533;
        public static const RAD_TO_DEG:Number = 57.2958;
		
		/**
		 * @example            :преобразует градусы в радианы
		 */
		public static function toRadian(value:Number):Number {
			return value * DEG_TO_RAD;
		}
		
		/**
		 * @example            :преобразует радианы в градусы
		 */
		public static function toDegree(value:Number):Number {
			return value * RAD_TO_DEG;
		}
		
		/**
		 * @example           :возвращает расстояние от точки А до точки B
		 */
		public static function getDistance(toPoint:Point, fromPoint:Point):Number {
			return Point.distance(toPoint,fromPoint);
		}
		
		/**
		 * @example           :возвращает координаты точки на окружности
		 */
		public static function getVector(angle:Number, length:Number):Point {
			var angleR:Number = toRadian(angle);
			return Point.polar(length, angle);
		}
		
		
		public static function getMIN(value:Array):Number {
			var result:Object = { };
			if (_isStat(value, result)) {
				var val:Number = value[0];
				for (var i:uint = 0; i < result.value; i++) {
					val = Math.min(val, value[i]);
				}
				return val;
			}else {
				return result.value;
			}
		}
		
		public static function getMAX(value:Array):Number {
			var result:Object = { };
			if (_isStat(value, result)) {
				var val:Number = value[0];
				for (var i:uint = 0; i < result.value; i++) {
					val = Math.max(val, value[i]);
				}
				return val;
			}else {
				return result.value;
			}
		}
		
		public static function getSUM(value:Array):Number {
			var result:Object = { };
			if (_isStat(value, result)) {
				var val:Number = 0;
				for (var i:uint = 0; i < result.value; i++) {
					val += value[i];
				}
				return val;
			}else {
				return result.value;
			}
		}
		
		public static function getAVG(value:Array):Number {
			var result:Object = { };
			if (_isStat(value, result)) {
				return getSUM(value) / result.value;
			}else {
				return result.value;
			}
		}
		
		public static function getPER(value:Array, precent:Number):Number {
			var result:Object = { };
			if (_isStat(value, result)) {
				var val:Number;
				var all:Number = (result.value - 1) * precent;
				var integer:int = int(all);
				var float:Number = all - integer;
				value.sort(Array.NUMERIC);
				if (float is int) {
					val = value[integer];
				}else {
					if (result.value > integer + 1) {
						val = float * (value[integer + 1] - value[integer]) + value[integer];
					}else {
						val = value[integer];
					}
				}
				return val;
			}else {
				return result.value;
			}
		}
		
		public static function getLOWQ(value:Array):Number {
			return getPER(value, .25);
		}
		
		public static function getMED(value:Array):Number {
			return getPER(value, .5);
		}
		
		public static function getHIQ(value:Array):Number {
			return getPER(value, .75);
		}
		
		private static function _isStat(value:Array, result:Object):Boolean {
			var length:uint = value.length;
			if (length > 1) {
				result.value = length;
				return true;
			}
			else if (length == 1) {
				result.value = value[0];
				return false;
			}else {
				result.value = NaN;
				return false;
			}
		}
	}

}