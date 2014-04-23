package ua.alexvoz.utils {
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class RndGenerator {
		
		public function RndGenerator() {
			
		}
		
		/**
		 * Генерирует значение, которого нет в указанном массиве 
		 */
		public static function generateValueNotInArray(from:int = 0, to:int = 0, arr:Array = null):int {
			var _rnd:int;
			do _rnd = from + Math.round(Math.random() * (to - from));
				while (arr.indexOf(_rnd) != -1);
			return _rnd;
		}
		
		/**
		* Генерирует последовательность случайных уникальных (без повторений) значений
		*/
		public static function generateSequenceWithoutDuplicates(from:int = 0, to:int = 0, count:int = 0):Array {
			var _rnd:int;
			var _arr:Array = [];
			var _fl:Boolean;
			for (var i:int = 0; i < count; i++) {
				do _rnd = from + Math.round(Math.random() * (to - from));
					while (_arr.indexOf(_rnd) != -1);
				_arr.push(_rnd);
			}
			return _arr;
		}
		
		//public static function generateSequenceWithoutDuplicatesNotSeries(from:int = 0, to:int = 0, count:int = 0):Array {
			//var _rnd:int;
			//var _arr:Array = [];
			//var _fl:Boolean;
			//_rnd = from + Math.round(Math.random() * (to - from));
			//_arr.push(_rnd);
			//for (var i:int = 1; i < count; i++) {
				//do {
					//_fl = false;
					//_rnd = from + Math.round(Math.random() * (to - from));
					//for (var j:int = 0; j < _arr.length; j++) 
						//if (_rnd == _arr[j] || Math.abs(_rnd - _arr[j]) == 1) _fl = true;
				//} while (_fl);
				//_arr.push(_rnd);
			//}
			//return _arr;
		//}
		
		/** 
		 * Генерирует последовательность случайных велечин, в которой соседние элементы не повторяются
		 */ 
		public static function generateSequenceNotSeries(from:int = 0, to:int = 0, count:int = 0):Array {
			var _rnd:int;
			var _arr:Array = [];
			_rnd = from + Math.round(Math.random() * (to - from));
			_arr.push(_rnd);
			for (var i:int = 0; i < count - 1; i++) {
				do _rnd = from + Math.round(Math.random() * (to - from))
					while (_rnd == _arr[_arr.length - 1]);
				_arr.push(_rnd);
			}
			return _arr;
		}
		
		/**
		 * Генерирует последовательность случайных величин
		 */ 
		public static function generateSequence(from:int = 0, to:int = 0, count:int = 0):Array {
			var _rnd:int;
			var _arr:Array = [];
			for (var i:int = 0; i < count; i++) {
				_rnd = from + Math.round(Math.random() * (to - from));
				_arr.push(_rnd);
			}
			return _arr;
		}
		
		/**
		 * Генерирует случайную величину, отличное от второго параметра
		 */ 
		public static function generateValue(from:int = 0, to:int = 0, value:int = 0):int {
			var _rnd:int;
			do _rnd = from + Math.round(Math.random() * (to - from));
				while (_rnd == value);
			return _rnd;
		}
		
		/**
		 * Сортирует целочисленный массив по возрастанию
		 */ 
		public static function sortIntArray(a:Array):Array {
			var _fl:Boolean;
			var _arr:Array = a;
			do {
				_fl = false
				for (var i:int = 0; i < _arr.length - 1; i++) {
					//trace(_arr[i] , _arr[i + 1])
					if (_arr[i] > _arr[i + 1]) {
						var _tmp:int = _arr[i];
						_arr[i] = _arr[i + 1];
						_arr[i + 1] = _tmp;
						_fl = true;
					}
					//trace(_arr[i] , _arr[i + 1]);
				}
			} while (_fl);
			return _arr;
		}
		
	}

}
