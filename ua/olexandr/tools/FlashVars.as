package ua.olexandr.tools {
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	
	final public class FlashVars {
		
		private static var _stage:Stage;
		
		/**
		 * 
		 * @param	stage
		 */
		[Inline]
		public static function init(stage:Stage):void {
			if (!_stage && stage) {
				_stage = stage;
				var _params:Object = _stage.loaderInfo.parameters;
				for (var i:String in _params) {
					if (_params[i])
						FlashVars[i] = _params[i];
				}
			}
		}
		
		/**
		 * 
		 * @param	property
		 * @param	valueDefault
		 * @return
		 */
		[Inline]
		public static function get(property:String, valueDefault:String = ''):String {
			if (!_stage)
				trace('FlashVars not initialized');
			
			if (!FlashVars[property] && valueDefault != null)
				set(property, valueDefault);
			
			return FlashVars[property];
		}
		
		/**
		 * 
		 * @param	property
		 * @param	value
		 */
		[Inline]
		public static function set(property:String, value:String):void {
			if (!_stage)
				trace('FlashVars not initialized');
			
			FlashVars[property] = value;
		}
		
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function toString():String {
			var _str:String = '';
			for (var i:String in FlashVars)
				_str += ('&' + i + '=' + FlashVars[i]);
			return _str.slice(1, _str.length);
		}
		
		/**
		 * 
		 */
		public static function get inited():Boolean {
			return Boolean(_stage);
		}
		
	}

}