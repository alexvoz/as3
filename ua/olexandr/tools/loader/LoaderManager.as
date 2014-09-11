package ua.olexandr.tools.loader {
	import flash.events.EventDispatcher;
	import ua.olexandr.tools.loader.events.LoaderEvent;
	import ua.olexandr.tools.loader.loaders.ILoader;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	
	[Event(name="start", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="success", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="finish", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="fail", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="progress", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	public class LoaderManager extends EventDispatcher {
		
		private var _maxStreams:uint;
		private var _loaders:Array;
		private var _streams:Array;
		private var _running:Boolean;
		
		private var _iterator:int;
		private var _total:int;
		
		private var _percentage:Number;
		
		/**
		 * 
		 * @param	maxStreams
		 */
		public function LoaderManager(maxStreams:uint = 1) {
			_maxStreams = maxStreams > 1 ? maxStreams : 1;
			
			_loaders = [];
			_streams = [];
			_running = false;
			
			_iterator = -1;
			_total = 0;
		}
		
		/**
		 * Добавить загрузчик в очередь
		 * @param	item
		 * @return
		 */
		public function addLoader(item:ILoader):int {
			item.addEventListener(LoaderEvent.PROGRESS, loaderProgressHandler);
			item.addEventListener(LoaderEvent.FAIL, loaderHandler);
			item.addEventListener(LoaderEvent.SUCCESS, loaderHandler);
			
			_loaders.push(item);
			_total = _loaders.length;
			
			return _total - 1;
		}
		
		/**
		 * Добавить массив загрузчиков в очередь
		 * @param	arr
		 */
		public function addLoaders(arr:Array):void {
			var _len:int = arr.length;
			for (var i:int = 0; i < _len; i++) {
				if (arr[i] is ILoader)
					addLoader(arr[i] as ILoader);
			}
		}
		
		/**
		 * Получить загрузчик
		 * @param	index
		 * @return
		 */
		public function getLoader(index:int):ILoader {
			if (index < 0 || index > _total - 1)
				return null;
			
			return _loaders[index] as ILoader;
		}
		
		/**
		 * Запустить загрузку
		 */
		public function load():void {
			loadNext();
		}
		
		/**
		 * Остановить все текущие загрузки и очистить очередь загрузок
		 */
		public function reset():void {
			close();
			
			while (_loaders.length) {
				var _item:ILoader = _loaders.pop() as ILoader;
				_item.removeEventListener(LoaderEvent.PROGRESS, loaderProgressHandler);
				_item.removeEventListener(LoaderEvent.FAIL, loaderHandler);
				_item.removeEventListener(LoaderEvent.SUCCESS, loaderHandler);
				_item.destroy();
			}
			
			_iterator = -1;
			_total = 0;
		}
		
		/**
		 * Остановить все текущие загрузки
		 */
		public function close():void {
			if (isRunning()) {
				while (_streams.length) {
					var _item:ILoader = _streams.pop() as ILoader;
					_item.close();
					
					_iterator--;
				}
				
				_running = false;
			}
		}
		
		/**
		 * Запущен ли загрузчик
		 * @return
		 */
		public function isRunning():Boolean { return _running; }
		
		/**
		 * Общий прогресс загрузок
		 */
		public function get percentage():Number { return _percentage; }
		
		/**
		 * Количество загрузок
		 */
		public function get total():int { return _total; }
		
		/**
		 * Максимальное число загрузок
		 */
		public function get maxStreams():int { return _maxStreams; }
		
		
		private function loadNext():void {
			if (_iterator + 1 < _total && _streams.length < _maxStreams) {
				_iterator++;
				
				var _item:ILoader = getLoader(_iterator);
				_item.load();
				
				_streams.push(_item);
				_running = true;
				
				var _event:LoaderEvent = new LoaderEvent(LoaderEvent.START);
				_event.current = _loaders.indexOf(_item);
				dispatchEvent(_event);
				
				loadNext();
			} else {
				if (_streams.length == 0)
					dispatchEvent(new LoaderEvent(LoaderEvent.FINISH));
			}
		}
		
		private function loaderProgressHandler(e:LoaderEvent):void {
			var _item:ILoader = e.target as ILoader;
			
			_percentage = 0;
			
			var _len:int = _loaders.length;
			for (var i:int = 0; i < _len; i++) {
				var _pctCurrent:Number = (_loaders[i] as ILoader).percentage;
				_percentage += (isNaN(_pctCurrent) ? 0 : _pctCurrent)
			}
			_percentage /= _total;
			
			var _event:LoaderEvent = e.clone() as LoaderEvent;
			_event.percentageTotal = _percentage;
			_event.current = _loaders.indexOf(_item);
			dispatchEvent(_event);
		}
		
		private function loaderHandler(e:LoaderEvent):void {
			var _item:ILoader = e.target as ILoader;
			_streams.splice(_streams.indexOf(_item), 1);
			
			if (_streams.length == 0)
				_running = false;
			
			var _event:LoaderEvent = e.clone() as LoaderEvent;
			_event.current = _loaders.indexOf(_item);
			dispatchEvent(_event);
			
			loadNext();
		}
		
	}

}
