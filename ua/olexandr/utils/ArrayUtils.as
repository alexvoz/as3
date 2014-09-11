package ua.olexandr.utils {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class ArrayUtils {
		
		/**
		 * Сравнить два массива
		 * @param	a
		 * @param	b
		 * @return
		 */
		[Inline]
		public static function isEqual(a:Array, b:Array):Boolean {
			if (a.length != b.length)
				return false;
			
			var _len:int = a.length;
			for (var i:int = 0; i < _len; i++) {
				if (a[i] !== b[i])
					return false;
			}
			
			return true;
		}
		
		
		/**
		 * Получить случайные элементы из массива. Исходный массив не изменяется
		 * @param	arr
		 * @param	count
		 * @return
		 */
		[Inline]
		public static function getRandom(arr:Array, count:int = 1):Array {
			if (arr.length < count) 
				return null;
			
			var _arrSource:Array = arr.concat();
			var _arrResult:Array = [];
			
			while (_arrResult.length < count) {
				var _index:int = Math.floor(Math.random() * (_arrSource.length));
				_arrResult[_arrResult.length] = _arrSource.splice(_index, 1)[0];
			}
			
			return _arrResult;
		}
		
		/**
		 * Получить массив значений поля заданного массива
		 * @param	arr
		 * @param	field
		 * @return
		 */
		[Inline]
		public static function getFieldValues(arr:Array, field:String):Array {
			var _arr:Array = [];
			var _len:int = arr.length;
			for (var i:int = 0; i < _len; i++)
				_arr[i] = arr[i][field];
			
			return _arr;
		}
		
		/**
		 * Получить массив неповторяющихся элементов из заданного массива. Исходный массив не изменяется
		 * @param	arr
		 * @return
		 */
		[Inline]
		public static function getUnique(arr:Array):Array {
			var obj:Dictionary = new Dictionary(true);
			
			return (arr.concat()).filter(function (item:*, index:int, array:Array):Boolean {
				return obj[item] ? false : obj[item] = true;
			});;
		}
		
		/**
		 * Удалить все вхождения элемента в массив. Изменяется исходный массив
		 * @param	arr
		 * @param	value
		 * @return	массив удаленных элементов
		 */
		[Inline]
		public static function removeValue(arr:Array, value:*):Array {
			var _removed:Array = [];
			var _len:uint = arr.length;
			
			for (var i:int = _len - 1; i > -1; i--) {
				if (arr[i] == value) {
					_removed.push(arr[i]);
					arr.splice(i, 1);
				}
			}
			
			return _removed;
		}
		
		/**
		 * Удалить все вхождения элементов в массив. Изменяется исходный массив
		 * @param	arr
		 * @param	values
		 * @return	массив удаленных элементов
		 */
		[Inline]
		public static function removeValues(arr:Array, values:Array):Array {
			var _removed:Array = [];
			var _lenA:int = arr.length;
			var _lenV:int = values.length;
			
			for (var i:int = _lenA - 1; i > -1; i--) {
				for (var j:int = 0; j < _lenV; j++) {
					if (arr[i] == values[j]) {
						_removed.push(arr[i]);
						arr.splice(i, 1);
					}
				}
			}
			
			return _removed;
		}
		
		/**
		 * Перемешать массив. Изменяется исходный массив
		 * @param	arr
		 * @return
		 */
		[Inline]
		public static function shuffle(arr:Array):void {
			/*arr.sort(function (a:*, b:*):int {
				return Math.random() > .5 ? -1 : 1;
			} );*/
			
			var _len:int = arr.length;
			for (var i:int = 0; i < _len; i++)
				swap(arr, i, i + Math.round(Math.random() * (_len - 1 - i)));
				//swap(arr, i, Math.round(Math.random() * (_len - 1)));
		}
		
		/**
		 * Проверить, содержит ли массив заданный элемент
		 * @param	arr
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function contains(arr:Array, value:*):Boolean {
			 return (arr.indexOf(value) != -1);
		}
		
		/**
		 * Создать массив, заполненный числами от min до max с шагом step
		 * @param	min
		 * @param	max
		 * @param	step
		 * @return
		 */
		[Inline]
		public static function range(min:Number, max:Number, step:Number = 1):Array {
			var _arr:Array = [];
			for (var i:Number = min; i < max; i = i + step)
				_arr[_arr.length] = i;
			
			return _arr;
		}
		
		/**
		 * Поменять местами два элемента массива. Изменяется исходный массив
		 * @param	arr
		 * @param	i
		 * @param	j
		 * @return
		 */
		[Inline]
		public static function swap(arr:Array, i:int, j:int):void {
			var _a:* = arr[i];
			var _b:* = arr[j];
			
			arr.splice(i, 1, _b);
			arr.splice(j, 1, _a);
		}
		
		/**
		 * Создать массив заданной длины, заполненный одним элементом
		 * @param	value
		 * @param	len
		 * @return
		 */
		[Inline]
		public static function fill(value:*, len:int):Array {
			var _arr:Array = [];
			
			while (len-- > 0)
			  _arr[_arr.length] = value;
			  
			return _arr;
		}
		
	}

}