package ua.olexandr.social.vkontakte {
	import flash.events.Event;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class VKWrapperEvent extends Event{
		
		// Событие происходит, когда пользователь добавляет приложение к себе на страницу.
		public static const APPLICATION_ADDED:String 	= 'onApplicationAdded';
		
		// settings:Number
		// Событие происходит, когда пользователь изменяет настройки приложений. 
		// Параметр settings передаваемого объекта в функцию обратного вызова содержит в себе 
		// битовую маску выставленных значений настроек. 
		// 0 – настройки не выставлены. +1 – разрешены уведомления, 
		// +2 – разрешен доступ к друзьям, +4 – разрешен доступ к фотографиям, 
		// +8 – разрешен доступ к аудиозаписям, +32 – разрешен доступ к предложениям, 
		// +64 – разрешен доступ к вопросам.
		public static const SETTINGS_CHANGED:String 	= 'onSettingsChanged';
		
		// balance:Number
		// Событие происходит, когда пользователь положил или снял голоса с баланса приложения.
		// Параметр balance содержит текущий баланс пользователя в сотых долях голоса. 
		// Этот параметр можно использовать только для вывода пользователю. 
		// Достоверность баланса всегда нужно проверять с помощью метода secure.getBalance.
		public static const BALANCE_CHANGED:String 		= 'onBalanceChanged';
		
		// Событие происходит, когда пользователь подтвердил сохранение фотографии в окне, 
		// вызванном с помощью функции showProfilePhotoBox.
		public static const PROFILE_PHOTO_SAVE:String 	= 'onProfilePhotoSave';
		
		// width:Number, height:Number	Событие происходит, когда размер окна приложения был изменен. 
		// Параметры width и height содержат новые размеры приложения в пикселах.
		public static const WINDOW_RESIZED:String 		= 'onWindowResized';
		
		// location:String	Событие происходит, когда изменяется значение хеша 
		// после символа # в адресной строке браузера. Например, это происходит 
		// в результате использования кнопок "назад" и "вперед" в браузере. 
		// Данное событие происходит всегда при запуске приложения.
		public static const LOCATION_CHANGED:String 	= 'onLocationChanged';
		
		// Событие происходит, когда окно с приложением теряет фокус. 
		// Например, когда пользователь открывает окно с настройками приложения.
		public static const WINDOW_BLUR:String 			= 'onWindowBlur';
		
		// Событие происходит, когда окно с приложением получает фокус. 
		// Например, когда пользователь закрывает окно с настройками приложения.
		public static const WINDOW_FOCUS:String 		= 'onWindowFocus';
		
		// Событие происходит, когда пользователь переносит указатель мыши за пределы окна приложения.
		// Это событие является аналогом Event.MOUSE_LEAVE объекта stage.
		public static const MOUSE_LEAVE:String 			= 'onMouseLeave';
		
		private var _parameters:Object;
		
		private var _settings:Number;
		private var _balance:Number;
		private var _width:Number;
		private var _height:Number;
		private var _location:String;
		
		/**
		 * 
		 * @param	$type
		 * @param	$parameters
		 * @param	$bubbles
		 * @param	$cancelable
		 */
		public function VKWrapperEvent($type:String, $parameters:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false) {
			super($type, $bubbles, $cancelable);
			_parameters = $parameters;
		}
		
		/**
		 * 
		 */
		public function get settings():Number { return _parameters.settings; }
		
		/**
		 * 
		 */
		public function get balance():Number { return _parameters.balance; }
		
		/**
		 * 
		 */
		public function get width():Number { return _parameters.width; }
		
		/**
		 * 
		 */
		public function get height():Number { return _parameters.height; }
		
		/**
		 * 
		 */
		public function get location():String { return _parameters.location; }
		
	}

}