package ua.olexandr.net {
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.core.TrackerMode;
	import com.google.analytics.GATracker;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class GoogleAnalytics {
		
		// add to library: analytics.swc
		private static var _tracker:AnalyticsTracker;
		
		/**
		 * 
		 * @param	target
		 * @param	account
		 * @param	debug
		 */
		[Inline]
		public static function init(target:DisplayObject, account:String, debug:Boolean = false):void {
			if (!_tracker)
				_tracker = new GATracker(target, account, TrackerMode.AS3, debug);
		}
		
		/**
		 * 
		 * @param	category
		 * @param	action
		 * @param	label
		 * @return
		 */
		[Inline]
		public static function trackEvent(category:String, action:String, label:String = null):Boolean {
			if (!_tracker)
				return false;
			
			return _tracker.trackEvent(category, action, label);
		}
		
		/**
		 * 
		 * @param	pageURL
		 */
		[Inline]
		public static function trackPageview(pageURL:String):void {
			if (!_tracker)
				return;
			
			_tracker.trackPageview(pageURL);
		}
		
	}
}