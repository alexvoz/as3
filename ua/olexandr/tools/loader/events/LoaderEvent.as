package ua.olexandr.tools.loader.events {
	import flash.events.Event;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class LoaderEvent extends Event{
		
		/**
		 * Событие начала загрузки
		 */
		public static const START		:String = 'start';
		
		/**
		 * Событие получениядополнительных данных
		 */
		public static const INIT		:String = 'init';
		
		/**
		 * Событие окончания загрузки
		 */
		public static const SUCCESS		:String = 'success';
		
		/**
		 * Событие окончания ВСЕХ загрузок
		 */
		public static const FINISH		:String = 'finish';
		
		/**
		 * Событие ошибки загрузки
		 */
		public static const FAIL		:String = 'fail';
		
		/**
		 * Событие прогресса загрузки
		 */
		public static const PROGRESS	:String = 'progress';
		
		
		private var _current:int;
		
		private var _content:*;
		private var _error:String;
		
		private var _percentageTotal:Number;
		private var _percentageCurrent:Number;
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		
		/**
		 * Creates an LoaderEvent object to pass as a parameter to event listeners.
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function LoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			_current = -1;
			
			_percentageCurrent = 0;
			_percentageTotal = 0;
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * @return
		 */
		override public function clone():Event {
			var _e:LoaderEvent = new LoaderEvent(type, bubbles, cancelable);
			
			_e.current = _current;
			
			_e.content = _content;
			_e.error = _error;
			
			_e.percentageTotal = percentageTotal;
			_e.percentageCurrent = percentageCurrent;
			
			_e.bytesTotal = bytesTotal;
			_e.bytesLoaded = bytesLoaded;
			
			return _e;
		} 
		
		/**
		 * Returns a string containing all the properties of the LoaderEvent object.
		 * @return
		 */
		override public function toString():String {
			return "[LoaderEvent type=" + type + " content=" + content + " error=" + error + "]";
		}
		
		/**
		 * Индекс текущей загрузки
		 */
		public function get current():int { return _current; }
		public function set current(value:int):void { _current = value; }
		
		/**
		 * Загруженный контент
		 */
		public function set content(value:*):void { _content = value; }
		public function get content():* { return _content; }
		
		/**
		 * Текст ошибки загрузки
		 */
		public function get error():String { return _error; }
		public function set error(value:String):void { _error = value; }
		
		/**
		 * Общий прогресс загрузки
		 */
		public function get percentageTotal():Number { return _percentageTotal; }
		public function set percentageTotal(value:Number):void { _percentageTotal = value; }
		
		/**
		 * Прогресс текущей загрузки
		 */
		public function get percentageCurrent():Number { return _percentageCurrent; }
		public function set percentageCurrent(value:Number):void { _percentageCurrent = value; }
		
		/**
		 * Количество загруженных байтов текущей загрузки
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		public function set bytesTotal(value:uint):void { _bytesTotal = value; }
		
		/**
		 * Общее количество байтов текущей загрузки
		 */
		public function get bytesLoaded():uint { return _bytesLoaded; }
		public function set bytesLoaded(value:uint):void { _bytesLoaded = value; }
		
	}

}