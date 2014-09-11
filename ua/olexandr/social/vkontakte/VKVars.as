package ua.olexandr.social.vkontakte {
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	
	public class VKVars{
		
		//* api_url – это адрес сервиса API, по которому необходимо осуществлять запросы.
		//* api_id – это id запущенного приложения.
		//* user_id – это id пользователя, со страницы которого было запущено приложение. Если приложение запущено не со страницы пользователя, то значение равно 0.
		//* group_id – это id группы, со страницы которой было запущено приложение. Если приложение запущено не со страницы группы, то значение равно 0.
		//* viewer_id – это id пользователя, который просматривает приложение.
		//* is_app_user – если пользователь установил приложение – 1, иначе – 0.
		//* viewer_type – это тип пользователя, который просматривает приложение (возможные значения описаны ниже).
		//	if (group_id)
		//		* 3 – если пользователь является администратором группы.
		//		* 2 – если пользователь является руководителем группы.
		//		* 1 – если пользователь является участником группы.
		//		* 0 – если пользователь не состоит в группе.
		//	if (user_id)
		//		* 2 – если пользователь является владельцем страницы.
		//		* 1 – если пользователь является другом владельца страницы.
		//		* 0 – если пользователь не состоит в друзьях владельца страницы.
		//* auth_key – это ключ, необходимый для авторизации пользователя на стороннем сервере (см. описание ниже).
		//* api_result – это результат первого API-запроса, который выполняется при загрузке приложения (см. описание ниже).
		//* api_settings – битовая маска настроек текущего пользователя в данном приложении (подробнее см. в описании метода getUserSettings).
		
		public static const VAR_API_URL			:String = 'api_url';
		public static const VAR_API_ID			:String = 'api_id';
		public static const VAR_USER_ID			:String = 'user_id';
		public static const VAR_GROUP_ID		:String = 'group_id';
		public static const VAR_VIEWER_ID		:String = 'viewer_id';
		public static const VAR_IS_APP_USER		:String = 'is_app_user';
		public static const VAR_VIEWER_TYPE		:String = 'viewer_type';
		public static const VAR_AUTH_KEY		:String = 'auth_key';
		public static const VAR_API_RESULT		:String = 'api_result';
		public static const VAR_API_SETTINGS	:String = 'api_settings';
		
		public static const METHOD_GET			:String = 'get';
		public static const METHOD_POST			:String = 'post';
		
		public static const FORMAT_XML			:String = 'xml';
		public static const FORMAT_JSON			:String = 'json';
		
		private static var _vars				:Object = {};
		private static var _secret				:String = '';
		private static var _version				:String = '2.0';
		private static var _testMode			:Boolean = false;
		private static var _method				:String = METHOD_GET;
		private static var _format				:String = FORMAT_XML;
		
		/**
		 * 
		 * @param	$vars
		 */
		public static function init($vars:Object):void { _vars = $vars; }
		
		/**
		 * 
		 */
		public static function get($var:String):String { return _vars[$var]; }
		/**
		 * 
		 */
		public static function set($var:String, $value:String):void { _vars[$var] = $value; }
		
		/**
		 * 
		 */
		public static function get secret():String { return _secret; }
		/**
		 * 
		 */
		public static function set secret(value:String):void { _secret = value; }
		
		/**
		 * 
		 */
		public static function get version():String { return _version; }
		/**
		 * 
		 */
		public static function set version(value:String):void { _version = value; }
		
		/**
		 * 
		 */
		public static function get testMode():Boolean { return _testMode; }
		/**
		 * 
		 */
		public static function set testMode(value:Boolean):void { _testMode = value; }
		
		/**
		 * 
		 */
		public static function get method():String { return _method; }
		/**
		 * 
		 */
		public static function set method(value:String):void { _method = value; }
		
		/**
		 * 
		 */
		public static function get format():String { return _format; }
		/**
		 * 
		 */
		public static function set format(value:String):void { _format = value; }
		
		/**
		 * 
		 * @return
		 */
		public static function isInstalled():Boolean {
			return get(VAR_IS_APP_USER) == '1';
		}
	}
}