package ua.olexandr.tools.conversions {
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class DataConversions {
		
		private static const _BASE:int = Math.pow(2, 10);
		
		/**
		 * 
		 * @param	bits
		 * @return
		 */
		[Inline]
	    public static function bitsToBytes(bits:int):Number {
			return bits * (1/8);
		}
		
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function bytesToBits(bytes:Number):int {
			return Math.ceil(bytes * 8);﻿
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function bytesToKilo(bytes:Number):Number {
			return scale(bytes, -1);﻿
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function bytesToMega(bytes:Number):Number {
			return scale(bytes, -2);
		}
		
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function kiloToMega(bytes:Number):Number {
			return scale(bytes, -1);
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function kiloToBytes(bytes:Number):Number {
			return scale(bytes, 1);
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function kiloToGiga(bytes:Number):Number {
			return scale(bytes, -2);
		}
		
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function megaToGiga(bytes:Number):Number {
			return scale(bytes, -1);
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function megaToKilo(bytes:Number):Number {
			return scale(bytes, 1);
		}
		
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function gigaToKilo(bytes:Number):Number {
			return scale(bytes, 2);
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function gigaToMega(bytes:Number):Number {
			return scale(bytes, 1);
		}
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function gigaToTera(bytes:Number):Number {
			return scale(bytes, -1);
		}
		
		
		/**
		 * 
		 * @param	bytes
		 * @return
		 */
		[Inline]
		public static function teraToGiga(bytes:Number):Number {
			return scale(bytes, 1);
		}
		
		
		
		/**
		 * 
		 * @param	amt
		 * @param	times
		 * @return
		 */
		[Inline]
		private static function scale(amt:int, times:int = 0):int {
			var _value:int = amt;
			
			var _flag:Boolean = times > 0;
			var _len:int = Math.abs(times);
			for (var i:int = 0; i < _len; i++)
				_value *= (_flag ? _BASE : (1 / _BASE));
			
			return _value;
		}
		
	}

}

