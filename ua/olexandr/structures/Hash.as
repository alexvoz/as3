package ua.olexandr.structures {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public dynamic class Hash extends Dictionary{
		
		/**
		 * Constructor
		 * @param	weakKeys
		 */
		public function Hash(weakKeys:Boolean = true) {
			super(weakKeys);
		}
		
		/**
		 * Добавить двусвязную пару key:value и value:key
		 * @param	key
		 * @param	value
		 */
		public function addPair(key:*, value:*):void {
			this[key] = value;
			this[value] = key;
		}
		
		/**
		 * Удалить двусвязную пару
		 * @param	obj
		 * @return
		 */
		public function removePair (obj:*):* {
			var _obj:* = this[obj];
			delete this[obj];
			delete this[_obj];
			return _obj;
		}
		
		
		/**
		 * Получить ключ по значению
		 * @param	value
		 * @return
		 */
		public function getKey(value:*):*{
			for (var i:Object in this) 
				if (this[i] == value) 
					return i;
			return null;
		}
		
		/**
		 * Получить значение по ключу
		 * @param	key
		 * @return
		 */
		public function getValue(key:*):*{
			return this[key];
		}
		
		/**
		 * Проверить, существует ли ключ
		 * @param	key
		 * @return
		 */
		public function hasKey(key:*):Boolean {
			return this[key];
        }
		
		/**
		 * Проверить, существует ли значение
		 * @param	value
		 * @return
		 */
        public function hasValue(value:*):Boolean {
			for (var i:Object in this)
				if (this[i] == value) 
                    return true;
            return false;
        }
		
		/**
		 * Проверить, пустой ли хеш
		 */
		public function isEmpty():Boolean {
			for (var i:Object in this) 
				return false;
			return true;
        }
		
		
		public function get length():int { 
			var _len:int = 0;
			for (var i:Object in this) 
				_len++;
			return _len;
		}
		
		/**
		 * 
		 * @return
		 */
		public function toMapString():String {
			var _result:String = '';
            for (var i:Object in this) 
                _result += i + '\t: ' + this[i] + '\n';
            return _result;
        }
		
		/**
		 * 
		 * @return
		 */
		public function toString():String {
			return "[Hash length=" + length + "]";
		}
	}

}