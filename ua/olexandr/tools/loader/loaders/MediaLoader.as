package ua.olexandr.tools.loader.loaders {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import ua.olexandr.tools.loader.events.LoaderEvent;
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	[Event(name="start", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="success", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="finish", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="fail", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="progress", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	public class MediaLoader extends EventDispatcher implements ILoader {
		
		/**
		 * 
		 * @return
		 */
		public function getDisplayObject():DisplayObject {
			if (!_content)
				return null;
			
			return _content;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getSprite():Sprite {
			if (!_content)
				return null;
			
			return Sprite(_content);
		}
		
		/**
		 * 
		 * @return
		 */
		public function getMovieClip():MovieClip {
			if (!_content)
				return null;
			
			return MovieClip(_content);
		}
		
		/**
		 * 
		 * @return
		 */
		public function getBitmapData():BitmapData {
			if (!_content)
				return null;
			
			_bitmapData ||= Bitmap(_content).bitmapData.clone(); 
			return _bitmapData;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getBitmap():Bitmap {
			return new Bitmap(getBitmapData());
		}
		
		private var _request:URLRequest;
		private var _context:LoaderContext;
		private var _inSecure:Boolean;
		
		private var _loader:Loader;
		
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		private var _percentage:Number;
		private var _running:Boolean;
		
		private var _loaderContent:DisplayObject;
		private var _content:DisplayObject;
		private var _bitmapData:BitmapData;
		private var _error:String;
		
		/**
		 * 
		 * @param	url
		 * @param	context
		 * @param	inSecure
		 */
		public function MediaLoader(url:*, context:LoaderContext = null, inSecure:Boolean = false) {
			_inSecure = inSecure;
			
			if (url is URLRequest)	_request = url;
			else 					_request = new URLRequest(url is String ? url : String(url));
			
			_context = context;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			if (_inSecure) {
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");
				
				_loader.addEventListener(Event.ADDED, addedHandler, true, int.MAX_VALUE);
				_loader.addEventListener(Event.ADDED, addedHandler, false, int.MAX_VALUE);
			}
		}
		
		/**
		 * 
		 */
		public function load():void {
			_running = true;
			
			_loader.load(_request, _context);
			
			dispatchEvent(new LoaderEvent(LoaderEvent.START));
		}
		
		/**
		 * 
		 */
		public function close():void {
			if (_loader.content is Bitmap) {
				(_loader.content as Bitmap).cacheAsBitmap = false;
				(_loader.content as Bitmap).bitmapData.dispose();
				(_loader.content as Bitmap).bitmapData = null;
				(_loader.contentLoaderInfo.content as Bitmap).bitmapData = null;
			}
			
			_loader.unload();
			
			try {
				_loader.close();
			} catch (err:Error) { }
		}
		
		/**
		 * 
		 */
		public function destroy():void {
			close();
			
			if (_inSecure) {
				_loader.removeEventListener(Event.ADDED, addedHandler, true);
				_loader.removeEventListener(Event.ADDED, addedHandler, false);
			}
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader = null;
			
			_content = null;
			if (_bitmapData) {
				_bitmapData.dispose();
				_bitmapData = null;
			}
			
			_error = null;
		}
		
		/**
		 * 
		 * @return
		 */
		public function isRunning():Boolean { return _running; }
		
		/**
		 * 
		 */
		public function get request():URLRequest { return _request; }
		
		/**
		 * 
		 */
		public function get bytesLoaded():uint { return _bytesLoaded; }
		/**
		 * 
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		/**
		 * 
		 */
		public function get percentage():Number { return _percentage; }
		
		/**
		 * 
		 */
		public function get content():* { return _content; }
		/**
		 * 
		 */
		public function get error():String { return _error; }
		
		
		private function addedHandler(e:Event):void {
			if (e.target)
				_loaderContent = e.target as DisplayObject;
		}
		
		private function progressHandler(e:ProgressEvent):void {
			_bytesTotal = e.bytesTotal;
			_bytesLoaded = e.bytesLoaded;
			_percentage = _bytesLoaded / _bytesTotal;
			
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.PROGRESS);
			_event.bytesTotal = _bytesTotal;
			_event.bytesLoaded = _bytesLoaded;
			_event.percentageTotal = _percentage;
			_event.percentageCurrent = _percentage;
			dispatchEvent(_event);
		}
		
		private function errorHandler(e:ErrorEvent):void {
			_error = e.text;
			_running = false;
			
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.FAIL);
			_event.error = _error;
			dispatchEvent(_event);
			
			dispatchFinish();
		}
		
		private function completeHandler(e:Event):void {
			if (_inSecure && _loaderContent) {
				_content = _loaderContent;
			} else {
				try {
					_content = _loader.contentLoaderInfo.content;
				} catch (err:Error) {
					_error = err.message;
				}
			}
			_running = false;
			
			var _event:LoaderEvent;
			if (_content) {
				_event = new LoaderEvent(LoaderEvent.SUCCESS);
				_event.content = _content;
			} else {
				_event = new LoaderEvent(LoaderEvent.FAIL);
				_event.error = _error;
			}
			dispatchEvent(_event);
			
			dispatchFinish();
		}
		
		private function dispatchFinish():void {
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.FINISH);
			_event.error = _error;
			_event.content = _content;
			dispatchEvent(_event);
		}
		
	}

}