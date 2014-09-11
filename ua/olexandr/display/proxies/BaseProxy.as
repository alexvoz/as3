package ua.olexandr.display.proxies {
	import flash.events.EventDispatcher;
	
	public class BaseProxy extends EventDispatcher {
		
		private var _source:*;
		
		public function get source():* {
			return _source;
		}
		
		/**
		 * Constructor
		 * @param	source
		 */
		public function BaseProxy(source:*) {
			_source = source;
		}
		
		public function setProperties(properties:Object):void{
			for (var key:String in properties)
				_source[key] = properties[key];
		}
		
	}
}
