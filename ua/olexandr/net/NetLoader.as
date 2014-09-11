package ua.olexandr.net {
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import ua.olexandr.debug.Logger;
	import ua.olexandr.events.LoaderEvent;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	[Event(name = "start", type = "ua.olexandr.events.LoaderEvent")]
	[Event(name = "progress", type = "ua.olexandr.events.LoaderEvent")]
	[Event(name = "fail", type = "ua.olexandr.events.LoaderEvent")]
	[Event(name = "success", type = "ua.olexandr.events.LoaderEvent")]
	[Event(name = "finish", type = "ua.olexandr.events.LoaderEvent")]
	public class NetLoader extends EventDispatcher {
		
		private var _maxStreams:int;
		private var _datas:Array;
		private var _streams:Array;
		private var _running:Boolean;
		
		private var _iterator:int;
		private var _total:int;
		
		private var _percentage:Number;
		
		/**
		 * 
		 * @param	maxStreams
		 */
		public function NetLoader(maxStreams:int = 1) {
			_maxStreams = maxStreams > 1 ? maxStreams : 1;
			
			_datas = [];
			_streams = [];
			_running = false;
			
			_iterator = -1;
			_total = 0;
		}
		
		/**
		 * Добавить адрес текстовых данных в очередь
		 * @param	url
		 * @return
		 */
		public function addText(url:*):int {
			return add(url, LoaderData.TEXT);
		}
		
		/**
		 * Добавить адрес медиа данных в очередь
		 * @param	url
		 * @param	context
		 * @param	inSecure
		 * @return
		 */
		public function addMedia(url:*, context:LoaderContext = null, inSecure:Boolean = false):int {
			return add(url, LoaderData.MEDIA, context, inSecure);
		}
		
		/**
		 * Добавить адрес байтовых данных в очередь
		 * @param	url
		 * @return
		 */
		public function addBytes(url:*):int {
			return add(url, LoaderData.BYTES);
		}
		
		
		/**
		 * Получить данные загрузки
		 * @param	index
		 * @return
		 */
		public function getData(index:int):LoaderData {
			if (index < 0 || index > _total - 1)
				return null;
				
			return _datas[index] as LoaderData;
		}
		
		/**
		 * Получить запрос
		 * @param	index
		 * @return
		 */
		public function getRequest(index:int):URLRequest {
			var _data:LoaderData = getData(index);
			return _data ? _data.request : null;
		}
		
		/**
		 * Получить загруженный контент
		 * @param	index
		 * @return
		 */
		public function getContent(index:int):* {
			var _data:LoaderData = getData(index);
			return _data ? _data.content : null;
		}
		
		/**
		 * Получить текст ошибки
		 * @param	index
		 * @return
		 */
		public function getError(index:int):String {
			var _data:LoaderData = getData(index);
			return _data ? _data.error : null;
		}
		
		
		/**
		 * Запустить загрузку
		 */
		public function load():void {
			if (!isRunning()) {
				if (_total)		loadNext();
				else			dispatchEvent(new LoaderEvent(LoaderEvent.FINISH));
			}
		}
		
		/**
		 * Остановить все текущие загрузки и очистить очередь загрузок
		 */
		public function reset():void {
			close();
			
			while (_datas.length) {
				var _item:LoaderData = _datas.pop() as LoaderData;
				_item.close();
			}
			
			_iterator = -1;
			_total = 0;
			
			/*if (_datas) {
				while (_datas.length)
					(_datas.pop() as LoaderData).destroy();
			} else {
				_datas = [];
			}
			
			_running = false;
			_iterator = -1;
			_total = 0;*/
		}
		
		/**
		 * Остановить все текущие загрузки
		 */
		public function close():void {
			if (isRunning()) {
				while (_streams.length) {
					var _item:LoaderData = _streams.pop() as LoaderData;
					_item.close();
					
					_iterator--;
				}
				
				_running = false;
			}
			
			/*if (_iterator > -1)
				(_datas[_iterator] as LoaderData).destroy();
			
			_running = false;*/
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
		
		
		private function add(url:*, type:String = 'text', context:LoaderContext = null, inSecure:Boolean = false):int {
			if (url is Array) {
				var _arr:Array = url as Array;
				var _len:int = _arr.length;
				for (var i:int = 0; i < _len; i++)
					add(_arr[i], type, context, inSecure);
				
				return _len > 0 ? _len : -1;
			}
			
			var _url:URLRequest;
			if (url is URLRequest) 	_url = url;
			else 					_url = new URLRequest(url is String ? url : String(url));
			
			var _data:LoaderData = new LoaderData(_url, type);
			_data.context = context;
			_data.inSecure = inSecure;
			
			_datas.push(_data);
			_total = _datas.length;
			
			return _total - 1;
		}
		
		private function loadNext():void {
			if (_iterator + 1 < _total && _streams.length < _maxStreams) {
				_iterator++;
				
				var _data:LoaderData = getData(_iterator);
				switch (_data.type){
					case LoaderData.TEXT:  {
						_data.textLoader.addEventListener(Event.COMPLETE,textHandler);
						_data.textLoader.addEventListener(IOErrorEvent.IO_ERROR, textHandler);
						_data.textLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, textHandler);
						_data.textLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						_data.textLoader.load(_data.request);
						break;
					}
					case LoaderData.MEDIA: {
						if (_data.inSecure) {
							Security.allowDomain("*");
							Security.allowInsecureDomain("*");
							
							_data.mediaLoader.addEventListener(Event.ADDED, mediaAddedHandler, true, int.MAX_VALUE);
							_data.mediaLoader.addEventListener(Event.ADDED, mediaAddedHandler, false, int.MAX_VALUE);
						}
						
						_data.mediaLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mediaHandler);
						_data.mediaLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, mediaHandler);
						_data.mediaLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, mediaHandler);
						_data.mediaLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						_data.mediaLoader.load(_data.request, _data.context);
						break;
					}
					case LoaderData.BYTES:  {
						_data.bytesLoader.addEventListener(Event.COMPLETE, bytesHandler);
						_data.bytesLoader.addEventListener(IOErrorEvent.IO_ERROR, bytesHandler);
						_data.bytesLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, bytesHandler);
						_data.bytesLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						_data.bytesLoader.load(_data.request);
						break;
					}
				}
				
				_streams.push(_data);
				_running = true;
				
				var _event:LoaderEvent = new LoaderEvent(LoaderEvent.START);
				_event.current = _datas.indexOf(_data);
				dispatchEvent(_event);
				
				loadNext();
			} else {
				if (_streams.length == 0)
					dispatchEvent(new LoaderEvent(LoaderEvent.FINISH));
			}
		}
		
		
		private function textHandler(e:Event):void {
			var _data:LoaderData = LoaderData.cache[e.target];
			var _event:LoaderEvent;
			
			switch (e.type) {
				case Event.COMPLETE: {
					_data.setContent(_data.textLoader.data);
					_event = new LoaderEvent(LoaderEvent.SUCCESS);
					break;
				}
				case IOErrorEvent.IO_ERROR: 
				case SecurityErrorEvent.SECURITY_ERROR: {
					_data.setError((e as ErrorEvent).text);
					_event = new LoaderEvent(LoaderEvent.FAIL);
					break;
				}
			}
			
			_data.textLoader.removeEventListener(Event.COMPLETE, textHandler);
			_data.textLoader.removeEventListener(IOErrorEvent.IO_ERROR, textHandler);
			_data.textLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, textHandler);
			_data.textLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			_streams.splice(_streams.indexOf(_data), 1);
			
			if (_streams.length == 0)
				_running = false;
			
			_event.current = _datas.indexOf(_data);
			_event.content = _data.content;
			_event.error = _data.error;
			dispatchEvent(_event);
			
			loadNext();
		}
		
		private function mediaAddedHandler(e:Event):void {
			var _data:LoaderData = _datas[_iterator];
			
			if (e.target)
				_data.inSecureContent = e.target as DisplayObject;
		}
		
		private function mediaHandler(e:Event):void {
			var _info:LoaderInfo = e.target as LoaderInfo;
			var _data:LoaderData = LoaderData.cache[_info.loader];
			var _event:LoaderEvent;
			
			switch (e.type) {
				case Event.COMPLETE: {
					if (_data.inSecure && _data.inSecureContent) {
						_data.setContent(_data.inSecureContent);
						_event = new LoaderEvent(LoaderEvent.SUCCESS);
					} else {
						try {
							_data.setContent(_data.mediaLoader.contentLoaderInfo.content);
							_event = new LoaderEvent(LoaderEvent.SUCCESS);
						} catch (err:Error) {
							_data.setError(err.message);
							_event = new LoaderEvent(LoaderEvent.FAIL);
						}
					}
					break;
				}
				case IOErrorEvent.IO_ERROR: 
				case SecurityErrorEvent.SECURITY_ERROR: {
					_data.setError((e as ErrorEvent).text);
					_event = new LoaderEvent(LoaderEvent.FAIL);
					break;
				}
			}
			
			if (_data.inSecure) {
				_data.mediaLoader.removeEventListener(Event.ADDED, mediaAddedHandler, true);
				_data.mediaLoader.removeEventListener(Event.ADDED, mediaAddedHandler, false);
			}
			
			_data.mediaLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, mediaHandler);
			_data.mediaLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, mediaHandler);
			_data.mediaLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, mediaHandler);
			_data.mediaLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			_streams.splice(_streams.indexOf(_data), 1);
			
			if (_streams.length == 0)
				_running = false;
			
			_event.current = _datas.indexOf(_data);
			_event.content = _data.content;
			_event.error = _data.error;
			dispatchEvent(_event);
			
			loadNext();
		}
		
		private function bytesHandler(e:Event):void {
			var _data:LoaderData = LoaderData.cache[e.target];
			var _event:LoaderEvent;
			
			switch (e.type) {
				case Event.COMPLETE: {
					var _bytes:ByteArray = new ByteArray();
					_data.bytesLoader.readBytes(_bytes);
					_data.setContent(_bytes);
					
					_event = new LoaderEvent(LoaderEvent.SUCCESS);
					
					break;
				}
				case IOErrorEvent.IO_ERROR: 
				case SecurityErrorEvent.SECURITY_ERROR: {
					_data.setError((e as ErrorEvent).text);
					_event = new LoaderEvent(LoaderEvent.FAIL);
					break;
				}
			}
			
			_data.bytesLoader.removeEventListener(Event.COMPLETE, bytesHandler);
			_data.bytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, bytesHandler);
			_data.bytesLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, bytesHandler);
			_data.bytesLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			_streams.splice(_streams.indexOf(_data), 1);
			
			if (_streams.length == 0)
				_running = false;
			
			_event.current = _datas.indexOf(_data);
			_event.content = _data.content;
			_event.error = _data.error;
			dispatchEvent(_event);
			
			loadNext();
		}
		
		private function progressHandler(e:ProgressEvent):void {
			var _data:LoaderData;
			if (e.target is LoaderInfo) 	_data = LoaderData.cache[(e.target as LoaderInfo).loader];
			else 							_data = LoaderData.cache[e.target];
			_data.percentage = e.bytesLoaded / e.bytesTotal;
			
			_percentage = 0;
			
			var _len:int = _datas.length;
			for (var i:int = 0; i < _len; i++)
				_percentage += (_datas[i] as LoaderData).percentage;
			_percentage /= _total;
			
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.PROGRESS);
			_event.current = _datas.indexOf(_data);
			_event.bytesTotal = e.bytesTotal;
			_event.bytesLoaded = e.bytesLoaded;
			_event.percentageCurrent = _data.percentage;
			_event.percentageTotal = _percentage;
			dispatchEvent(_event);
		}
		
	}

}

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.system.LoaderContext;
import flash.utils.Dictionary;

internal class LoaderData {
	
	internal static const TEXT:String = 'text';
	internal static const MEDIA:String = 'media';
	internal static const BYTES:String = 'bytes';
	
	internal static var cache:Dictionary = new Dictionary(true);
	
	
	internal var type:String;
	internal var context:LoaderContext;
	internal var inSecure:Boolean;
	internal var inSecureContent:DisplayObject;
	
	internal var percentage:Number;
	
	private var _request:URLRequest;
	private var _content:*;
	private var _error:String;
	
	private var _textLoader:URLLoader;
	private var _mediaLoader:Loader;
	private var _bytesLoader:URLStream;
	
	public function LoaderData(request:URLRequest, type:String) {
		this.type = type;
		_request = request;
		
		switch (this.type) {
			case TEXT: {
				_textLoader = new URLLoader();
				cache[_textLoader] = this;
				break;
			}
			case MEDIA: {
				_mediaLoader = new Loader();
				cache[_mediaLoader] = this;
				break;
			}
			case BYTES: {
				_bytesLoader = new URLStream();
				cache[_bytesLoader] = this;
				break;
			}
		}
		
		percentage = 0;
	}
	
	/**
	 * Запрос
	 */
	public function get request():URLRequest { return _request; }
	
	/**
	 * Загруженный контент
	 */
	public function get content():*{ return _content; }
	
	/**
	 * Текст ошибки загрузки
	 */
	public function get error():String { return _error; }
	
	internal function setContent(value:*):void {
		_content = value;
		_error = null;
	}
	
	internal function setError(text:String):void {
		_error = text;
		_content = null;
	}
	
	internal function close():void {
		switch (this.type) {
			case TEXT: {
				if (_textLoader) {
					try {
						_textLoader.close();
					} catch (err:Error) {
					}
					
					delete cache[_textLoader];
					_textLoader = null;
				}
				break;
			}
			case MEDIA: {
				if (_mediaLoader) {
					_mediaLoader.unload();
					
					try {
						_mediaLoader.close();
					} catch (err:Error) {
					}
					
					delete cache[_mediaLoader];
					_mediaLoader = null;
				}
				break;
			}
			case BYTES: {
				if (_bytesLoader) {
					try {
						_bytesLoader.close();
					} catch (err:Error) {
					}
					
					delete cache[_bytesLoader];
					_bytesLoader = null;
				}
				break;
			}
		}
		
		_content = null;
		_error = null;
	}
	
	internal function get textLoader():URLLoader { return _textLoader; }
	internal function get mediaLoader():Loader { return _mediaLoader; }
	internal function get bytesLoader():URLStream { return _bytesLoader; }
	
}
