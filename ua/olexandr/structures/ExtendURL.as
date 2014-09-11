package ua.olexandr.structures {
	import flash.net.URLVariables;
	
	public class ExtendURL {
		
		public static const PROTOCOL:int = 1;
		public static const HOST:int = 2;
		public static const PORT:int = 4;
		public static const PATH:int = 8;
		public static const QUERY:int = 16;
		public static const HASH:int = 32;
		
		public static const _PROTOCOL_HOST:int = PROTOCOL | HOST;
		public static const _PROTOCOL_HOST_PORT:int = PROTOCOL | HOST | PORT;
		public static const _PROTOCOL_HOST_PORT_PATH:int = PROTOCOL | HOST | PORT | PATH;
		
		
		private static const PROTOCOL_NONE:String = "";
		private static const PROTOCOL_HTTP:String = "http";
		private static const PROTOCOL_HTTPS:String = "https";
		private static const PROTOCOL_RTMP:String = "rtmp";
		private static const PROTOCOL_FTP:String = "ftp";
		private static const PROTOCOL_FILE:String = "file";
		
		private static const PORT_DEFAULT:String = "80";
		
		
		private var _url:String;
		private var _modified:Boolean;
		
		private var _protocol:String;
		private var _port:String;
		private var _host:String;
		private var _path:String;
		private var _query:URLVariables;
		private var _hash:String;
		
		/**
		 * 
		 * @param	url
		 */
		public function ExtendURL(url:String) {
			_url = url;
			
			// /((?P<protocol>[a-zA-Z]+:\/\/) (?P<host>[^:\/]*) (:(?P<port>\d+))?)? (?P<path>[^?]*)? (?P<query>.*)? /x;
			var _regex:RegExp =/((?P<protocol>[a-zA-Z]+:\/\/) (?P<host>[^:\/]*) (:(?P<port>\d+))?)? (?P<path>[^?]*)? (?P<query>[^#]*)? (?P<hash>.*)? /x;
			var _match:Object = _regex.exec(_url);
			if (_match) {
				_protocol = _match.protocol;
				_protocol = _protocol.substr(0, _protocol.indexOf("://"));
				_host = _match.host;
				_port = _match.port;
				_path = _match.path;
				_query = _match.query ? new URLVariables(_match.query.substr(1)) : new URLVariables();
				_hash = _match.hash ? _match.hash.substr(1) : "";
			}
		}
		
		/**
		 * Отсутствует ли протокол
		 * @return
		 */
		public function isProtocolNone():Boolean { return protocol.toLowerCase() == PROTOCOL_NONE; }
		/**
		 * Является ли протоколом HTTP
		 * @return
		 */
		public function isProtocolHTTP():Boolean { return protocol.toLowerCase() == PROTOCOL_HTTP; }
		/**
		 * Является ли протоколом HTTPS
		 * @return
		 */
		public function isProtocolHTTPS():Boolean { return protocol.toLowerCase() == PROTOCOL_HTTPS; }
		/**
		 * Является ли протоколом RTMP
		 * @return
		 */
		public function isProtocolRTMP():Boolean { return protocol.toLowerCase() == PROTOCOL_RTMP; }
		/**
		 * Является ли протоколом FTP
		 * @return
		 */
		public function isProtocolFTP():Boolean { return protocol.toLowerCase() == PROTOCOL_FTP; }
		/**
		 * Является ли протоколом File
		 * @return
		 */
		public function isProtocolFile():Boolean { return protocol.toLowerCase() == PROTOCOL_FILE; }
		
		/**
		 * Является ли порт, портом по умолчанию (80)
		 * @return
		 */
		public function isPortDefault():Boolean { return port.toLowerCase() == PORT_DEFAULT; }
		
		/**
		 * 
		 * @param	mask
		 * @return
		 */
		public function combine(mask:int):String {
			var _url:String = "";
			
			if (Boolean(mask & PROTOCOL) && _protocol)
				_url += (_protocol + '://');
			
			if (Boolean(mask & HOST) && _host)
				_url += _host;
			
			if (Boolean(mask & PORT) && _port)
				_url += (':' + _port);
			
			if (Boolean(mask & PATH) && _path)
				_url += _path;
			
			if (Boolean(mask & QUERY) && _query)
				_url += ('?' + _query);
			
			if (Boolean(mask & HASH) && _hash)
				_url += ('#' + _hash);
			
			return _url;
		}
		
		/**
		 * Протокол
		 */
		public function get protocol():String { return _protocol; }
		/**
		 * Протокол
		 */
		public function set protocol(value:String):void {
			_protocol = value;
			_modified = true;
		}
		
		/**
		 * Порт
		 */
		public function get port():String { return _port; }
		/**
		 * Порт
		 */
		public function set port(value:String):void {
			_port = value;
			_modified = true;
		}
		
		/**
		 * Хост
		 */
		public function get host():String { return _host; }
		/**
		 * Хост
		 */
		public function set host(value:String):void {
			_host = value;
			_modified = true;
		}
		
		/**
		 * Путь
		 */
		public function get path():String { return _path; }
		/**
		 * Путь
		 */
		public function set path(value:String):void {
			_path = value;
			_modified = true;
		}
		
		/**
		 * Запрос
		 */
		public function get query():URLVariables { return _query; }
		/**
		 * Запрос
		 */
		public function set query(value:URLVariables):void {
			_query = value || new URLVariables();
			_modified = true;
		}
		
		/**
		 * Хеш
		 */
		public function get hash():String { return _hash; }
		/**
		 * Хеш
		 */
		public function set hash(value:String):void {
			_hash = value;
			_modified = true;
		}
		
		/**
		 * Файл
		 */
		public function get file():String { return _path.substring(_path.lastIndexOf("/") + 1); }
		
		
		/**
		 * URL
		 */
		public function get url():String {
			if (_modified) {
				_modified = false;
				_url = (protocol && (protocol + '://')) + (host && host) + (port && (':' + port)) + (path && path) + (query.toString() && ('?' + query)) + (hash && ('#' + hash));
			}
			
			return _url;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return "[SmartURL\n\tprotocol = " + protocol + "\n\tport = " + port + "\n\thost = " + host + "\n\tpath = " + path + "\n\tquery = " + query + "\n\thash = " + hash + "\n\turl = " + url + "\n]";
		}
	}
}
