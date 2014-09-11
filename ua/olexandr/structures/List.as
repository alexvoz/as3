package ua.olexandr.structures {
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public dynamic class List extends Array {
		
		private var _current:int;
		
		/**
		 * 
		 * @param	arr
		 */
		public function List(arr:Array = null) {
			if (arr) {
				var _len:int = arr.length;
				for (var i:int = 0; i < _len; i++)
					this[i] = arr[i];
			}
			
			_current = -1;
		}
		
		/**
		 * 
		 * @return
		 */
		public function hasNext():Boolean {
			return _current < length - 1;
		}
		
		/**
		 * 
		 * @return
		 */
		public function hasPrevious():Boolean {
			return _current > 0;
		}
		
		/**
		 * 
		 */
		public function get previous():Object {
			--_current;
			if (_current == -1)
				return null;
			return current;
		}
		
		/**
		 * 
		 */
		public function get next():Object {
			++_current;
			if (_current == length) {
				_current = -1;
				return null;
			}
			return current;
		}
		
		/**
		 * 
		 */
		public function get current():Object {
			if (_current == -1)
				return null;
			return this[_current];
		}
		
		
		/**
		 * 
		 */
		public function reset():void {
			_current = -1;
		}
		
		/**
		 * 
		 * @param	func
		 */
		public function apply(func:Function):void {
			reset();
			
			while (hasNext())
				func(next);
		}
		
		
	}

}
