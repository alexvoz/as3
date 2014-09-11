package media {
	import events.MediaEvent;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	[Event(name="error", type="events.MediaEvent")]
	[Event(name="load_progress", type="events.MediaEvent")]
	[Event(name="load_complete", type="events.MediaEvent")]
	[Event(name="init", type="events.MediaEvent")]
	[Event(name="play_start", type="events.MediaEvent")]
	[Event(name="play_progress", type="events.MediaEvent")]
	[Event(name="play_complete", type="events.MediaEvent")]
	[Event(name="buffer_empty", type="events.MediaEvent")]
	[Event(name="buffer_full", type="events.MediaEvent")]
	public class VideoPlayer extends EventDispatcher{
		
		public var autoplay:Boolean;
		public var repeat:Boolean;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _url:String;
		private var _loading:Boolean;
		private var _playing:Boolean;
		private var _pause:Boolean;
		private var _bufferTime:Number;
		
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _video:Video;
		private var _transform:SoundTransform;
		
		private var _percentLoading:Number;
		private var _percentPlaying:Number;
		private var _length:Number;
		
		private var _efDispatcher:Sprite;
		
		public function VideoPlayer(volume:Number = .5) {
			autoplay = true;
			repeat = false;
			
			_transform = new SoundTransform(0);
			_transform.volume = volume;
			
			_video = new Video();
			_video.smoothing = true;
			
			_efDispatcher = new Sprite();
			_bufferTime = .1;
			
			close();
		}
		
		public function load(url:String = null):void {
			if (url && url != _url) {
				close();
				
				_url = url;
				_loading = true;
				
				initConnection();
			}
		}
		
		public function play():void {
			_playing = true;
			
			pause = false;
			
			dispatchEvent(new MediaEvent(MediaEvent.PLAY_START));
		}
		
		public function seek(position:Number):void {
			if (_stream)
				_stream.seek(position);
		}
		
		public function close():void {
			if (_connection)
				destroyConnection();
			
			if (_stream)
				destroyStream();
			
			_efDispatcher.removeEventListener(Event.ENTER_FRAME, efHandler);
			
			_loading = false;
			_playing = false;
			_pause = true;
			
			_url = '';
			
			_percentLoading = 0;
			_percentPlaying = 0;
			
			_length = NaN;
			_width = NaN;
			_height = NaN;
		}
		
		public function clear():void {
			_video.clear();
		}
		
		public function get pause():Boolean { return _pause; }
		public function set pause(value:Boolean):void {
			_pause = value;
			if (_stream) {
				if (_pause) {
					_stream.pause();
				} else {
					if (_playing) 	_stream.resume();
					else 			play();
				}
			}
		}
		
		public function get volume():Number { return _transform.volume; }
		public function set volume(value:Number):void {
			_transform.volume = value;
			if (_stream)
				_stream.soundTransform = _transform;
		}
		
		public function get bufferTime():Number { return _bufferTime; }
		public function set bufferTime(value:Number):void {
			_bufferTime = value;
			if (_stream)
				_stream.bufferTime = _bufferTime;
		}
		
		public function get url():String { return _url; }
		public function get video():Video { return _video; }
		public function get length():Number { return _length; }
		
		public function get height():Number { return _height; }
		public function get width():Number { return _width; }
		
		public function get percentLoading():Number { return _percentLoading; }
		public function get percentPlaying():Number { return _percentPlaying; }
		
		
		private function errorHandler(e:Event):void {
			dispatchEvent(new MediaEvent(MediaEvent.ERROR, e['text']));
		}
		
		private function statusHandler(e:NetStatusEvent):void {
			//trace(e.info.level + ': ' + e.info.code);
			
			switch (e.info.level) {
				case 'error': {
					close();
					dispatchEvent(new MediaEvent(MediaEvent.ERROR, e.info.code));
					
					/*switch(e.info.code) {
						case 'NetStream.Seek.InvalidTime': {
							
							//var _time:Number = _stream.time;
							//_stream.play(_url);
							//_stream.seek(e.info.details); 
							//_stream.seek(_time + .01);
							
							break;
						}
						default: {
							close();
							dispatchEvent(new MediaEvent(MediaEvent.ERROR, e.info.code));
							break;
						}
					}*/
					
					break;
				}
				
				case 'status': {
					switch(e.info.code) {
						case 'NetConnection.Connect.Closed': {
							break;
						}
						case 'NetConnection.Connect.Success': {
							initStream();
							_video.attachNetStream(_stream);
							
							pause = true;
							if (autoplay)
								play();
							
							_efDispatcher.addEventListener(Event.ENTER_FRAME, efHandler);
							break;
						}
						
						case 'NetStream.Buffer.Full': {
							dispatchEvent(new MediaEvent(MediaEvent.BUFFER_FULL));
							break;
						}
						case 'NetStream.Buffer.Flush': {
							break;
						}
						case 'NetStream.Buffer.Empty': {
							dispatchEvent(new MediaEvent(MediaEvent.BUFFER_EMPTY));
							break;
						}
						case 'NetStream.Seek.Notify': {
							calcPlaying(false);
							dispatchEvent(new MediaEvent(MediaEvent.BUFFER_EMPTY));
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
							break;
						}
					}
				}
			}
		}
		
		private function clientHandler(o:Object):void {
			_length = o.duration;
			_width = o.width;
			_height = o.height;
			
			dispatchEvent(new MediaEvent(MediaEvent.INIT));
		}
		
		private function efHandler(e:Event):void {
			if (_loading)
				calcLoading();
			
			if (_playing && !_pause)
				calcPlaying();
		}
		
		
		private function initConnection():void {
			_connection = new NetConnection();
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			_connection.connect(null);
		}
		
		private function destroyConnection():void {
			_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_connection.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			_connection.close();
			_connection = null;
		}
		
		private function initStream():void {
			_stream = new NetStream(_connection);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			_stream.client = { onMetaData:clientHandler };
			_stream.soundTransform = _transform;
			_stream.bufferTime = _bufferTime;
			_stream.play(_url);
		}
		
		private function destroyStream():void {
			_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			_stream.pause();
			_stream.close();
			_stream = null;
		}
		
		
		private function calcLoading():void {
			_percentLoading = Math.round(_stream.bytesLoaded / _stream.bytesTotal * 10000) / 10000;
			
			var _event:MediaEvent = new MediaEvent(MediaEvent.LOAD_PROGRESS);
			_event.bytesLoaded = _stream.bytesLoaded;
			_event.bytesTotal = _stream.bytesTotal;
			_event.loadingPercent = _percentLoading;
			dispatchEvent(_event);
			
			if (_percentLoading == 1) {
				_loading = false;
				dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
			}
		}
		
		private function calcPlaying(dispatch:Boolean = true):void {
			_percentPlaying = Math.round(_stream.time / _length * 10000) / 10000;
			
			if (dispatch) {
				var _event:MediaEvent = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				_event.position = _stream.time;
				_event.length = _length;
				_event.playingPercent = _percentPlaying;
				dispatchEvent(_event);
			}
		}
		
	}

}