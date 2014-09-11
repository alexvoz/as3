package ua.olexandr.media {
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import ua.olexandr.events.MediaEvent;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class AudioPlayer extends EventDispatcher {
		
		public var autoplay:Boolean;
		public var repeat:Boolean;
		
		private var _url:String;
		private var _loading:Boolean;
		private var _playing:Boolean;
		private var _pause:Boolean;
		
		private var _percentageLoading:Number;
		private var _percentagePlaying:Number;
		private var _position:Number;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		
		private var _timer:Timer;
		private var _dispatch:Boolean;
		
		/**
		 * 
		 * @param	volume
		 */
		public function AudioPlayer(volume:Number = .5) {
			autoplay = true;
			repeat = false;
			
			_loading = false;
			_playing = false;
			_pause = true;
			
			_percentageLoading = 0;
			_percentagePlaying = 0;
			_position = 0;
			
			_transform = new SoundTransform(0);
			_transform.volume = volume;
			
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			_dispatch = true;
		}
		
		/**
		 * 
		 * @param	url
		 */
		public function load(url:String):void {
			if (url && url != _url) {
				
				_dispatch = false;
				close();
				_dispatch = true;
				
				_url = url;
				
				_sound = new Sound();
				_sound.addEventListener(IOErrorEvent.IO_ERROR, soundErrorHandler);
				_sound.addEventListener(ProgressEvent.PROGRESS, soundProgressHandler);
				_sound.addEventListener(Event.COMPLETE, soundCompleteHandler);
				_sound.load(new URLRequest(_url));
				
				if (autoplay) 
					play();
			}
		}
		
		/**
		 * 
		 */
		public function play():void {
			_playing = true;
			_pause = false;
			
			try {
				_channel = _sound.play(_position, 0, _transform);
				_channel.addEventListener(Event.SOUND_COMPLETE, channelCompleteHandler);
				_timer.start();
				if (_dispatch)
					dispatchEvent(new MediaEvent(MediaEvent.PLAY_START));
			} catch (e:Error) {
				if (_dispatch)
					dispatchEvent(new MediaEvent(MediaEvent.ERROR, e.message));
			}
		}
		
		/**
		 * 
		 * @param	position
		 */
		public function seek(position:Number):void {
			if (_pause) {
				_position = position;
				timerHandler(null);
			} else {
				_dispatch = false;
				close();
				_position = position;
				play();
				_dispatch = true;
			}
		}
		
		/**
		 * 
		 */
		public function close():void {
			if (_sound) {
				try { 
					_sound.close();
				} catch (e:Error) { }
				soundCompleteHandler(null);
				
				_channel.stop();
				channelCompleteHandler(null);
				
				_url = '';
				
				_percentageLoading = 0;
				_percentagePlaying = 0;
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
			Tweener.addTween(_transform, { volume:value, time:.5, transition:Equations.easeNone, onUpdate:function():void {
				if (_channel)
					_channel.soundTransform = _transform;
			} } );
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
			_dispatch = false;
			if (_pause) {
				if (_channel) {
					_channel.stop();
					_channel.removeEventListener(Event.SOUND_COMPLETE, channelCompleteHandler);
					_timer.stop();
				}
			} else {
				play();
			}
			_dispatch = true;
		}
		
		/**
		 * 
		 */
		public function get url():String { return _url; }
		/**
		 * 
		 */
		public function get length():Number { return _sound ? _sound.length : NaN; }
		/**
		 * 
		 */
		public function get position():Number { return _channel ? _channel.position : NaN; }
		/**
		 * 
		 */
		public function get percentLoaded():Number { return _percentageLoading; }
		/**
		 * 
		 */
		public function get percentPlayed():Number { return _percentagePlaying; }
		
		/**
		 * 
		 */
		public function get isLoading():Boolean { return _loading; }
		/**
		 * 
		 */
		public function get isPlaying():Boolean { return _playing; }
		
		
		private function soundErrorHandler(e:IOErrorEvent):void {
			if (_dispatch)
				dispatchEvent(new MediaEvent(MediaEvent.ERROR, e.text));
		}
		
		private function soundProgressHandler(e:ProgressEvent):void {
			_percentageLoading = Math.round(e.bytesLoaded / e.bytesTotal * 10000) / 10000;
			
			if (_dispatch) {
				var _event:MediaEvent = new MediaEvent(MediaEvent.LOAD_PROGRESS);
				_event.bytesLoaded = e.bytesLoaded;
				_event.bytesTotal = e.bytesTotal;
				_event.percentageLoading = _percentageLoading;
				
				dispatchEvent(_event);
			}
		}
		
		private function soundCompleteHandler(e:Event):void {
			_loading = false;
			
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, soundErrorHandler);
			_sound.removeEventListener(ProgressEvent.PROGRESS, soundProgressHandler);
			_sound.removeEventListener(Event.COMPLETE, soundCompleteHandler);
			
			if (_dispatch)
				dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
		}
		
		private function channelCompleteHandler(e:Event):void {
			_playing = false;
			_pause = true;
			_position = 0;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, channelCompleteHandler);
			_timer.stop();
			
			if (e) {
				if (_dispatch)
					dispatchEvent(new MediaEvent(MediaEvent.PLAY_COMPLETE));
				if (repeat)
					play();
			}
		}
		
		private function timerHandler(e:TimerEvent):void {
			if (e) _position = _channel.position;
			_percentagePlaying = Math.round(_position / _sound.length * 10000) / 10000;
			
			if (_dispatch && !_pause) {
				var _event:MediaEvent = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				_event.position = _position;
				_event.length = _sound.length;
				_event.percentagePlaying = _percentagePlaying;
				dispatchEvent(_event);
			}
		}
		
	}

}