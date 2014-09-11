package ua.alexvoz.utils {
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	
	public class ColorUtils {
		
		/**
		 * 0x000000..0xFFFFFF
		 * @param 		color:int
		 * @return		Object
		 */
		public static function expandColor(color:uint):Object {
			var _obj:Object = new Object();
			_obj.red = color & 0xFF0000 >> 16;
			_obj.green = color & 0x00FF00 >> 8;
			_obj.blue = color & 0x0000FF >> 0;
			return _obj;
		}
		
		/**
		 * 0x00..0xFF
		 * @param 		red:uint green:uint blue:uint
		 * @return		uint
		 */
		public static function combineColors(red:uint, green:uint, blue:uint):uint {
			return red << 16 + green << 8 + blue;
		}
	}

}