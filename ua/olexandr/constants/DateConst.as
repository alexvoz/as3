package ua.olexandr.constants {
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class DateConst{
		
		/**
		 * Количество дней в невисокосном году
		 */
		public static const MONTH_DAYS:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		
		/**
		 * Украинские названия месяцев
		 */
		public static const MONTH_NAMES_UA:Array = ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'];
		/**
		 * Русские названия месяцев
		 */
		public static const MONTH_NAMES_RU:Array = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];
		/**
		 * Английские названия месяцев
		 */
		public static const MONTH_NAMES_EN:Array = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
		/**
		 * Получить название месяца
		 * @param	locale
		 * @return
		 */
		public static function getMonthNames(locale:String):Array {
			switch (locale) {
				case LocaleConst.UA: {
					return MONTH_NAMES_UA;
					break;
				}
				case LocaleConst.RU: {
					return MONTH_NAMES_RU;
					break;
				}
				case LocaleConst.EN: {
					return MONTH_NAMES_EN;
					break;
				}
				default: {
					return null;
					break;
				}
			}
		}
		
		/**
		 * Украинские названия месяцев в родительном падеже
		 */
		public static const MONTH_NAMES_GENITIVUS_UA:Array = ['Січня', 'Лютого', 'Березня', 'Квітня', 'Травня', 'Червня', 'Липня', 'Серпня', 'Вересня', 'Жовтня', 'Листопада', 'Грудня'];
		/**
		 * Русские названия месяцев в родительном падеже
		 */
		public static const MONTH_NAMES_GENITIVUS_RU:Array = ['Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'];
		/**
		 * Английские названия месяцев в родительном падеже
		 */
		public static const MONTH_NAMES_GENITIVUS_EN:Array = ['of January', 'of February', 'of March', 'of April', 'of May', 'of June', 'of July', 'of August', 'of September', 'of October', 'of November', 'of December'];
		/**
		 * Получить название месяца в родительном падеже
		 * @param	locale
		 * @return
		 */
		public static function getMonthNamesGenitivus(locale:String):Array {
			switch (locale) {
				case LocaleConst.UA: {
					return MONTH_NAMES_GENITIVUS_UA;
					break;
				}
				case LocaleConst.RU: {
					return MONTH_NAMES_GENITIVUS_RU;
					break;
				}
				case LocaleConst.EN: {
					return MONTH_NAMES_GENITIVUS_EN;
					break;
				}
				default: {
					return null;
					break;
				}
			}
		}
		
		/**
		 * Украинские короткие названия дней
		 */
		public static const DAY_SHORT_NAMES_UA:Array = ['Нд', 'Пн', 'Вв', 'Ср', 'Чт', 'Пт', 'Сб'];
		/**
		 * Русские короткие названия дней
		 */
		public static const DAY_SHORT_NAMES_RU:Array = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
		/**
		 * Английские короткие названия дней
		 */
		public static const DAY_SHORT_NAMES_EN:Array = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
		/**
		 * Получить короткое название дня
		 * @param	locale
		 * @return
		 */
		public static function getDayShortNames(locale:String):Array {
			switch (locale) {
				case LocaleConst.UA: {
					return DAY_SHORT_NAMES_UA;
					break;
				}
				case LocaleConst.RU: {
					return DAY_SHORT_NAMES_RU;
					break;
				}
				case LocaleConst.EN: {
					return DAY_SHORT_NAMES_EN;
					break;
				}
				default: {
					return null;
					break;
				}
			}
		}
		
	}

}