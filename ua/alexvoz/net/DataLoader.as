package ua.alexvoz.net  {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	
	[Event(name = "progress", type = "ua.alexvoz.net.DataLoaderEvents")]
	[Event(name = "current_progress", type = "ua.alexvoz.net.DataLoaderEvents")]
	[Event(name = "error", type = "ua.alexvoz.net.DataLoaderEvents")]
	[Event(name = "complete", type = "ua.alexvoz.net.DataLoaderEvents")]
	
	public class DataLoader extends Sprite {
		private var _arrResult:Array;
		private var _arrURLs:Array;
		private var _currLoad:int;
		
		public function DataLoader() {
			
		}
		
		private function errorHandler(e:Event):void {
			dispatchEvent(new DataLoaderEvents(DataLoaderEvents.ERROR, 0, (e['text']) as String));
		}
		
		public function loadData(url:String):void {
			var _req:URLRequest = new URLRequest(url);
			var _loader:URLLoader = new URLLoader()
			_loader.addEventListener(Event.COMPLETE, dataHandler)
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.load(_req);
		}
		
		private function dataHandler(e:Event):void {
			dispatchEvent(new DataLoaderEvents(DataLoaderEvents.COMPLETE, 0, e.target.data));
		}
		
		public function upLoadData(url:String, param:URLVariables, method:String = 'POST'):void {
			var _req:URLRequest = new URLRequest(url);
			_req.method = method;
			_req.data = param;
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, dataHandler)
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.load(_req);
		}
		
		public function batchLoadData(arr:Array):void {
			_currLoad = 0;
			_arrURLs = arr;
			_arrResult = [];
			loadDataNext();
		}
		
		private function loadDataNext():void {
			var _req:URLRequest = new URLRequest(_arrURLs[_currLoad]);
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, batchDataHandler);
			_loader.addEventListener(ProgressEvent.PROGRESS, batchProgressHandler)
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.load(_req);
		}
		
		private function batchDataHandler(e:Event):void {
			_arrResult.push(e.target.data);
			_currLoad++;
			if (_currLoad < _arrURLs.length) {
				dispatchEvent(new DataLoaderEvents(DataLoaderEvents.PROGRESS, Math.round((_currLoad / _arrURLs.length) * 100), null));
				loadDataNext();
			} else {
				dispatchEvent(new DataLoaderEvents(DataLoaderEvents.COMPLETE, 0, _arrResult));
			}
		}
		
		public function loadContent(url:String):void {
			var _req:URLRequest = new URLRequest(url);
			var _loader:Loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, contentProgressHandler)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.load(_req);
		}
		
		private function contentProgressHandler(e:ProgressEvent):void {
			dispatchEvent(new DataLoaderEvents(DataLoaderEvents.PROGRESS, Math.round((e.bytesLoaded / e.bytesTotal) * 100), null));
		}
		
		private function contentHandler(e:Event):void {
			dispatchEvent(new DataLoaderEvents(DataLoaderEvents.COMPLETE, 0, e.target.content));
		}
		
		public function batchLoadMedia(arr:Array):void {
			_currLoad = 0;
			_arrURLs = arr;
			_arrResult = [];
			loadMediaNext();
		}
		
		private function loadMediaNext():void {
			var _req:URLRequest = new URLRequest(_arrURLs[_currLoad]);
			var _loader:Loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, batchMediaHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, batchProgressHandler)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.load(_req);
		}
		
		private function batchProgressHandler(e:ProgressEvent):void {
			var _proc:int = Math.round((100 / _arrURLs.length) * _currLoad + ((e.bytesLoaded / e.bytesTotal) * 100) / _arrURLs.length);
			dispatchEvent(new DataLoaderEvents(DataLoaderEvents.CURRENT_PROGRESS, _proc, null));
		}
		
		private function batchMediaHandler(e:Event):void {
			if (e.target.content is Bitmap) e.target.content.smoothing = true;
			_arrResult.push(e.target.content);
			_currLoad++;
			if (_currLoad < _arrURLs.length) {
				dispatchEvent(new DataLoaderEvents(DataLoaderEvents.PROGRESS, Math.round((_currLoad / _arrURLs.length) * 100), null));
				loadMediaNext();
			} else {
				dispatchEvent(new DataLoaderEvents(DataLoaderEvents.COMPLETE, 0, _arrResult));
			}
		}
		
	}

}