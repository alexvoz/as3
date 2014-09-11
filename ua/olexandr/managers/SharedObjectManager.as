package ua.olexandr.managers {
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class SharedObjectManager {
		
		private var _so:SharedObject;
		
		public function SharedObjectManager(name:String, local:String = null, secure:Boolean = false) {
			_so = SharedObject.getLocal(name, local, secure);
		}
		
		/**
		 * Получить значение
		 * @param	name
		 * @return
		 */
		public function get(name:String):* {
			if (!has(name)) 
				return null;
			return _so.data[name];
		}
		
		/**
		 * Записать значение
		 * @param	name
		 * @param	value
		 */
		public function flush(name:String, value:*):void {
			_so.data[name] = value;
			_so.flush();
		}
		
		/**
		 * Проверить наличие свойства
		 * @param	name
		 * @return
		 */
		public function has(name:String):Boolean {
			return _so.data.hasOwnProperty(name);
		}
		
		/**
		 * Очистить
		 */
		public function clear():void {
			_so.clear();
		}
		
	}

}