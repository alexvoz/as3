package ua.olexandr.net {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import ua.olexandr.debug.Logger;
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class NetNavigator {
		
		public static const BLANK:String = '_blank';
		public static const SELF:String = '_self';
		public static const PARENT:String = '_parent';
		public static const TOP:String = '_top';
		
		/**
		 * 
		 */
		public static var debug:Boolean = CONFIG::debug;
		
		/**
		 * 
		 */
		public static var defaultTarget:String = '_self';
		
		/**
		 * 
		 * @param	url
		 * @param	target
		 * @param	noCache
		 */
		[Inline]
		public static function gotoURL(url:String, target:String = '', noCache:Boolean = false):void {
			if (!target)
				target = defaultTarget;
			
			if (noCache)
				url = NetNavigator.noCache(url);
			
			if (url){
				if (debug)		Logger.info('navigate to ' + url + ' (' + target + ')');
				else			navigateToURL(new URLRequest(url), target);
			} else {
				if (debug)		Logger.error('request is empty (' + url + ')');
			}
		}
		
		/**
		 * 
		 * @param	url
		 * @param	param
		 * @return
		 */
		[Inline]
		public static function noCache(url:String, param:String = 'noCache'):String {
			if (!url)
				return url;
			
			return url + ((url.indexOf('?') == -1) ? '?' : '&') + param + '=' + new Date().getTime();
		}
	}

}