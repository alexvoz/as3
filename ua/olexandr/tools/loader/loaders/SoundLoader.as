package ua.olexandr.tools.loader.loaders {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
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
	[Event(name="init", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="success", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="finish", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="fail", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="progress", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	public class SoundLoader extends EventDispatcher implements ILoader {
		
		/**
		 * 
		 * @return
		 */
		public function getSound():Sound {
			return _sound;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getID3():ID3Info {
			return _sound.id3;
		}
		
		/**
		 * 
		 * @param	start
		 * @return
		 */
		public function getBytes(start:Number = -1):ByteArray {
			if (_sound["extract"] is Function) {
				var _bytes:ByteArray = new ByteArray();
				_sound["extract"](_bytes, _sound.bytesLoaded, start);
				
				return _bytes;
			}
			
			return null;
		}
		
		private var _request:URLRequest;
		private var _context:SoundLoaderContext;
		private var _sound:Sound;
		
		private var _percentage:Number;
		private var _running:Boolean;
		
		private var _error:String;
		
		/**
		 * 
		 * @param	url
		 * @param	context
		 */
		public function SoundLoader(url:*, context:SoundLoaderContext = null) {
			if (url is URLRequest)	_request = url;
			else					_request = new URLRequest(url is String ? url : String(url));
			
			_context = context;
			
			_sound = new Sound();
			_sound.addEventListener(Event.COMPLETE, completeHandler);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_sound.addEventListener(Event.ID3, id3Handler);
		}
		
		/**
		 * 
		 */
		public function load():void {
			_running = true;
			
			_sound.load(_request, _context);
			
			dispatchEvent(new LoaderEvent(LoaderEvent.START));
		}
		
		/**
		 * 
		 */
		public function close():void {
			try {
				_sound.close();
			} catch (err:Error) { }
		}
		
		/**
		 * 
		 */
		public function destroy():void {
			close();
			
			_sound.removeEventListener(Event.COMPLETE, completeHandler);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_sound.removeEventListener(Event.ID3, id3Handler);
			_sound = null;
			
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
		public function get bytesLoaded():uint { return _sound.bytesLoaded; }
		/**
		 * 
		 */
		public function get bytesTotal():uint { return _sound.bytesTotal; }
		/**
		 * 
		 */
		public function get percentage():Number { return _percentage; }
		
		/**
		 * 
		 */
		public function get content():* { return _sound; }
		/**
		 * 
		 */
		public function get error():String { return _error; }
		
		
		private function progressHandler(e:ProgressEvent):void {
			_percentage = e.bytesLoaded / e.bytesTotal;
			
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.PROGRESS);
			_event.bytesTotal = e.bytesTotal;
			_event.bytesLoaded = e.bytesLoaded;
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
			_running = false;
			
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.SUCCESS);
			_event.content = _sound;
			dispatchEvent(_event);
			
			dispatchFinish();
		}
		
		private function dispatchFinish():void {
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.FINISH);
			_event.error = _error;
			_event.content = _sound;
			dispatchEvent(_event);
		}
		
		private function id3Handler(e:Event):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.INIT));
		}
		
	}

}