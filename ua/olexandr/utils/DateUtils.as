package ua.olexandr.utils {
	import ua.olexandr.constants.DateConst;
	import ua.olexandr.constants.LocaleConst;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class DateUtils {
		
		public static const HOUR_IN_DAY			:int = 24;
		public static const MINUTES_IN_HOUR		:int = 60;
		public static const MINUTES_IN_DAY		:int = MINUTES_IN_HOUR * HOUR_IN_DAY;
		public static const SECONDS_IN_MINUTE	:int = 60;
		public static const SECONDS_IN_HOUR		:int = SECONDS_IN_MINUTE * MINUTES_IN_HOUR;
		public static const SECONDS_IN_DAY		:int = SECONDS_IN_HOUR * HOUR_IN_DAY;
		public static const MSECONDS_IN_SECOND	:int = 1000;
		public static const MSECONDS_IN_MINUTE	:int = MSECONDS_IN_SECOND * SECONDS_IN_MINUTE;
		public static const MSECONDS_IN_HOUR	:int = MSECONDS_IN_MINUTE * MINUTES_IN_HOUR;
		public static const MSECONDS_IN_DAY		:int = MSECONDS_IN_HOUR * HOUR_IN_DAY;
		
		public static const DD_MM_YYYY			:String = 'dd_mm_yyyy';
		public static const HH_MM_SS_MS			:String = 'hh_mm_ss_ms';
		public static const HH_MM_SS			:String = 'hh_mm_ss';
		public static const HH_MM				:String = 'hh_mm';
		public static const MM_SS				:String = 'mm_ss';
		
		
		/**
		 * 
		 * @param	date
		 * @param	format
		 * @return
		 */
		[Inline]
		public static function parse(date:String = null, format:String = 'dd_mm_yyyy'):Date {
			var _arr:Array;
			var _date:Date;
			if (date) {
				switch (format) {
					case DD_MM_YYYY: {
						_arr = date.split('.');
						_date = new Date(int(_arr[2]), int(_arr[1]) - 1, int(_arr[0]), 0, 0, 0, 0);
						break;
					}
					case HH_MM_SS_MS: {
						_arr = date.split(':');
						_date = new Date();
						_date.hours = int(_arr[0]);
						_date.minutes = int(_arr[1]);
						_date.seconds = int(_arr[2]);
						_date.milliseconds = int(_arr[3]);
						break;
					}
					case HH_MM_SS: {
						_arr = date.split(':');
						_date = new Date();
						_date.hours = int(_arr[0]);
						_date.minutes = int(_arr[1]);
						_date.seconds = int(_arr[2]);
						_date.milliseconds = 0;
						break;
					}
					case HH_MM: {
						_arr = date.split(':');
						_date = new Date();
						_date.hours = int(_arr[0]);
						_date.minutes = int(_arr[1]);
						_date.seconds = 0;
						_date.milliseconds = 0;
						break;
					}
					case MM_SS: {
						_arr = date.split(':');
						_date = new Date();
						_date.hours = 0;
						_date.minutes = int(_arr[0]);
						_date.seconds = int(_arr[1]);
						_date.milliseconds = 0;
						break;
					}
					default: {
						break;
					}
				}
			}
			return _date;
		}
		
		/**
		 * 
		 * @param	date
		 * @param	format
		 * @return
		 */
		[Inline]
		public static function getString(date:Date = null, format:String = 'dd_mm_yyyy'):String {
			var _str:String;
			var _date:Date = date ? date : new Date();
			
			switch (format) {
				case DD_MM_YYYY: {
					_str = 	StringUtils.setLength(_date.date.toString(), 2) + '.' + StringUtils.setLength((_date.month + 1).toString(), 2) + '.' + _date.fullYear;
					break;
				}
				case HH_MM_SS_MS: {
					_str = StringUtils.setLength(_date.hours.toString(), 2) + ':' + StringUtils.setLength(_date.minutes.toString(), 2) + ':' + StringUtils.setLength(_date.seconds.toString(), 2) + '.' + StringUtils.setLength(_date.milliseconds.toString(), 3);
					break;
				}
				case HH_MM_SS: {
					_str = StringUtils.setLength(_date.hours.toString(), 2) + ':' + StringUtils.setLength(_date.minutes.toString(), 2) + ':' + StringUtils.setLength(_date.seconds.toString(), 2);
					break;
				}
				case HH_MM: {
					_str = StringUtils.setLength(_date.hours.toString(), 2) + ':' + StringUtils.setLength(_date.minutes.toString(), 2);
					break;
				}
				case MM_SS: {
					_str = StringUtils.setLength(_date.minutes.toString(), 2) + ':' + StringUtils.setLength(_date.seconds.toString(), 2);
					break;
				}
			}
			
			return _str;
		}
		
		
		/**
		 * получить разницу между датами в милисекундах
		 * @param	$dateStart
		 * @param	$dateEnd
		 * @return
		 */
		[Inline]
		public static function getDifferenceOfDates(start:Date, end:Date = null):Number {
			if (!end)
				end = new Date();
			
			return end.valueOf() - start.valueOf();
		}
		
		/**
		 * получить увеличенную дату
		 * @param	$dateStart
		 * @param	$mseconds
		 * @return
		 */
		[Inline]
		public static function getAggregateDate(date:Date, years:Number = 0, months:Number = 0, days:Number = 0, hours:Number = 0, minutes:Number = 0, seconds:Number = 0, milliseconds:Number = 0):Date {
			var _date:Date = new Date(date.getTime());
			_date.setFullYear(_date.getFullYear() + years);
			_date.setMonth(_date.getMonth() + months);
			_date.setDate(_date.getDate() + days);
			_date.setHours(_date.getHours() + hours);
			_date.setMinutes(_date.getMinutes() + minutes);
			_date.setSeconds(_date.getSeconds() + seconds);
			_date.setMilliseconds(_date.getMilliseconds() + milliseconds);
			return _date;
		}
		
		
		/**
		 * Получить имя месяца
		 * @param	$month
		 * @param	$locale
		 * @param	$genitivus
		 * @return
		 */
		[Inline]
		public static function getNameOfMonth(month:int, locale:String = 'en', genitivus:Boolean = false):String {
			return genitivus ? DateConst.getMonthNamesGenitivus(locale)[month] : DateConst.getMonthNames(locale)[month];
		}
		
		/**
		 * Получить короткое имя дня недели
		 * @param	$day
		 * @param	$locale
		 * @return
		 */
		[Inline]
		public static function getShortNameOfDay(day:int, locale:String = 'en'):String {
			return DateConst.getDayShortNames(locale)[day];
		}
		
		/**
		 * Получить количество дней в месяце
		 * @param	$month
		 * @param	$year
		 * @return
		 */
		[Inline]
		public static function getDaysInMonth(month:int, year:uint):int {
			if (isLeapYear(year) && month == 1)
				return 29;
			return DateConst.MONTH_DAYS[month];
		}
		
		/**
		 * Получить количество дней в году
		 * @param	$month
		 * @param	$year
		 * @return
		 */
		[Inline]
		public static function getDaysInYear(year:uint):int {
			return isLeapYear(year) ? 366 : 365;
		}
		
		
		/**
		 * Определение високосного года
		 * @param	$year
		 * @return
		 */
		[Inline]
		public static function isLeapYear(year:uint):Boolean {
			return !(year % 4) && (year % 100) || !(year % 400);
		}
		
		/**
		 * Номер дня в году
		 * @param	date
		 * @return
		 */
		[Inline]
		public static function dayOfYear(date:Date):uint {
			var _date:Date = new Date(date.fullYear, 0, 1);
			return Math.floor((date.time - _date.time) / 86400000);
		}
		
		/**
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		[Inline]
		public static function isEqual(a:Date, b:Date):Boolean {
			return a.getTime() == b.getTime();
		}
		
		/**
		 * 
		 * @param	a
		 * @param	b
		 * @param	locale
		 * @return
		 */
		[Inline]
		public static function getDateAgoAsString(a:Date, b:Date, locale:String = 'en'):String {
			var _str:String;
			var _msec:Number = b.getTime() - a.getTime();
			var _sec:uint = uint(_msec / MSECONDS_IN_SECOND);
			var _min:uint = uint(_msec / MSECONDS_IN_MINUTE);
			var _hours:uint = uint(_msec / MSECONDS_IN_HOUR);
			var _days:uint = uint(_msec / MSECONDS_IN_DAY);
			
			switch (locale) {
				case LocaleConst.RU: {
					if (_days > 20 && _days % 10 == 1) {
						_str = _days + ' день назад';
					} else if (_days >= 5 && (_days % 10 >= 5 && _days % 10 <= 9 || _days % 10 == 0)) {
						_str = _days + ' дней назад';
					} else if ((_days > 1 && _days < 5) || (_days > 20 && (_days % 10 > 1 && _days % 10 < 5))) {
						_str = _days + ' дня назад';
					} else if (_days == 1) {
						_str = 'вчера';
					} else if (_hours > 0 && _hours < 24) {
						if (_hours == 1 || _hours == 21) {
							_str = _hours + ' час назад';
						} else if ((_hours >= 2 && _hours < 5) || _hours >= 22 && _hours < 24) {
							_str = _hours + ' часа назад';
						} else if (_hours >= 5 && _hours <= 20) {
							_str = _hours + ' часов назад';
						}
					} else if (_min >= 0 && _min < 60) {
						if (_min == 0) {
							_str = 'только что';
						} else if (_min == 1 || (_min > 20 && _min % 10 == 1)) {
							_str = _min + ' минуту назад';
						} else if (_min >= 2 && _min <= 4 || (_min > 20 && _min % 10 >= 2 && _min % 10 <= 4)) {
							_str = _min + ' минуты назад';
						} else if (_min >= 5 && (_min % 10 >= 5 && _min % 10 <= 9 || _min % 10 == 0)) {
							_str = _min + ' минут назад';
						}
					}
					break;
				}
				case LocaleConst.EN: {
					if (_days > 1) {
						_str = _days + ' day ago';
					} else if (_days == 1) {
						_str = 'yesterday';
					} else if (_hours > 0 && _hours < 24) {
						_str = _hours + ' hour ago';
					} else if (_min >= 0 && _min < 60) {
						_str = (_min == 0) ? 'now' : (_min + ' minute ago');
					}
					break;
				}
			}
			
			return _str;
		}
	
	}

}