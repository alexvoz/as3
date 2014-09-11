package ua.olexandr.social.vkontakte {
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class VKWrapper {
		
		public static const BOX_INSTALL:String 			= 'InstallBox';
		public static const BOX_SETTINGS:String 		= 'SettingsBox';
		public static const BOX_INVITE:String 			= 'InviteBox';
		public static const BOX_PAYMENT:String 			= 'PaymentBox';
		public static const BOX_PROFILE_PHOTO:String 	= 'ProfilePhotoBox';
		
		private static var _vkontakte:Boolean;
		
		private static var _wrapper:Object;
		
		private static var _application:Object;
		private static var _external:Object;
		private static var _lang:Object;
		
		private static var _flashvars:Object;
		
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * 
		 * @param	$client
		 */
		public static function init($client:DisplayObject):void {
			
			if ($client.parent.parent) {
				
				_vkontakte = true;
				
				_wrapper 		= $client.parent.parent;
				
				_application	= _wrapper.application;
				_external 		= _wrapper.external;
				_lang 			= _wrapper.lang;
				
				_flashvars		= _application.parameters;
				
				_wrapper.addEventListener(VKWrapperEvent.APPLICATION_ADDED, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.APPLICATION_ADDED, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.BALANCE_CHANGED, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.BALANCE_CHANGED, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.LOCATION_CHANGED, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.LOCATION_CHANGED, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.MOUSE_LEAVE, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.MOUSE_LEAVE, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.PROFILE_PHOTO_SAVE, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.PROFILE_PHOTO_SAVE, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.SETTINGS_CHANGED, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.SETTINGS_CHANGED, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.WINDOW_BLUR, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.WINDOW_BLUR, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.WINDOW_FOCUS, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.WINDOW_FOCUS, $o));
				});
				_wrapper.addEventListener(VKWrapperEvent.WINDOW_RESIZED, function($o:Object):void {
					_dispatcher.dispatchEvent(new VKWrapperEvent(VKWrapperEvent.WINDOW_RESIZED, $o));
				});
				
				
			} else if ($client.stage) {
				
				_vkontakte 		= false;
				
				_wrapper		= $client.stage;
				
				_application	= $client.stage;
				_external		= { };
				_lang			= { };
				
				_flashvars		= _wrapper.loaderInfo.parameters;
				
			} else {
				
				_vkontakte 		= false;
				
				_wrapper		= { };
				
				_application	= { };
				_external		= { };
				_lang			= { };
				
				_flashvars		= { };
				
			}
		}
		
		/**
		 * 
		 */
		public static function get wrapper():Object { return _wrapper; }
		
		/**
		 * 
		 */
		public static function get application():Object { return _application; }
		
		/**
		 * 
		 */
		public static function get external():Object { return _external; }
		
		/**
		 * 
		 */
		public static function get lang():Object { return _lang; }
		
		/**
		 * 
		 */
		public static function get flashvars():Object { return _flashvars; }
		
		/**
		 * 
		 */
		public static function get dispatcher():EventDispatcher { return _dispatcher; }
		
		/**
		 * 
		 * @param	$type
		 * @param	$parameters
		 * @return
		 */
		public static function showBox($type:String, $parameters:* = null):Boolean {
			if (_vkontakte) {
				switch ($type) {
					case BOX_INSTALL: {
						_external.showInstallBox();
						break;
					}
					case BOX_SETTINGS: {
						if ($parameters)	_external.showSettingsBox($parameters);
						else 				_external.showSettingsBox();
						break;
					}
					case BOX_INVITE: {
						_external.showInviteBox();
						break;
					}
					case BOX_PAYMENT: {
						_external.showPaymentBox();
						break;
					}
					case BOX_PROFILE_PHOTO: {
						_external.showProfilePhotoBox();
						break;
					}
					default : {
						return false;
						break;
					}
				}
				return true;
			} else {
				return false;
			}
		}
	}

}