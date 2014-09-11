package ua.olexandr.tools {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ua.olexandr.constants.DateConst;
	import ua.olexandr.utils.DateUtils;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class Calendar extends EventDispatcher{
		
		private var _date:Date;
		private var _positions:Array;
		
		private var _firstDayOfWeek:int = 0;
		private var _countOfDays:int;
		
		/**
		 * 
		 * @param	$date
		 */
		public function Calendar($date:Date = null) {
			date = $date ? $date : new Date();
		}
		
		/**
		 * 
		 */
		private function update():void{
			_countOfDays = DateUtils.getDaysInMonth(month, year);
			
			_positions = [];
			for (var i:int = 0; i < _countOfDays; i++)
				_positions[i] = i + (getFirstDayOfMonth() - _firstDayOfWeek + 7) % 7;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 
		 * @param	$month
		 * @param	$year
		 * @return
		 */
		public function getFirstDayOfMonth($month:Number = NaN, $year:Number = NaN):int {
			return (new Date(	isNaN($year) ? year : $year, 
								isNaN($month) ? month : $month, 
								1)).getDay();
		}
		
		/**
		 * 
		 */
		public function get date():Date { return _date; }
		/**
		 * 
		 */
		public function set date(value:Date):void {
			_date = value;
			_date.hours = _date.minutes = _date.seconds = _date.milliseconds = 0;
			update();
		}
		
		/**
		 * 
		 */
		public function get year():Number { return _date.getFullYear(); }
		/**
		 * 
		 */
		public function set year(value:Number):void {
			_date.setFullYear(value);
			update();
		}
		
		/**
		 * 
		 */
		public function get month():Number { return _date.getMonth(); }
		/**
		 * 
		 */
		public function set month(value:Number):void {
			if (_date.getDate() > DateUtils.getDaysInMonth(value, year))
				_date.setDate(1);
			_date.setMonth(value);
			update();
		}
		
		/**
		 * 
		 */
		public function get day():Number { return _date.getDate(); }
		/**
		 * 
		 */
		public function set day(value:Number):void {
			_date.setDate(value);
		}
		
		/**
		 * 
		 */
		public function get firstDayOfWeek():int { return _firstDayOfWeek; }
		/**
		 * 
		 */
		public function set firstDayOfWeek(value:int):void {
			_firstDayOfWeek = value;
			update();
		}
		
		/**
		 * 
		 */
		public function get countOfDays():int { return _countOfDays; }
		
		/**
		 * 
		 */
		public function get positions():Array { return _positions; }
		
	}

}