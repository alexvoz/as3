package ua.olexandr.utils {
	import flash.text.Font;
	import flash.utils.Dictionary;
	import ua.olexandr.debug.Logger;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class FontUtils{
		
		private static var _registered:Dictionary = new Dictionary();
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		[Inline]
		public static function registerFont(name:Class):String {
			if (!_registered[name]) {
				Font.registerFont(name);
				_registered[name] = (new name() as Font).fontName;
			}
			
			return _registered[name];
		}
		
		/**
		 * 
		 * @param	style
		 */
		[Inline]
		public static function printAllFonts(style:Boolean = false):void {
			var _arr:Array = Font.enumerateFonts(true).sortOn('fontName', Array.CASEINSENSITIVE);
			
			var _font:Font;
			var _len:int = _arr.length;
			var i:int;
			
			if (style) {
				for (i = 0; i < _len; i++) {
					_font = _arr[i] as Font;
					Logger.code((i + 1) + ': ' + _font.fontName + ' / ' + _font.fontStyle);
				}
			} else {
				for (i = 0; i < _len; i++) {
					_font = _arr[i] as Font;
					Logger.code((i + 1) + ': ' + _font.fontName);
				}
			}
		}
		
		/**
		 * 
		 * @param	style
		 */
		[Inline]
		public static function printEmbedFonts(style:Boolean = false):void {
			var _arr:Array = Font.enumerateFonts(false).sortOn('fontName', Array.CASEINSENSITIVE);;
			
			var _font:Font;
			var _len:int = _arr.length;
			var i:int;
			
			if (style) {
				for (i = 0; i < _len; i++) {
					_font = _arr[i] as Font;
					Logger.code((i + 1) + ': ' + _font.fontName + ' / ' + _font.fontStyle);
				}
			} else {
				for (i = 0; i < _len; i++) {
					_font = _arr[i] as Font;
					Logger.code((i + 1) + ': ' + _font.fontName);
				}
			}
		}
		
	}

}