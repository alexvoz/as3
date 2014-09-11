package ua.olexandr.utils {
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.system.Security;
	import ua.olexandr.constants.EnvironmentConst;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class EnvironmentUtils {
		
		public static const AVAILABLE:Boolean = ExternalInterface.available;
		
		/**
		 * 
		 */
		[Inline]
		public static function isJSAvailable():Boolean {
			if (AVAILABLE) {
				try {
					return Boolean(ExternalInterface.call("function() { return true; }"));
				} catch (e:Error) {
					return false;
				}
			}
			
			return false;
		}
		
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isWindows():Boolean {
			//return Capabilities.os.indexOf('Win') == 0;
			return Capabilities.manufacturer == "Adobe Windows";
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isMac():Boolean {
			return Capabilities.os.indexOf('Mac') == 0;
		}
        
		/**
		 * 
		 * @return
		 */
		[Inline]
        public static function isLinux():Boolean {
			//return Capabilities.os.indexOf('Linux') == 0;
			return Capabilities.os == "Linux";
		}
        
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isAndroid():Boolean {
			// TODO: this is true on Linux too?
			return Capabilities.manufacturer == "Android Linux";
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isIOS():Boolean {
			return Capabilities.manufacturer == "Adobe iOS";
		}
		
		
		/**
		 * 
		 * @return
		 */
		[Inline]
        public static function isBrowser():Boolean {
			return isActiveX() || isPlugin();
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
        public static function isActiveX():Boolean {
			return Capabilities.playerType == 'ActiveX';
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isPlugin():Boolean {
			return Capabilities.playerType == "PlugIn";
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isAir():Boolean {
			return Capabilities.playerType == "Desktop";
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isStandalone():Boolean {
			return Capabilities.playerType == 'StandAlone';
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isDebugPlayer():Boolean {
			return Capabilities.isDebugger;
		}
		
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isLocal():Boolean {
			return getDomain() == "localhost";
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function isServer():Boolean {
			return Security.sandboxType == Security.REMOTE;
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getDomain():String{
			//target:DisplayObject
			//var _url:String = target.loaderInfo.url.split("://")[1].split("/")[0];
			//return (_url.substr(0, 4) == "www.") ? _url.substr(4) : _url;
			
			return new LocalConnection().domain;
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getURL():String {
			if (!isJSAvailable())
				return null;
			
			var _url:String;
			
			try {
				_url = ExternalInterface.call('window.location.href.toString');
			} catch (err:Error) {
				try {
					_url = ExternalInterface.call('eval', 'document.location.href');
				} catch (err:Error) {
				}
			}
			
			return _url;
        }
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getTitle():String {
			if (!isJSAvailable())
				return null;
			
			var _title:String;
			
			try {
				_title = ExternalInterface.call('window.title.toString');
			} catch (err:Error) {
				try {
					_title = ExternalInterface.call('eval', 'document.title');
				} catch (err:Error) {
				}
			}
			
			return _title;
        }
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getBrowser():String {
			if (!isJSAvailable())
				return null;
			
			var _browser:String;
			
            try {
				var _agent:String = ExternalInterface.call('window.navigator.userAgent.toString');
				
				if (_agent.indexOf('Safari') != -1)
					_browser = EnvironmentConst.BROWSER_SAFARI;
                else if (_agent.indexOf('Firefox') != -1)
                    _browser = EnvironmentConst.BROWSER_FIREFOX;
                else if (_agent.indexOf('Chrome') != -1)
                    _browser = EnvironmentConst.BROWSER_CHROME;
                else if (_agent.indexOf('MSIE') != -1)
                    _browser = EnvironmentConst.BROWSER_IE;
                else if (_agent.indexOf('Opera') != -1)
                    _browser = EnvironmentConst.BROWSER_OPERA;
            } catch (err:Error) {
            }
			
            return _browser;
        }
		
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getPlayerInfo():String {
			return "Flash Platform: " + Capabilities.version + " / " + Capabilities.playerType + (Capabilities.isDebugger ? ' / Debugger' : '') + " / " + Capabilities.os + " / " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
		}
		
		/**
		 * 
		 * @param	url
		 * @return
		 */
		[Inline]
		public static function getVars(url:String):URLVariables {
			var _params:String;
			
			if (url.indexOf('#') != -1) {
				_params = url.slice(url.indexOf('#')+1);
			} else if (url.indexOf('?') != -1) {
				_params = url.slice(url.indexOf('?')+1);
			}
			
			return new URLVariables(_params);
		}
		
		/**
		 * 
		 * @param	urlVars
		 * @return
		 */
		[Inline]
		public static function getSortVars(urlVars:URLVariables):String {
			var pairs:Array = urlVars.toString().split('&');
			pairs.sort(function (a:String, b:String):Number {
				if (a < b)			return -1;
				else if (a > b)		return 1;
				else				return 0;
			});
			
			return pairs.join('&');
		}
		
		
		/**
		 * 
		 * @param	domain
		 * @return
		 */
		[Inline]
		public static function isDomain(domain:String):Boolean {
			return getDomain().slice(-domain.length) == domain;
		}
		
		/**
		 * 
		 * @param	url
		 * @return
		 */
		[Inline]
		public static function getProtocol(url:String):String {    
            return url.substr(0, url.indexOf(":"));
        }
		
		/**
		 * 
		 * @param	filename
		 * @return
		 */
		[Inline]
		public static function removeExtension(filename:String):String {
			var _index:Number = filename.lastIndexOf('.');
			return _index == -1 ? filename : filename.substr(0, _index);
		}
		
		/**
		 * 
		 * @param	filename
		 * @return
		 */
		[Inline]
		public static function extractExtension(filename:String):String {
			var _index:Number = filename.lastIndexOf('.');
			return _index == -1 ? '' : filename.substr(_index + 1, filename.length);
		}
		
		
		/**
		 * Заменяет адресс e-mail на ссылку для открытия почтового клиента
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function toMailLink(value:String):String {
			return value.replace(/[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]/ig, '<a href="mailto:$&">$&</a>');
		}
		
		/**
		 * Заменяет ссылки вида - http://www.adobe.com на - <a href="http://www.adobe.com>http://www.adobe.com</a>
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function toHrefLink(value:String):String {
			return value.replace(/(https|http|ftp):\/\/\S+[^\s.,>)\];'\"!?]/ig, '<a href="$&">$&</a>');
		}
		
		
		/**
		 * 
		 * @param	name
		 * @param	value
		 * @param	expireDays
		 */
		[Inline]
		public static function setCookie(name:String, value:String = "", expireDays:Number = 0):void {
			if (!isJSAvailable())
				return;
			
			ExternalInterface.call(<script><![CDATA[
				function(name, value, expireDays) {
					var expDate = new Date();
					expDate.setDate(expDate.getDate() + expireDays);
					document.cookie = escape(name) + "=" + escape(value) + ((expireDays == 0) ? "" : ";expires=" + expDate.toGMTString()) + "; path=/";
				}
			]]></script>, name, value, expireDays);
		}
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		[Inline]
		public static function getCookie(name:String):String {
			if (!isJSAvailable())
				return null;
			
			return ExternalInterface.call(<script><![CDATA[
				function(name) {
					var exp = new RegExp(escape(name) + "=([^;]+)");
					if (exp.test (document.cookie + ";")) {
						exp.exec (document.cookie + ";");
						return unescape(RegExp.$1);
					} else {
						return "";
					}
				}
			]]></script>, name);
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function closeWindow():void {
			if (!isJSAvailable())
				return;
			
			ExternalInterface.call(<script><![CDATA[
				function() {
					window.close();
				}
			]]></script>);
		}
		
		/**
		 * 
		 */
		[Inline]
		public static function reload():void {
			if (!isJSAvailable())
				return;
			
			ExternalInterface.call(<script><![CDATA[
				function() {
					window.location.reload();
				}
			]]></script>);
		}
	
	}
}