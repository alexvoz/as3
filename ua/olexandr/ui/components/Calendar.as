package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="select",type="flash.events.Event")]
	public class Calendar extends Panel {
		protected var _dateLabel:Label;
		protected var _day:int;
		protected var _dayButtons:Array = new Array();
		protected var _month:int;
		protected var _monthNames:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		protected var _selection:Shape;
		protected var _year:int;
		
		public function Calendar() {
			super();
		}
		
		public function setDate(date:Date):void {
			_year = date.fullYear;
			_month = date.month;
			_day = date.date;
			var startDay:int = new Date(_year, _month, 1).day;
			var endDay:int = getEndDay(_month, _year);
			for (var i:int = 0; i < 42; i++) {
				_dayButtons[i].visible = false;
			}
			for (i = 0; i < endDay; i++) {
				var btn:PushButton = _dayButtons[i + startDay];
				btn.visible = true;
				btn.label = (i + 1).toString();
				btn.tag = i + 1;
				if (i + 1 == _day) {
					_selection.x = btn.x;
					_selection.y = btn.y;
				}
			}
			
			_dateLabel.text = _monthNames[_month] + "  " + _year;
			_dateLabel.draw();
			_dateLabel.x = (width - _dateLabel.width) / 2;
		}
		
		public function setYearMonthDay(year:int, month:int, day:int):void {
			setDate(new Date(year, month, day));
		}
		
		public function get selectedDate():Date {
			return new Date(_year, _month, _day);
		}
		
		public function get month():int {
			return _month;
		}
		
		public function get year():int {
			return _year;
		}
		
		public function get day():int {
			return _day;
		}
		
		
		protected override function init():void {
			super.init();
			setSize(140, 140);
			var today:Date = new Date();
			setDate(today);
		}
		
		protected override function addChildren():void {
			super.addChildren();
			for (var i:int = 0; i < 6; i++) {
				for (var j:int = 0; j < 7; j++) {
					var btn:PushButton = new PushButton();
					btn.setSize(19, 19);
                    btn.move(j * 20, 20 + i * 20);
                    this.content.addChild(btn);
					btn.addEventListener(MouseEvent.CLICK, onDayClick);
					_dayButtons.push(btn);
				}
			}
			
			_dateLabel = new Label();
            _dateLabel.autoSize = true;
            _dateLabel.move(25, 0);
            this.content.addChild(_dateLabel);
			
			var prevYearBtn:PushButton = new PushButton("«");
			prevYearBtn.setSize(14, 14);
            prevYearBtn.move(2, 2);
            this.content.addChild(prevYearBtn);
            prevYearBtn.addEventListener(MouseEvent.CLICK, onPrevYear);
			
			var prevMonthBtn:PushButton = new PushButton("<");
			prevMonthBtn.setSize(14, 14);
            prevMonthBtn.move(17, 2);
            this.content.addChild(prevMonthBtn);
            prevMonthBtn.addEventListener(MouseEvent.CLICK, onPrevMonth);
			
			var nextMonthBtn:PushButton = new PushButton(">");
			nextMonthBtn.setSize(14, 14);
            nextMonthBtn.move(108, 2);
            this.content.addChild(nextMonthBtn);
            nextMonthBtn.addEventListener(MouseEvent.CLICK, onNextMonth);
			
			var nextYearBtn:PushButton = new PushButton("»");
			nextYearBtn.setSize(14, 14);
            nextYearBtn.move(124, 2);
            this.content.addChild(nextYearBtn);
            nextYearBtn.addEventListener(MouseEvent.CLICK, onNextYear);
			
			_selection = new Shape();
			_selection.graphics.beginFill(0, 0.15);
			_selection.graphics.drawRect(1, 1, 18, 18);
			this.content.addChild(_selection);
		}
		
		protected function getEndDay(month:int, year:int):int {
			switch (month) {
				case 0: // jan
				case 2: // mar
				case 4: // may
				case 6: // july
				case 7: // aug
				case 9: // oct
				case 11: // dec
					return 31;
					break;
				
				case 1: // feb
					if ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
						return 29;
					return 28;
					break;
				
				default: 
					break;
			}
			// april, june, sept, nov.
			return 30;
		}
		
		protected function onNextMonth(event:MouseEvent):void {
			_month++;
			if (_month > 11) {
				_month = 0;
				_year++;
			}
			_day = Math.min(_day, getEndDay(_month, _year));
			setYearMonthDay(_year, _month, _day);
		}
		
		protected function onPrevMonth(event:MouseEvent):void {
			_month--;
			if (_month < 0) {
				_month = 11;
				_year--;
			}
			_day = Math.min(_day, getEndDay(_month, _year));
			setYearMonthDay(_year, _month, _day);
		}
		
		protected function onNextYear(event:MouseEvent):void {
			_year++;
			_day = Math.min(_day, getEndDay(_month, _year));
			setYearMonthDay(_year, _month, _day);
		}
		
		protected function onPrevYear(event:MouseEvent):void {
			_year--;
			_day = Math.min(_day, getEndDay(_month, _year));
			setYearMonthDay(_year, _month, _day);
		}
		
		protected function onDayClick(event:MouseEvent):void {
			_day = event.target.tag;
			setYearMonthDay(_year, _month, _day);
			dispatchEvent(new Event(Event.SELECT));
		}
		
	}
}