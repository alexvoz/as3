package ua.olexandr.utils {
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class MathUtils {
		
		public static const HALF_PI:Number = Math.PI * .5;
		public static const TWO_PI:Number = Math.PI * 2;
		
		/**
		 * 
		 * @param	str
		 * @param	integer
		 * @return
		 */
		[Inline]
		public static function parse(str:String, integer:Boolean = false):Number {
			var _int:Boolean = integer;
			var _str:String = '';
			var _arr:Array = str.split('');
			while (_arr.length) {
				var _char:String = _arr.shift();
				if (!_int && _char == '.' || _char == ',') {
					_int = true;
					_str += '.';
				} else if (!isNaN(Number(_char))) {
					_str += _char;
				}
			}
			
			return Number(_str);
		}
		
		/**
		 * определить четность числа
		 */
		[Inline]
		public static function isEven(num:Number):Boolean {
			//return (num % 2 == 0);
			return (num & 1) == 0;
		}
		
		/**
		 * определить нечетность числа
		 */
		[Inline]
		public static function isOdd(num:Number):Boolean {
			return (num & 1) == 1;
		}
		
		/**
		 * Получить знак числа
		 * @param	number
		 * @return
		 */
		[Inline]
		public static function getSign(num:Number):Number {
			if (num == 0)
				return num;
			
			return num > 0 ? 1 : -1;
		}
		
		/**
		 * Округлить дробное число num до count знаков после запятой
		 */
		[Inline]
		public static function round(num:Number, count:int):Number {
			var _d:Number = Math.pow(10, count);
			return Math.round(num * _d) / _d;
		}
		
		/**
		 * Суммировать все числа из массива
		 * @param	arr
		 * @return
		 */
		[Inline]
		public static function sum(arr:Array):Number {
			var _res:Number = 0;
			
			var _len:int = arr.length;
			for (var i:int = 0; i < _len; i++) {
				if (!isNaN(arr[i]))
					_res += arr[i];
			}
			
			return _res;
		}
		
		/**
		 * Находится ли Num в диапазоне min..max
		 */
		[Inline]
		public static function inRange(value:Number, min:Number, max:Number):Boolean {
			return ((value > min) && (value < max));
		}
		
		/**
		 * Получить ближайшие число к arg - val1 или val2
		 */
		[Inline]
		public static function getClosest(arg:Number, val1:Number, val2:Number):Number {
			if (arg - val1 > 0 ? arg - val1 : -(arg - val1) < arg - val2 > 0 ? arg - val2 : -(arg - val2))
				return val1;
			return val2;
		}
		
		/**
		 * Равны ли числа val1 и val2 с заданной погрешностью aprox
		 */
		[Inline]
		public static function aproxEqual(val1:Number, val2:Number, aprox:Number = .00001):Boolean {
			return Math.abs(val2 - val1) <= aprox;
		}
		
		/**
		 * Перевести число value из диапазона a..b в диапазон c..d
		 */
		[Inline]
		public static function remapVal(value:Number, a:Number, b:Number, c:Number, d:Number):Number {
			return c + (d - c) * (value - a) / (b - a);
		}
		
		/**
		 * Получить число из диапазона cx..cy, зависящей от коэфициента s.
		 * если s=0.0 то возвращается cx.
		 * если s=1.0 то возвращается cy.
		 */
		[Inline]
		public static function lerp(cx:Number, cy:Number, s:Number):Number {
			return cx + s * (cy - cx);
		}
		
		/**
		 * ограничить число интервалом min..max
		 */
		[Inline]
		public static function limit(value:Number, min:Number, max:Number):Number {
			return value < min ? min : (value > max ? max : value);
		}
		
		/**
		 * получить среднее арифметическое
		 */
		[Inline]
		public static function average(... args):Number {
			var _len:int = args.length;
			var _res:Number = 0;
			for (var i:int = 0; i < _len; i++)
				_res += args[i];
			return _res / _len;
		}
		
		/**
		 * получить факториал
		 */
		[Inline]
		public static function factorial(value:int):int {
			return (value <= 1) ? 1 : value * factorial(value - 1);
		}
		
		
		/**
		 * Гиперболический синус
		 */
		[Inline]
		public static function sinh(x:Number):Number {
			return (Math.pow(Math.E, x) - Math.pow(Math.E, -x)) * .5;
		}
		
		/**
		 * Гиперболический косинус
		 */
		[Inline]
		public static function cosh(x:Number):Number {
			return (Math.pow(Math.E, x) + Math.pow(Math.E, -x)) * .5;
		}
		
		/**
		 * Гиперболический тангенс
		 */
		[Inline]
		public static function tanh(x:Number):Number {
			//return sinh(x) / cosh(x);
			return (Math.pow(Math.E, 2 * x) - 1) / (Math.pow(Math.E, 2 * x) + 1);
		}
		
		/**
		 * Гиперболический котангенс
		 */
		[Inline]
		public static function coth(x:Number):Number {
			return 1 / tanh(x);
		}
		
	}

}