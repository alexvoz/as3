package ua.olexandr.utils {
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class ObjectUtils {
		
		/**
		 * 
		 * @param	table
		 * @return
		 */
		[Inline]
		public static function toArray(table:Object):Array {
			var _out:Array = [];
			for each (var thing:* in table)
				_out.push(thing);
			return _out;
		}
		
		/**
		 * 
		 * @param	input
		 * @return
		 */
		[Inline]
		public static function clone(input:Object):Object {
			var _out:Object = {};
			for (var _str:String in input) {
				var _val:* = input[_str];
				_out[_str] = _val.toString() === "[object Object]" ? clone(_val) : _val;
			}
			
			return _out;
		}
		
		/**
		 * 
		 * @param	obj
		 * @return
		 */
		[Inline]
		public static function copy(obj:Object):Object {
			var _bytes:ByteArray = new ByteArray();
			_bytes.writeObject(obj);
			_bytes.position = 0;
			return _bytes.readObject();
		}
		
		/**
		 * 
		 * @param	obj
		 * @param	prop
		 * @return
		 */
		[Inline]
		public static function has(obj:Object, prop:String):Boolean {
			return obj.hasOwnProperty(prop);
		}
	
	}

}