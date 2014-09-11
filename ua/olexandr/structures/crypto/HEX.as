package ua.olexandr.data.crypto {
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class HEX {
		
		/**
		 * 
		 * @param	str
		 * @param	sep
		 * @return
		 */
		public static function encode(str:String, sep:String = ''):String {
			var _ba:ByteArray = new ByteArray();
			_ba.writeUTFBytes(str);
			_ba.position = 0;
			
			var _len:int = _ba.bytesAvailable;
			var _res:String = '';
			var _char:String;
			
			for (var i:int = 0; i < _len; i++) {
				_char = _ba.readUnsignedByte().toString(16);
				
				if (_char.length == 1)
					_char = '0' + _char;
				
				_res += (sep && i < _len - 1) ? _char + sep : _char;
			}
			
			return _res.toUpperCase();
		}
		
		/**
		 * 
		 * @param	str
		 * @param	sep
		 * @return
		 */
		public static function decode(str:String, sep:String = ''):String {
			if (sep)
				str = str.split(sep).join('');
			
			var _arr:Array = str.split('');
			var _ba:ByteArray = new ByteArray();
			var _len:int = _arr.length;
			
			if (_len % 2 != 0)
				throw new ArgumentError("improper hex string passed '" + str + "' (string length should be even)");
			
			for (var i:int = 0; i < _len; i += 2)
				_ba.writeByte(parseInt(_arr[i] + _arr[i + 1], 16));
			
			return _ba.toString();
		}
	
	}

}