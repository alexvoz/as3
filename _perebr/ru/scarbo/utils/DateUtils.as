package ru.scarbo.utils 
{
	/**
	 * ...
	 * @author scarbo
	 */
	public class DateUtils
	{
		public static const MS_SECUND:uint = 1000;
		public static const MS_MINUTE:uint = 60 * 1000;
		public static const MS_HOUR:uint = 60 * 60 * 1000;
		public static const MS_DAY:uint = 24 * 60 * 60 * 1000;
		
		public static const RUSSIAN_MONTH:Array = [
			'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
		];
		public static const ENGLISH_MONTH:Array = [
			'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
		];
		
		
		public static function getCountDays(date:Date):uint{
			if(date == null) date = new Date();
			var days_arr:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
			var year:uint = date.getFullYear();
			var month:uint = date.getMonth();
			if(year%4 == 0 && month == 2){
				return uint(days_arr[month]) + 1;
			}else{
				return uint(days_arr[month]);
			}
		}
		
		/**
		 * @example				:получаем строку вида 0000-00-00 00:00:00
		 * @param	date		:объект Date
		 */
		public static function dateToString(date:Date):String {
			var year:String = String(date.getFullYear());
			var month:String = withLeadingZeros(date.getMonth() + 1);
			var day:String = withLeadingZeros(date.getDate());
			var hour:String = withLeadingZeros(date.getHours());
			var minute:String = withLeadingZeros(date.getMinutes());
			var second:String = withLeadingZeros(date.getSeconds());
			
			return year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second;
		}
		
		/**
		 * @example				:получаем объект Date
		 * @param	value		:строка вида 0000-00-00 00:00:00
		 */
		public static function stringToDate(value:String):Date {
			if(value){
				var reg:RegExp = /(\d{2,4})-(\d{1,2})-(\d{1,2})\s?(\d{0,2}):?(\d{0,2}):?(\d{0,2})/;
				var date_str:String = value.replace(reg, '$2/$3/$1 $4:$5:$6');
				return new Date(date_str);
			}else{
				return null;
			}
		}
		
		
		/**
		 * @example				:получаем имя месяца
		 * @param	date		:объект Date
		 * @param	local		:язык
		 */
		public static function getMonthAsString(date:Date, local:String):String {
			var str:String;
			switch(local) {
				case 'rus':
				str = RUSSIAN_MONTH[date.getMonth()];
				break;
				
				case 'eng':
				str = ENGLISH_MONTH[date.getMonth()];
				break;
			}
			return str;
		}
		public static function getShortMonthAsString(date:Date, local:String):String {
			var str:String;
			switch(local) {
				case 'rus':
				str = RUSSIAN_MONTH[date.getMonth()];
				break;
				
				case 'eng':
				str = ENGLISH_MONTH[date.getMonth()];
				break;
			}
			return str.slice(0, 3);
		}
		
		/**
		 * @example				:сравниваем даты
		 * @param	a			:Date 1
		 * @param	b			:Date 2
		 */
		public static function isEqual(a:Date, b:Date):Boolean {
			return a.getTime() == b.getTime() ? true : false;
		}
		
		/**
		 * @example				:вычисляем разницу между 2 датами
		 * @param	a			:Date 1
		 * @param	b			:Date 2
		 */
		public static function betweenDates(a:Date, b:Date):Number {
			var aNum:uint = a.getTime();
			var bNum:uint = b.getTime();
			return aNum > bNum ? aNum - bNum : bNum - aNum;
		}
		
		
		public static function getDateAgoAsString(a:Date, b:Date, local:String):String {
			var str:String;
			var ms:Number = b.getTime() - a.getTime();
			var s:uint = uint(ms / MS_SECUND);
			var m:uint = uint(ms / MS_MINUTE);
			var h:uint = uint(ms / MS_HOUR);
			var d:uint = uint(ms / MS_DAY);
			//trace(d, h, m);
			switch(local) {
				case 'rus':
				//
				if (d > 20 && d % 10 == 1) {
					str = d + ' день назад';
				}
				else if (d >= 5 && (d % 10 >= 5 && d % 10 <= 9 || d % 10 == 0)) {
					str = d + ' дней назад';
				}
				else if ((d > 1 && d < 5) || (d > 20 && (d % 10 > 1 && d % 10 < 5))) {
					str = d + ' дня назад';
				}
				else if (d == 1) {
					str = 'вчера';
				}
				//
				else if (h > 0 && h < 24) {
					if (h == 1 || h == 21) {
						str = h + ' час назад';
					}
					else if ((h >= 2 && h < 5) || h >= 22 && h < 24) {
						str = h + ' часа назад';
					}
					else if (h >= 5 && h <= 20) {
						str = h + ' часов назад';
					}	
				}
				//
				else if (m >= 0 && m < 60) {
					if (m == 0) {
						str = 'только что';
					}
					else if (m == 1 || (m > 20 && m % 10 == 1)) {
						str = m + ' минуту назад';
					}
					else if (m >= 2 && m <= 4 || (m > 20 && m % 10 >= 2 && m % 10 <= 4)) {
						str = m + ' минуты назад';
					}
					else if (m >= 5 && (m % 10 >= 5 && m % 10 <= 9 || m % 10 == 0)) {
						str = m + ' минут назад';
					}
				}
				break;
				
				case 'eng':
				//
				if (d > 1) {
					str = d + ' day ago';
				}
				else if (d == 1) {
					str = 'yesterday';
				}
				//
				else if (h > 0 && h < 24) {
					str = h + ' hour ago';
				}
				//
				else if (m >= 0 && m < 60) {
					if (m == 0) {
						str = 'now';
					}else {
						str = m + ' minute ago';
					}
				}
				break;
			}
			return str;
		}
		
		public static function withLeadingZeros(value:uint):String{
			return value < 10 ? '0' + value.toString() : value.toString();
		}
		
	}

}