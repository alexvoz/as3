package ua.olexandr.social.vkontakte {
	import com.adobe.crypto.MD5;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class VKTools{
		
		/**
		 * 
		 * @param	$vars
		 * @return
		 */
		public static function createSignature($vars:Object):String {
			var _arr:Array = [];
			for (var s:String in $vars) _arr.push(s);
			_arr.sort(Array.CASEINSENSITIVE);
			
			var _str:String = VKVars.get(VKVars.VAR_VIEWER_ID);
			for (var i:int = 0; i < _arr.length; i++) {
				_str += (_arr[i] + '=' + $vars[_arr[i]]);
			}
			_str += VKVars.secret;
			
			return MD5.hash(_str);
		}
		
		/**
		 * 
		 * @param	$n
		 * @return
		 */
		public static function parseSettings($n:int):Array {
			/*
			_arr[10] = Boolean(flags & 1024);
			_arr[9] = Boolean(flags & 512);
			_arr[8] = Boolean(flags & 256);
			_arr[7] = Boolean(flags & 128);
			_arr[6] = Boolean(flags & 64);
			_arr[5] = Boolean(flags & 32);
			_arr[4] = Boolean(flags & 16);
			_arr[3] = Boolean(flags & 8);
			_arr[2] = Boolean(flags & 4);
			_arr[1] = Boolean(flags & 2);
			_arr[0] = Boolean(flags & 1);
			*/
			
			var _arr:Array = [false, false, false, false, false, false, false, false];
			if ($n >= 256) {
				_arr[7] = true;
				$n -= 256;
			}
			if ($n >= 128) {
				_arr[6] = true;
				$n -= 128;
			}
			if ($n >= 64) {
				_arr[5] = true;
				$n -= 64;
			}
			if ($n >= 32) {
				_arr[4] = true;
				$n -= 32;
			}
			if ($n >= 8) {
				_arr[3] = true;
				$n -= 8;
			}
			if ($n >= 4) {
				_arr[2] = true;
				$n -= 4;
			}
			if ($n >= 2) {
				_arr[1] = true;
				$n -= 2;
			}
			if ($n >= 1) {
				_arr[0] = true;
				$n -= 1;
			}
			return _arr;
		}
		
	}

}