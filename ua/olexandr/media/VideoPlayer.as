package ua.olexandr.media {
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import ua.olexandr.events.MediaEvent;
	import ua.olexandr.tools.tweener.Easing;
	import ua.olexandr.tools.tweener.Tweener;
	import ua.olexandr.vos.VideoMetadataVO;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	[Event(name="error", type="ua.olexandr.events.MediaEvent")]
	[Event(name="init", type="ua.olexandr.events.MediaEvent")]
	[Event(name="load_progress", type="ua.olexandr.events.MediaEvent")]
	[Event(name="load_complete", type="ua.olexandr.events.MediaEvent")]
	[Event(name="play_start", type="ua.olexandr.events.MediaEvent")]
	[Event(name="play_progress", type="ua.olexandr.events.MediaEvent")]
	[Event(name="play_complete", type="ua.olexandr.events.MediaEvent")]
	public class VideoPlayer extends EventDispatcher{
		
		public var autoplay:Boolean;
		public var repeat:Boolean;
		
		private var _metadata:VideoMetadataVO;
		
		private var _url:String;
		private var _loading:Boolean;
		private var _playing:Boolean;
		private var _pause:Boolean;
		
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _video:Video;
		private var _transform:SoundTransform;
		
		private var _percentageLoading:Number;
		private var _percentagePlaying:Number;
		
		private var _timer:Timer;
		
		/**
		 * 
		 * @param	volume
		 */
		public function VideoPlayer(volume:Number = .5) {
			autoplay = true;
			repeat = false;
			
			_transform = new SoundTransform(0);
			_transform.volume = volume;
			
			_video = new Video();
			_video.smoothing = true;
			
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			close();
		}
		
		/**
		 * 
		 * @param	url
		 */
		public function load(url:String = null):void {
			if (url && url != _url) {
				close();
				
				_loading = true;
				
				_url = url;
				
				_connection = initConnection();
				_connection.connect(null);
			}
		}
		
		/**
		 * 
		 */
		public function play():void {
			_playing = true;
			
			pause = false;
			
			dispatchEvent(new MediaEvent(MediaEvent.PLAY_START));
		}
		
		/**
		 * 
		 * @param	position
		 */
		public function seek(position:Number):void {
			if (_stream)
				_stream.seek(position);
		}
		
		/**
		 * 
		 */
		public function close():void {
			if (_connection)
				destroyConnection(_connection);
			
			if (_stream)
				destroyStream(_stream);
			
			if (_timer.running)
				_timer.stop();
			
			_loading = false;
			_playing = false;
			_pause = true;
			
			_url = '';
			
			_percentageLoading = 0;
			_percentagePlaying = 0;
			
			_metadata = null;
		}
		
		/**
		 * 
		 */
		public function clear():void {
			_video.clear();
		}
		
		/**
		 * 
		 */
		public function get pause():Boolean { return _pause; }
		/**
		 * 
		 */
		public function set pause(value:Boolean):void {
			_pause = value;
			if (_stream) {
				if (_pause) 	_stream.pause();
				else 			_stream.resume();
			}
		}
		
		/**
		 * 
		 */
		public function get volume():Number { return _transform.volume; }
		/**
		 * 
		 */
		public function set volume(value:Number):void {
			Tweener.addTween(_transform, .5, { volume:value, ease:Easing.none,
				onUpdate:function():void {
					if (_stream)
						_stream.soundTransform = _transform;
				}
			} );
		}
		
		/**
		 * 
		 */
		public function get length():Number {
			if (_metadata)
				return _metadata.duration;
			
			return NaN;
		}
		/**
		 * 
		 */
		public function get video():Video { return _video; }
		
		/**
		 * 
		 */
		public function get height():Number {
			if (_metadata)
				return _metadata.height;
			
			return NaN;
		}
		/**
		 * 
		 */
		public function get width():Number {
			if (_metadata)
				return _metadata.width;
			
			return NaN;
		}
		
		/**
		 * 
		 */
		public function get percentLoading():Number { return _percentageLoading; }
		/**
		 * 
		 */
		public function get percentPlaying():Number { return _percentagePlaying; }
		
		/**
		 * 
		 */
		public function get url():String { return _url; }
		
		
		private function errorHandler(e:Event):void {
			dispatchEvent(new MediaEvent(MediaEvent.ERROR, e['text']));
		}
		
		private function statusHandler(e:NetStatusEvent):void {
			var _error:String;
			
			switch(e.info.code) {
            	case 'NetConnection.Connect.Failed': {
					_error = e.info.code;
					break;
				}
            	case 'NetConnection.Connect.Rejected': {
					_error = e.info.code;
					break;
				}
            	case 'NetConnection.Connect.Closed': {
					_error = e.info.code;
					break;
				}
				case 'NetConnection.Connect.Success': {
					_stream = initStream();
					_stream.play(_url);
					
					_stream.pause();
					if (autoplay)
						play();
					
					_video.attachNetStream(_stream);
					
					_timer.start();
					break;
				}
				
				case 'NetStream.Buffer.Full': {
					break;
				}
				case 'NetStream.Buffer.Flush': {
					break;
				}
				case 'NetStream.Buffer.Empty': {
					break;
				}
				case 'NetStream.Seek.Notify': {
					break;
				}
				case 'NetStream.Play.StreamNotFound': {
					_error = e.info.code;
					break;
				}
				case 'NetStream.Play.Start': {
					break;
				}
				case 'NetStream.Play.Stop': {
					_stream.pause();
					
					_playing = false;
					dispatchEvent(new MediaEvent(MediaEvent.PLAY_COMPLETE));
					
					if (repeat) {
						seek(0);
						play();
					}
					break;
				}
				default: {
					trace(e.info.code);
					break;
				}
			}
			
			if (_error) {
				close();
				dispatchEvent(new MediaEvent(MediaEvent.ERROR, _error));
			}
		}
		
		private function clientHandler(o:Object):void {
			_metadata = new VideoMetadataVO(o);
			dispatchEvent(new MediaEvent(MediaEvent.INIT));
		}
		
		private function timerHandler(e:TimerEvent):void {
			var _event:MediaEvent;
			
			if (_loading) {
				_percentageLoading = Math.round(_stream.bytesLoaded / _stream.bytesTotal * 10000) / 10000;
				
				_event = new MediaEvent(MediaEvent.LOAD_PROGRESS);
				_event.bytesLoaded = _stream.bytesLoaded;
				_event.bytesTotal = _stream.bytesTotal;
				_event.percentageLoading = _percentageLoading;
				dispatchEvent(_event);
				
				if (_percentageLoading == 1) {
					_loading = false;
					dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
				}
			}
			
			if (_playing && !_pause && _metadata) {
				_percentagePlaying = Math.round(_stream.time / _metadata.duration * 10000) / 10000;
				
				_event = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				_event.position = _stream.time;
				_event.length = _metadata.duration;
				_event.percentagePlaying = _percentagePlaying;
				dispatchEvent(_event);
			}
		}
		
		
		private function initConnection():NetConnection {
			var _connection:NetConnection = new NetConnection();
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			return _connection;
		}
		
		private function destroyConnection(connection:NetConnection):void {
			connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			connection.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			connection.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			connection.close();
			connection = null;
		}
		
		private function initStream():NetStream {
			var _stream:NetStream = new NetStream(_connection);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			_stream.client = { onMetaData:clientHandler };
			_stream.soundTransform = _transform;
			return _stream;
		}
		
		private function destroyStream(stream:NetStream):void {
			stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			stream.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			stream.pause();
			stream.close();
			stream = null;
		}
	}

}