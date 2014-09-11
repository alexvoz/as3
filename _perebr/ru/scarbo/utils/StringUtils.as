package ru.scarbo.utils 
{
	
	/**
	 * ...
	 * @author scarbo
	 */
	public class StringUtils 
	{
		
		public static const EMAIL_PATTERN:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
		public static const PHONE_PATTERN:RegExp = /^\+7 \([0-9]{3}\) [0-9]{3}\-[0-9]{2}\-[0-9]{2}$/;
		//public static const PHONE_PATTERN:RegExp = /^(\([2-9]\d{2}\)[- .])?\d{3}[- .](\d{4}|\d{2}[- ]\d{2})$/g;
		//public static const PHONE_PATTERN:RegExp = /(\(\s*\d{3}\s*\)|(\d{3}\s*-?))?\s*\d{3}\s*-?\s*\d{2}\s*-?\s*\d{2}$/;
		public static const DATE_PATTERN:RegExp = /\d{1,2}(\/|\-|\.)\d{1,2}(\/|\-|\.)(\d{2}|(19|20)\d{2})$/;
		public static const PASS_PATTERN:RegExp = /^[a-z0-9\-]{3,30}$/i;
		public static const RUSSIAN_NAME:RegExp = /^[а-я]{3,30}$/i;
		public static const ENGLISH_NAME:RegExp = /^[а-z]{3,30}$/i;
		
		public function StringUtils() 
		{
		}
		
		/**
		 * @example            :проверка валидности E-mail
		 * @param	value
		 * @return
		 */
		public static function checkEmail(value:String):Boolean {
			if (!isset(value)) return false;
			return EMAIL_PATTERN.test(value);
		}
		
		/**
		 * @example            :проверка валидности телефоного номера формата +7 (###) ###-##-## скобки, пробелы или тире могут отсутствовать
		 * @param	value
		 * @return
		 */
		public static function checkPhone(value:String):Boolean {
			if (!isset(value)) return false;
			return PHONE_PATTERN.test(value);
		}
		
		/**
		 * @example           :проверка даты, формат - ##/##/#### или ##-##-#### или ##.##.####, день и месяц могут быть 1 или 2 числеными, год 2 или 4 численым и начинать с 19 или 20
		 * @param	value
		 * @return
		 */
		public static function checkDate(value:String):Boolean {
			if (!isset(value)) return false;
			return DATE_PATTERN.test(value);
		}
		
		/**
		 * @example            :проверка валидности пароля, 6-15 символов, латиница и цифры
		 * @param	value
		 * @return
		 */
		public static function checkPass(value:String):Boolean {
			if (!isset(value)) return false;
			return PASS_PATTERN.test(value);
		}
		
		/**
		 * @example            :проверка валидности имени(фамилии), 3-30 символов
		 * @param	value
		 * @return
		 */
		public static function checkName(value:String, local:String):Boolean {
			if (!isset(value)) return false;
			switch(local) {
				case 'rus':
				return RUSSIAN_NAME.test(value);
				break;
				
				case 'eng':
				return ENGLISH_NAME.test(value);
				break;
				
				default:
				return false;
			}
		}
		
		/**
		 * @example            :проверяет равенство 2 строк
		 * @param	value1     :1 строка
		 * @param	value2     :2 строка
		 * @param	toCase     :регистрозависимость
		 * @return
		 */
		public static function isEqual(value1:String, value2:String, toCase:Boolean = false):Boolean {
			if (!isset(value1) || !isset(value2)) return false;
			return toCase ? value1.toUpperCase() == value2.toUpperCase() : value1 == value2;
		}
		
		/**
		 * @example            :проверка на "пустоту" строки
		 * @param	value
		 * @return
		 */
		public static function isset(value:String):Boolean {
			return (value != null && value.length > 0);
		}
		
		/**
		 * @example            :удаляет пробелы в начале и в конце строки
		 * @param	value
		 * @return
		 */
		public static function trim(value:String):String {
			if (!isset(value)) return null;
			value = value.replace(/^\s+|\s+$/g, '');
			return value;
		}
		
		/**
		 * @example            :экранирует спец-символы
		 * @param	value
		 * @return
		 */
		public static function replaceTags(value:String):String {
			if (!isset(value)) return null;
			value = value.replace(/</g, '&lt;');
			value = value.replace(/>/g, '&gt;');
			value = value.replace(/"/g, '&quot;');
			return value;
		}
		
		/**
		 * @example            :удаляем html разметку
		 * @param	value
		 * @return
		 */
		public static function stripTags(value:String):String {
			if (!isset(value)) return null;
			value = value.replace(/<[^>]*>/g, '');
			return value;
		}
		
		/**
		 * @example           :заменяет ссылки вида - http://www.adobe.com на - <a href="http://www.adobe.com>http://www.adobe.com</a>
		 * @param	value
		 * @return
		 */
		public static function toHrefLink(value:String):String {
			if (!isset(value)) return null;
			return value.replace(/(https|http|ftp):\/\/\S+[^\s.,>)\];'\"!?]/ig, '<a href="$&">$&</a>');
		}
		
		/**
		 * @example            :заменяет адресс e-mail на ссылку для открытия почтового клиента
		 * @param	value
		 * @return
		 */
		public static function toMailLink(value:String):String {
			if (!isset(value)) return null;
			return value.replace(/[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]/ig, '<a href="mailto:$&">$&</a>');
		}
		
		/**
		 * @example				:возвращает базовый Url домена
		 * @param	value
		 * @return
		 */
		public static function getBaseUrl(value:String):String {
			if (!isset(value)) return null;
			value = StringUtils.remove(value, 'http://');
			return 'http://' + value.split('/')[0];
		}
		
		/**
		 * @example				:обрезает слишком длинную строку и дополняет многоточием
		 * @param	value		:строка
		 * @param	limit		:кол-во символов
		 */
		public static function stringLimit(value:String, limit:uint):String{
			if (!isset(value)) return null;
			return value.length > limit ? value.slice(0, limit) + '...' : value;
		}
		
		/**
		 * @example				:возвращает строку, в которой первый символ переведен в верхний регистр
		 * @param	value		:строка
		 */
		public static function ucFirst(value:String):String {
			if (!isset(value)) return null;
			return value.charAt(0).toUpperCase() + value.slice(1, value.length);
		}
		
		/**
		 * @example				:преобразует в верхний регистр первый символ каждого слова в строке
		 * @param	value		:строка
		 */
		public static function ucWords(value:String):String {
			if (!isset(value)) return null;
			return value.replace(/(\S+)/ig, ucwordsFunc);
		}
		private static function ucwordsFunc():String {
			return ucFirst(arguments[1]);
		}
		
		/**
		 * @example				:возвращает строку, в которой порядок символов изменен на обратный
		 * @param	value		:строка
		 */
		public static function strRev(value:String):String {
			return value.split('').reverse().join('');
		}
		
		/**
		 * @example				:возвращает строку, с вырезанной подстрокой
		 * @param	value		:строка
		 * @param	remove		:вырезаемая строка
		 */
		public static function remove(value:String, remove:String):String {
			return value.split(remove).join('');
		}
	}
	
}