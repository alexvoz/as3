package ua.olexandr.structures {
	
	/**
	 * @author Olexandr Fedorow
	 */
	public class Range {
		
		private var _values:Array;
		
		private var _min:Number;
		private var _max:Number;
		
		/**
		 * Constructor
		 */
		public function Range() {
			_values = [];
			_max = Number.NEGATIVE_INFINITY;
			_min = Number.POSITIVE_INFINITY;
		}
		
		/**
		 * Добавить значение
		 * @param	value
		 */
		public function add(value:Number):void {
			if (isNaN(value))
				throw new Error('Range: someone added a NaN-value');
			
			_values.push(value);
			
			if (_min > value)
				_min = value;
				
			if (_max < value)
				_max = value;
		}
		
		/**
		 * Входит ли значение в диапазон
		 * @param	value
		 * @param	equals
		 * @return
		 */
		public function check(value:Number, equals:Boolean = false):Boolean {
			if (equals)
				return (value >= _min && value <= _max);
			
			return (value > _min && value < _max);
		}
		
		/**
		 * Получить отношение значения ко всему диапазону
		 * @param	value
		 * @return
		 */
		public function ratio(value:Number):Number {
			return (value - _min) / range;
		}
		
		/**
		 * 
		 * @param	v
		 * @return
		 */
		public function sqrtRatio(v:Number):Number {
			return Math.sqrt(ratio(v));
		}
		
		/**
		 * 
		 * @param	v
		 * @param	rad
		 * @return
		 */
		public function rootRatio(v:Number, rad:Number):Number {
			return Math.pow(ratio(v), 1 / rad);
		}
		
		/**
		 * Диапазон данных
		 */
		public function get range():Number { return _max - _min; }
		
		public function get max():Number { return _max; }
		
		public function get min():Number { return _min; }
		
		/**
		 * Returns a string containing all the properties of the Range object.
		 * @return
		 */
		public function toString():String {
			return "[Range min=" + _min + " max=" + _max + "]";
		}
		
		
	}

}

