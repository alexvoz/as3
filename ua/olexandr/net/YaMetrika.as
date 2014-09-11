package ua.olexandr.net {
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2013
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class YaMetrika {
		
		private static var _id:String;
		
		/**
		 * 
		 * @param	id
		 */
		[Inline]
		public static function init(id:String):void {
			_id = id;
		}
		
		/**
		 * 
		 * @param	url
		 * @param	title
		 * @param	referer
		 */
		[Inline]
		public static function hit(url:String, title:String = null, referer:String = null):void {
			if (!_id)
				return;
			
			if (ExternalInterface.available)
				ExternalInterface.call("yaCounter" + _id + ".hit", url, title, referer);
			
			//navigateToURL(new URLRequest("javascript:yaCounter10055023.hit(url, title, referer)"), "_self");
		}
		
	}

}