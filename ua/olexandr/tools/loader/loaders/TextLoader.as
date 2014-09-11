package ua.olexandr.tools.loader.loaders {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
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
	public class TextLoader extends EventDispatcher implements ILoader {
		
		/**
		 * 
		 * @return
		 */
		public function getText():String {
			return _content;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getXML():XML {
			if (!_content)
				return null;
			
			var _data:XML;
			
			try {
				_data = XML(_content);
			} catch (e:Error) { }
			
			return _data;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getJSON():Object {
			var _class:Class = getDefinitionByName("JSON") as Class;
			if (_class && _class["parse"] is Function) {
				if (!_content)
					return null;
				
				var _data:Object;
				
				try {
					_data = _class["parse"](_content);
				} catch (e:Error) { }
				
				return _data;
			}
			
			return null;
		}
		
		private var _request:URLRequest;
		private var _loader:URLLoader;
		
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		private var _percentage:Number;
		private var _running:Boolean;
		
		private var _content:String;
		private var _error:String;
		
		/**
		 * 
		 * @param	url
		 */
		public function TextLoader(url:*) {
			if (url is URLRequest)	_request = url;
			else					_request = new URLRequest(url is String ? url : String(url));
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		/**
		 * 
		 */
		public function load():void {
			_running = true;
			
			_loader.load(_request);
			
			dispatchEvent(new LoaderEvent(LoaderEvent.START));
		}
		
		/**
		 * 
		 */
		public function close():void {
			try {
				_loader.close();
			} catch (err:Error) { }
		}
		
		/**
		 * 
		 */
		public function destroy():void {
			close();
			
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader = null;
			
			_content = null;
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
			_content = _loader.data;
			_running = false;
			
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.SUCCESS);
			_event.content = _content;
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