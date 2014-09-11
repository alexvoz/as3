package ua.olexandr.social.vkontakte {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class VKService extends EventDispatcher{
		
		/**
		 * 
		 * @param	$uid
		 * @return
		 */
		public static function getProfiles($uid:String):VKDispatcher {
			var _variables:URLVariables = new URLVariables();
			_variables.api_id = VKVars.get(VKVars.VAR_API_ID);
			_variables.v = VKVars.version;
			_variables.test_mode = String(int(VKVars.testMode));
			
			_variables.method = 'getProfiles';
			_variables.fields = 'nickname,sex,bdate,city,country,timezone,photo,photo_medium,photo_big,has_mobile,rate';
			_variables.uids = $uid;
			
			_variables.sig = VKTools.createSignature(_variables);
			var _request:URLRequest = new URLRequest(VKVars.get(VKVars.VAR_API_URL));
			_request.data = _variables;
			
			var _dispatcher:VKDispatcher = new VKDispatcher(_request);
			return _dispatcher;
		}
		
		/**
		 * 
		 * @param	$user_id
		 * @param	$key
		 * @param	$value
		 * @return
		 */
		public static function putVariable($user_id:String, $key:String, $value:String):VKDispatcher {
			var _variables:URLVariables = new URLVariables();
			_variables.api_id = VKVars.get(VKVars.VAR_API_ID);
			_variables.v = VKVars.version;
			_variables.test_mode = String(int(VKVars.testMode));
			
			_variables.method = 'putVariable';
			_variables.session = '0';
			_variables.user_id = $user_id;
			_variables.key = $key;
			_variables.value = $value;
			
			_variables.sig = VKTools.createSignature(_variables);
			var _request:URLRequest = new URLRequest(VKVars.get(VKVars.VAR_API_URL));
			_request.data = _variables;
			
			var _dispatcher:VKDispatcher = new VKDispatcher(_request);
			return _dispatcher;
		}
		
		/**
		 * 
		 * @param	$user_id
		 * @param	$key
		 * @return
		 */
		public static function getVariable($user_id:String, $key:String):VKDispatcher {
			var _variables:URLVariables = new URLVariables();
			_variables.api_id = VKVars.get(VKVars.VAR_API_ID);
			_variables.v = VKVars.version;
			_variables.test_mode = String(int(VKVars.testMode));
			
			_variables.method = 'getVariable';
			_variables.session = '0';
			_variables.user_id = $user_id;
			_variables.key = $key;
			
			_variables.sig = VKTools.createSignature(_variables);
			var _request:URLRequest = new URLRequest(VKVars.get(VKVars.VAR_API_URL));
			_request.data = _variables;
			
			var _dispatcher:VKDispatcher = new VKDispatcher(_request);
			return _dispatcher;
		}
		
		/**
		 * 
		 * @param	$script
		 * @return
		 */
		public static function execute($script:String):VKDispatcher {
			var _variables:URLVariables = new URLVariables();
			_variables.api_id = VKVars.get(VKVars.VAR_API_ID);
			_variables.v = VKVars.version;
			_variables.test_mode = String(int(VKVars.testMode));
			
			_variables.method = 'execute';
			_variables.code = $script;
			
			_variables.sig = VKTools.createSignature(_variables);
			var _request:URLRequest = new URLRequest(VKVars.get(VKVars.VAR_API_URL));
			_request.data = _variables;
			
			var _dispatcher:VKDispatcher = new VKDispatcher(_request);
			return _dispatcher;
		}
		
		
		
		/*	
		* getFriends – возвращает список id друзей текущего пользователя.
		* getAppFriends – возвращает список id друзей текущего пользователя, которые установили данное приложение.
		* getUserBalance – возвращает баланс текущего пользователя в данном приложении.
		* getUserSettings – возвращает настройки приложения текущего пользователя.
		* getGroupsnew – возвращает список id групп, в которых состоит текущий пользователь.
		* getGroupsFullnew – возвращает базовую информацию о группах, в которых состоит текущий пользователь.

		Фотографии
		* photos.getAlbums – возвращает список альбомов пользователя.
		* photos.get – возвращает список фотографий в альбоме.
		* photos.getByIdnew – возвращает информацию о фотографиях.
		* photos.createAlbum – создает пустой альбом для фотографий.
		* photos.getUploadServer – возвращает адрес сервера для загрузки фотографий.
		* photos.save – сохраняет фотографии после успешной загрузки.
		* photos.getProfileUploadServernew – возвращает адрес сервера для загрузки фотографии на страницу пользователя.
		* photos.saveProfilePhotonew – сохраняет фотографию страницы пользователя после успешной загрузки.

		Аудиозаписи
		* audio.get – возвращает список аудиозаписей пользователя.
		* audio.getUploadServer – возвращает адрес сервера для загрузки аудиозаписей.
		* audio.save – сохраняет аудиозаписи после успешной загрузки.
		* audio.search (experimental) – осуществляет поиск по аудиозаписям.

		Географические объекты
		* getCities – возвращает информацию о городах по их id.
		* getCountries – возвращает информацию о странах по их id.

		Методы, требующие наличия стороннего сервера
		* secure.sendNotification – отправляет уведомление пользователю.
		* secure.saveAppStatus – сохраняет строку статуса приложения для последующего вывода в общем списке приложений на странице пользоваетеля.
		* secure.getAppStatus – возвращает строку статуса приложения, сохранённую при помощи secure.saveAppStatus.
		* secure.getAppBalance – возвращает платежный баланс приложения.
		* secure.getBalance – возвращает баланс пользователя на счету приложения.
		* secure.addVotes – переводит голоса со счета приложения на счет пользователя.
		* secure.withdrawVotes – списывает голоса со счета пользователя на счет приложения.
		* secure.transferVotes – переводит голоса со счета одного пользователя на счет другого в рамках приложения.
		* secure.getTransactionsHistory – возвращает историю транзакций внутри приложения.
		* secure.getSMSHistory – возвращает список SMS-уведомлений, отосланных приложением.
		* secure.sendSMSNotificationnew – отправляет SMS-уведомление на телефон пользователя.
		* secure.addRatingnew – поднимает пользователю рейтинг от имени приложения.
		* secure.setCounternew – устанавливает счетчик, который выводится пользователю жирным шрифтом в левом меню, если он добавил приложение в левое меню.

		Другие методы
		* getVariable – возвращает значение хранимой переменной.
		* getVariables – возвращает значения нескольких переменных.
		* putVariable – записывает значение переменной.
		* getHighScores – возвращает таблицу рекордов.
		* setUserScore – записывает результат текущего пользователя в таблицу рекордов.
		* getMessages – возвращает список очереди сообщений.
		* sendMessage – ставит сообщение в очередь.
		* getServerTime – возвращает текущее время.
		* getAds – возвращает рекламные объявления для показа пользователям.
		*/
		
	}

}