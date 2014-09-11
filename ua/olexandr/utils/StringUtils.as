package ua.olexandr.utils {
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import ua.olexandr.constants.DirectionConst;
	import ua.olexandr.constants.LocaleConst;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class StringUtils {
		
		/**
		 * Return true if str != null and str == "true" or "1"
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function isTrue(str:String):Boolean {
			return str && (str.toLowerCase() == "true" || str == "1");
		}
		
		/**
		 * Return true if str == null, "", "false" or "0"
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function isFalse(str:String):Boolean {
			return !str || !Boolean(str) || (str.toLowerCase() == "false" || str == "0");
		}
		
		/**
		 * 
		 * @param	str1
		 * @param	str2
		 * @param	toCase
		 * @return
		 */
		[Inline]
		public static function isEqual(str1:String, str2:String, toCase:Boolean = false):Boolean {
			if (!isSet(str1) || !isSet(str2))
				return false;
			
			return toCase ? str1.toUpperCase() == str2.toUpperCase() : str1 == str2;
		}
		
		/**
		 * 
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function isSet(value:String):Boolean {
			return (value != null && value.length > 0);
		}
		
		/**
		 * 
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function parse(value:*):String {
			if (value) {
				if (value is String) 						return value;
				else if (value['toString'] is Function) 	return value['toString']();
			}
			return '';
		}
		
		/**
		 * Дополняет или обрезает строку $string до нужного количества $count символов
		 * @param	$string
		 * @param	$count
		 * @param	$direction
		 * @param	$char
		 * @return
		 */
		[Inline]
		public static function setLength(str:String, count:int, direct:String = 'left', char:String = '0'):String {
			if (!(str is String))
				return null;
			
			if (str.length < count) {
				if (direct == DirectionConst.LEFT) 			while (str.length < count) str = char + str;
				else if (direct == DirectionConst.RIGHT) 	while (str.length < count) str = str + char;
			} else if (str.length != count) {
				if (direct == DirectionConst.LEFT)	 		str = str.slice(str.length - count, str.length);
				else if (direct == DirectionConst.RIGHT) 	str = str.slice(0, count);
			}
			
			return str;
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function trimLeft(str:String):String {
			if (!(str is String))
				return null;
				
			return str.replace(/^\s+/, '');
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function trimRight(str:String):String {
			if (!(str is String))
				return null;
			
			return str.replace(/\s+$/, '');
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function trim(str:String):String {
			if (!(str is String))
				return null;
			
			return str.replace(/^\s+|\s+$/g, '');
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function isNumeric(str:String):Boolean {
			if (str == null)
				return false;
				
			var _regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return _regx.test(str);
		}
		
		/**
		 * 
		 * @param	char
		 * @return
		 */
		[Inline]
		public static function isWhitespace(char:String):Boolean {
			return char == '\r' || char == '\n' || char == '\f' || char == '\t' || char == ' ';
		}
		
		/**
		 * обрезает строку до заданной длины
		 * @param	str
		 * @param	len
		 * @return
		 */
		[Inline]
        public static function truncate(str:String, len:int, ellipsis:String = "…"):String {
			if (!(str is String))
				return null;
				
            if (str.length > len)
                str = str.substr(0, len - ellipsis.length) + ellipsis;
			
            return str;
        }
		
		/**
		 * Нормализует escape-переносы в строке
		 * @param	$str
		 * @return
		 */
		[Inline]
		public static function normalize(str:String):String {
			if (!(str is String))
				return null;
			
			//var _str:String;
			//_str = str.split('\r\n').join('\n');
			//_str = str.split('\\n').join('\n');
			
			return str.replace(/[\t ]*[\r\n][\r\n\t ]*/g, '\n');
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function removeDoubleLines(str:String):String {
			if (!(str is String))
				return null;
				
			return str.replace(/[\r\n][\n\r]/g, '\n');
		}
		
		/**
		 * Переворачивает строку
		 * @param	$str
		 * @return
		 */
		[Inline]
		public static function reverse(str:String):String {
			if (!isSet(str))
				return null;
			
			return str.split('').reverse().join('');
		}
		
		/**
		 * Подсчитывает количество вхождений подстроки
		 * @param	$str
		 * @param	$char
		 * @param	$caseSensitive
		 * @return
		 */
		[Inline]
		public static function getCount(str:String, char:String, caseSensitive:Boolean = true):uint {
			if (!isSet(str))
				return null;
			
			return str.match(new RegExp(char, caseSensitive ? 'g' : 'ig')).length;
		}
		
		/**
		 * Подсчитывает количество слов
		 * @param	$str
		 * @return
		 */
		[Inline]
		public static function getWordCount(str:String):uint {
			if (!isSet(str))
				return null;
			
			return str.match(/\b\w+\b/g).length;
		}
		
		/**
		 * 
		 * @param	num
		 * @return
		 */
		[Inline]
		public static function getOrdinalSuffix(num:int, lang:String = 'en'):String {
			switch (lang) {
				case LocaleConst.EN: {
					if ((num % 100) > 10 && (num % 100) < 14)
						return num + "th";
					
					switch (num % 10) {
						case 1: {
							return num + "st";
						}
						case 2: {
							return num + "nd";
						}
						case 3: {
							return num + "rd";
						}
						default: {
							return num + "th";
						}
					}
					break;
				}
				default: {
					return num.toString();
					break;
				}
			}
		}
		
		/**
		 * 
		 * @param	$count
		 * @param	$forms ['комментарий', 'комментария', 'комментариев']
		 * @param	$lang
		 * @return
		 */
		[Inline]
		public static function getHumanPluralForms(count:int, forms:Array, lang:String = 'ua'):String {
			// http://translate.sourceforge.net/wiki/l10n/pluralforms
			// $forms = ['комментарий', 'комментария', 'комментариев'];
			
			var _index:int;
			
			if (forms) {
				switch (lang) {
					case LocaleConst.UA:
					case LocaleConst.RU: {
						_index = (count % 10 == 1 && count % 100 != 11 ? 0 : count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20) ? 1 : 2);
						break;
					}
					case LocaleConst.EN: {
						_index = int(count != 1);
						break;
					}
					default: {
						break;
					}
				}
				return count + ' ' + forms[_index];
			}
			return count.toString();
		}
		
		/**
		 * Добавляет в строку разделители разрядов
		 * @param	$string
		 * @param	$separator
		 * @return
		 */
		[Inline]
		public static function addThousandsSeparator(str:String, sep:String = ' '):String {
			if (!(str is String))
				return null;
			
			var _arr:Array = str.split('');
			var _str:String = '';
			var _len:int = _arr.length;
			
			for (var i:int = 0; i < _len; i++) {
				if (i % 3 == 0 && i > 0)
					_str = sep + _str;
					
				_str = _arr[_len - i - 1] + _str;
			}
			
			return _str;
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function toTitleCase(str:String):String {
			if (!(str is String))
				return null;
			
			var _arr:Array = str.split(' ');
			var _len:int = _arr.length;
			
			for (var i:int = 0; i < _len; i++) {
				var _str:String = _arr[i];
				_arr[i] = _str.charAt(0).toUpperCase() + _str.substr(1).toLowerCase();
			}
			return _arr.join(' ');
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
        public static function unescapeHTML(str:String):String {
			return new XMLDocument(str).firstChild.nodeValue;
        }
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function escapeHTML(str:String):String {
			return XML(new XMLNode(XMLNodeType.TEXT_NODE, str)).toXMLString();
		}
		
		/**
		 * 
		 * @param	str
		 * @return
		 */
		[Inline]
		public static function escapeBackslashes(str:String):String {
			return str.replace(/\\/g, "\\\\");
		}
		
		/*
		public static function trimWhitespace($string:String):String {
			if ($string == null) {
				return "";
			}
			
			return $string.replace(/^\s+|\s+$/g, "");
		}
		*/
	}
}