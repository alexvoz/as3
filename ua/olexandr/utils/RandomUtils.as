package ua.olexandr.utils {
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class RandomUtils {
		
		/**
		 * Получить случайное число
		 * @param	min
		 * @param	max
		 * @return
		 */
		[Inline]
		public static function getNumber(min:Number = 0, max:Number = 1):Number {
			return random() * (max - min) + min;
		}
		
		/**
		 * Получить случайное целое
		 * @param	min
		 * @param	max
		 * @return
		 */
		[Inline]
		public static function getInt(min:int = 0, max:int = 1):int {
			//return Math.round(getNumber(min, max));
			return Math.floor(getNumber(min, max + 1));
		}
		
		/**
		 * Получить случайное булево значение
		 * @param	chance
		 * @return
		 */
		[Inline]
		public static function getBoolean(chance:Number = .5):Boolean {
			return random() < chance;
		}
		
		/**
		 * получить случайный цвет
		 * @return
		 */
		[Inline]
		public static function getColor():uint {
			return getInt(0x000000, 0xFFFFFF);
		}
		
		/**
		 * получить случайный элемент массива
		 * @param	arr
		 * @return
		 */
		[Inline]
		public static function getElement(arr:Array):* {
			return arr[getInt(0, arr.length - 1)];
		}
		
		/**
		 * получить случайную точку
		 * @param	minX
		 * @param	minY
		 * @param	maxX
		 * @param	maxY
		 * @return
		 */
		[Inline]
		public static function getPoint(minX:int, minY:int, maxX:int, maxY:int):Point {
			return new Point(getInt(minX, maxX), getInt(minY, maxY));
		}
		
		/**
		 * Использовать ли нативный рандом
		 */
		public static var useAdobeMath:Boolean = true;
		
		private static const MAX_RATIO:Number = 1 / uint.MAX_VALUE;
		private static var _random:uint = getTimer();
		
		[Inline]
		private static function random():Number {
			if (useAdobeMath)
				return Math.random();
			
			_random ^= (_random << 21);
			_random ^= (_random >>> 35);
			_random ^= (_random << 4);
			return (_random * MAX_RATIO);
		}
		
		
	}

}