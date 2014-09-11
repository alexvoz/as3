package ua.olexandr.tools {
	import ua.olexandr.utils.ColorUtils;
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2013
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class Parser {
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @param	defValue
		 * @return
		 */
		public static function getText(target:Object, prop:String, defValue:String = ""):String {
			if (target && target.hasOwnProperty(prop))
				return target[prop];
			
			return defValue;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @param	defValue
		 * @return
		 */
		public static function getNumber(target:Object, prop:String, defValue:Number = 0):Number {
			if (target && target.hasOwnProperty(prop) && !isNaN(Number(target[prop])))
				return Number(target[prop]);
			
			return defValue;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @param	defValue
		 * @return
		 */
		public static function getColor(target:Object, prop:String, defValue:uint = 0x000000):uint {
			if (target && target.hasOwnProperty(prop))
				return ColorUtils.parse(target[prop], defValue);
			
			return defValue;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @param	defValue
		 * @return
		 */
		public static function getAlpha(target:Object, prop:String, defValue:Number = 1):Number {
			if (target && target.hasOwnProperty(prop) && !isNaN(Number(target[prop])))
				return Number(target[prop]) / 100;
			
			return defValue;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @param	defValue
		 * @return
		 */
		public static function getBoolean(target:Object, prop:String, defValue:Boolean):Boolean {
			if (target && target.hasOwnProperty(prop)) {
				var _prop:String = target[prop];
				return _prop.toLowerCase() == "true" || _prop == "1";
			}
			
			return defValue;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @return
		 */
		public static function isTrue(target:Object, prop:String):Boolean {
			if (target && target.hasOwnProperty(prop)) {
				var _prop:String = target[prop];
				return _prop.toLowerCase() == "true" || _prop == "1";
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	prop
		 * @return
		 */
		public static function isFalse(target:Object, prop:String):Boolean {
			if (target && target.hasOwnProperty(prop)) {
				var _prop:String = target[prop];
				return _prop.toLowerCase() == "false" || _prop == "0";
			}
			
			return false;
		}
		
	}

}