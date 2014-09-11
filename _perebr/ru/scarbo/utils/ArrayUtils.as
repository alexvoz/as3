package ru.scarbo.utils 
{
	/**
	 * ...
	 * @author scarbo
	 */
	public class ArrayUtils
	{
		private static var obj:Object = { };
		
		/**
		 * @example				:проверяет равенство 2 массивов
		 */
		public static function isEqual(a:Array, b:Array):Boolean {
			if (a.length != b.length) return false;
			var length:uint = a.length;
			for (var i:uint = 0; i < length; i++) {
				if (a[i] !== b[i]) return false;
			}
			return true;
		}
		
		/**
		 * @example				:проверяет наличие эелемента в массиве
		 */
		public static function isValue(arr:Array, value:Object):Boolean {
			return (arr.indexOf(value) != -1);
		}
		
		/**
		 * @example				:удаляет элемент из массива
		 */
		public static function remove(arr:Array, value:Object):Array {
			var length:uint = arr.length;
			for (var i:int = length; i > -1; i--) {
				if (arr[i] === value) arr.splice(i, 1);
			}
			return arr;
		}
		
		/**
		 * @example				:удаляет дубликаты
		 */
		public static function unique(arr:Array):Array {
			obj = { };
			arr = arr.filter(uniqueFunc);
			obj = null;
			return arr;
		}
		private static function uniqueFunc(item:*, index:int, array:Array):Boolean {
			return obj[item] ? false : obj[item] = true;
		}
		
		/**
		 * @example				:удаляет дубликаты, порядок не сохраняется(работает быстрее)
		 */
		public static function uniqueHash(arr:Array):Object {
			obj = { };
			var length:uint = arr.length;
			for (var i:uint = 0; i < length; i++) {
				obj[arr[i]] = i;
			}
			return obj;
		}
		
	}

}