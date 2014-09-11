package ua.olexandr.constants {
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class RegExpConst {
		
		//public static const FIND_URL:RegExp = new RegExp('https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?', 'gi');
		
		//public static const TEST_DATE:RegExp = /([0-2]\d|3[01])\.(0\d|1[012])\.(\d{4})/;
		
		
		public static const REMOVE_HTML:RegExp = new RegExp('<[^>]*>', 'gi');
		
		/**
		 * Проверка валидности email
		 */
		public static const EMAIL:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
		
		/**
		 * Проверка валидности телефоного номера формата +7 (###) ###-##-## скобки, пробелы или тире могут отсутствовать
		 */
		public static const PHONE:RegExp = /^\+7 \([0-9]{3}\) [0-9]{3}\-[0-9]{2}\-[0-9]{2}$/;
		
		/**
		 * Проверка даты, формат - ##/##/#### или ##-##-#### или ##.##.####, день и месяц могут быть 1 или 2 числеными, год 2 или 4 численым и начинать с 19 или 20
		 */
		public static const DATE:RegExp = /\d{1,2}(\/|\-|\.)\d{1,2}(\/|\-|\.)(\d{2}|(19|20)\d{2})$/;
		
		/**
		 * Проверка валидности пароля, 6-15 символов, латиница и цифры
		 */
		public static const PASSWORD:RegExp = /^[a-z0-9\-]{3,30}$/i;
		
		/**
		 * Проверка валидности имени(фамилии), 3-30 символов
		 */
		public static const RUSSIAN_NAME:RegExp =/^[а-я]{3,30}$/i;
		
		/**
		 * Проверка валидности имени(фамилии), 3-30 символов
		 */
		public static const ENGLISH_NAME:RegExp = /^[а-z]{3,30}$/i;
		
		/**
		 * Проверка валидности URL
		 */
		//public static const URL:RegExp = /^(http|https|ftp)://([A-Z0-9][A-Z0-9_-]*(?:.[A-Z0-9][A-Z0-9_-]*)+):?(d+)?/?/i;
		
	}

}
