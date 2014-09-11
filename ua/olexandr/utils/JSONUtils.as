package ua.olexandr.utils {
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class JSONUtils {
		
		/**
		 * Pastila Lib for ActionScript 3.0
		 * Copyright (c) 2012, Ilya Malanin
		 * https://bitbucket.org/mayakwd/pastila-core
		 * @param	serializedJSON
		 * @param	useTabs
		 * @return
		 */
		[Inline]
		public static function format(serializedJSON:String, useTabs:Boolean = true):String {
			var strings:Object = { };
			
			serializedJSON = serializedJSON.replace(/(\\.)/g, saveString);
			serializedJSON = serializedJSON.replace(/(".*?"|'.*?')/g, saveString);
			serializedJSON = serializedJSON.replace(/\s+/, "");
			
			var indent:int = 0;
			var result:String = "";
			
			for (var i:uint = 0; i < serializedJSON.length; i++) {
				var char:String = serializedJSON.charAt(i);
				switch (char) {
					case "{": 
					case "[": 
						result += char + "\n" + makeTabs(++indent, useTabs);
						break;
					case "}": 
					case "]": 
						result += "\n" + makeTabs(--indent, useTabs) + char;
						break;
					case ",": 
						result += ",\n" + makeTabs(indent, useTabs);
						break;
					case ":": 
						result += ": ";
						break;
					default: 
						result += char;
						break;
				}
			}
			
			result = result.replace(/\{\s+\}/g, stripWhiteSpace);
			result = result.replace(/\[\s+\]/g, stripWhiteSpace);
			result = result.replace(/\[[\d,\s]+?\]/g, stripWhiteSpace);
			
			result = result.replace(/\\(\d+)\\/g, restoreString);
			result = result.replace(/\\(\d+)\\/g, restoreString);
			
			function saveString(... args):String {
				var string:String = args[0];
				var index:uint = uint(args[2]);
				
				strings[index] = string;
				
				return "\\" + args[2] + "\\";
			}
			
			function restoreString(... args):String {
				var index:uint = uint(args[1]);
				return strings[index];
			}
			
			function stripWhiteSpace(... args):String {
				var value:String = args[0];
				return value.replace(/\s/g, '');
			}
			
			function makeTabs(count:int, useTabs:Boolean):String {
				return new Array(count + 1).join(useTabs ? "\t" : "       ");
			}
			
			return result;
		}
	
	}

}
