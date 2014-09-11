package ua.olexandr.tools.loader.loaders {
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import ua.olexandr.tools.loader.events.LoaderEvent;
	import ua.olexandr.vos.VideoMetadataVO;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	[Event(name="start", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="init", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="success", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="finish", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="fail", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="progress", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	public class VideoLoader extends EventDispatcher implements ILoader {
		
		private var _metadata:VideoMetadataVO;
		
		private var _request:URLRequest;
		private var _connection:NetConnection;
		private var _stream:NetStream;
		
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		private var _percentage:Number;
		private var _running:Boolean;
		
		private var _error:String;
		
		private var _timer:Timer;
		
		/**
		 * 
		 * @param	url
		 */
		public function VideoLoader(url:*) {
			if (url is URLRequest)	_request = url;
			else					_request = new URLRequest(url is String ? url : String(url));
			
			_connection = new NetConnection();
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		/**
		 * 
		 */
		public function load():void {
			_running = true;
			
			_connection.connect(null);
			
			dispatchEvent(new LoaderEvent(LoaderEvent.START));
		}
		
		/**
		 * 
		 */
		public function close():void {
			if (_connection)
				_connection.close();
			
			if (_stream) {
				_stream.pause();
				_stream.close();
			}
			
			_timer.reset();
			_running = false;
		}
		
		/**
		 * 
		 */
		public function destroy():void {
			close();
			
			if (_connection) {
				_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
				_connection.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				_connection = null;
			}
			
			if (_stream) {
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				_stream = null;
			}
			
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer = null;
			
			_request = null;
			_percentage = 0;
			_metadata = null;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getStream():NetStream {
			return _stream;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getVideo():Video {
			var _video:Video = new Video();
			_video.attachNetStream(_stream);
			return _video;
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
		public function get content():* { return _stream; }
		/**
		 * 
		 */
		public function get error():String { return _error; }
		
		
		private function errorHandler(e:Event):void {
			var _event:LoaderEvent = new LoaderEvent(LoaderEvent.FAIL);
			_event.error = e['text'];
			dispatchEvent(_event);
		}
		
		private function statusHandler(e:NetStatusEvent):void {
			switch(e.info.code) {
            	case 'NetConnection.Connect.Failed':
            	case 'NetConnection.Connect.Rejected':
            	case 'NetConnection.Connect.Closed':
				case 'NetStream.Play.StreamNotFound': {
					close();
					
					var _event:LoaderEvent = new LoaderEvent(LoaderEvent.FAIL);
					_event.error = e.info.code;
					dispatchEvent(_event);
					break;
				}
				case 'NetConnection.Connect.Success': {
					_stream = new NetStream(_connection);
					_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
					_stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					_stream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
					_stream.client = { onMetaData:function (o:Object):void {
						_metadata = new VideoMetadataVO(o);
						dispatchEvent(new LoaderEvent(LoaderEvent.INIT));
					} };
					
					_stream.play(_request.url);
					_stream.pause();
					
					_timer.start();
					break;
				}
			}
		}
		
		private function timerHandler(e:TimerEvent):void {
			if (_running) {
				_bytesLoaded = _stream.bytesLoaded;
				_bytesTotal = _stream.bytesTotal;
				_percentage = _bytesLoaded / _bytesTotal;
				
				var _event:LoaderEvent = new LoaderEvent(LoaderEvent.PROGRESS);
				_event.bytesLoaded = _bytesLoaded;
				_event.bytesTotal = _bytesTotal;
				_event.percentageCurrent = _percentage;
				dispatchEvent(_event);
				
				if (_percentage == 1) {
					_running = false;
					dispatchEvent(new LoaderEvent(LoaderEvent.SUCCESS));
				}
			}
		}
		
	}

}