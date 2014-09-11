package ua.alexvoz.media {
	import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.StageVideoAvailabilityEvent;
    import flash.geom.Rectangle;
    import flash.media.StageVideo;
    import flash.events.NetStatusEvent;
	import flash.media.StageVideoAvailability;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	import flash.utils.ByteArray;
    /**
     * ...
     * @author ALeXVoz 
     * http://alexvoz.net/
     * E-mail: alexvoz@mail.ru
     * ICQ: 232-8-393-12
     * Skype: alexvozn
     */
	
    [Event(name="play", type="ua.alexvoz.media.StageVideoPlayerEvents")]
	[Event(name="error", type="ua.alexvoz.media.StageVideoPlayerEvents")]
	[Event(name="end", type="ua.alexvoz.media.StageVideoPlayerEvents")]
	[Event(name = "pause", type = "ua.alexvoz.media.StageVideoPlayerEvents")]
	
	public class StageVideoPlayer extends Sprite {
        private var _nc:NetConnection;
        private var _ns:NetStream;
        private var _video:Video;
        private var _stageVideo:StageVideo;
        private var _stage:Stage
		private var _videoURL:String;
		private var _client:CustomClient;
		private var _scale:Number;
		private var _paused:Boolean = false;
		private var _bufferTime:Number;
		private var _byteArray:ByteArray;
		private var _numStageVideo:int = 0; //max for desktop = 8, max for mobile = 1;
         
        public function StageVideoPlayer(mainStage:Stage = null) {
            _stage = mainStage;
        }
		
		public function initVideoPlayer(bufferTime:Number,  url:String = '', bytes:ByteArray = null):void {
			_videoURL = url;
			_byteArray = bytes;
			_nc = new NetConnection(); 
            _nc.connect(null); 
            _ns = new NetStream(_nc); 
			_client = new CustomClient();
            _ns.client = _client
            _ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
            _ns.bufferTime = bufferTime;
			if (_byteArray) _ns.appendBytes(_byteArray);
		}
         
        private function asyncErrorHandler(e:AsyncErrorEvent):void {
            dispatchEvent(new StageVideoPlayerEvents(StageVideoPlayerEvents.ERROR, e.error));
            //trace(e.error);
        }
         
        public function playVideo():void {
			_stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
        }
         
        public function setSize(width:Number, height:Number, inscribed:Boolean = true):void {
			if (_client.metaData) {
				if (inscribed) _scale = Math.min(width / _client.metaData.width, height / _client.metaData.height);
					else _scale = Math.max(width / _client.metaData.width, height / _client.metaData.height);
				var _vW:Number = _client.metaData.width * _scale;
				var _vH:Number = _client.metaData.height * _scale;
				var _vX:Number = width / 2 - _vW / 2;
				var _vY:Number = height / 2 - _vH / 2;
				if (_stageVideo != null) {
					_stageVideo.viewPort = new Rectangle (_vX, _vY, _vW, _vH);
				}
				if (_video != null) {
					_video.x = _vX;
					_video.y = _vY;
					_video.width = _vW;
					_video.height = _vH;
				}
			} else {
				trace('Not ready!');
			}
        }
         
        private function onStageVideoAvailability(e:StageVideoAvailabilityEvent):void {
            _stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
            if (e.availability == StageVideoAvailability.AVAILABLE) {
                _stageVideo = _stage.stageVideos[_numStageVideo];
                _stageVideo.attachNetStream(_ns);
            } else {
                _video = new Video(); 
                _video.attachNetStream(_ns); 
                addChild(_video);
            }
            if (_videoURL != '') _ns.play(_videoURL)
				else if (_byteArray) _ns.play(null)
					else dispatchEvent(new StageVideoPlayerEvents(StageVideoPlayerEvents.ERROR, 'URL or ByteArray are not available'));
            _ns.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			//_stage.addEventListener(Event.RESIZE, onResize);
        }
		
		public function get videoTime():Number {
			return _ns.time;
		}
		
		public function get numStageVideo():int {
			return _numStageVideo;
		}
		
		public function set numStageVideo(value:int):void {
			_numStageVideo = value;
		}
         
        private function statusHandler(e:NetStatusEvent):void { 
            trace(e.info.code);
            if (e.info.code == "NetStream.Buffer.Full") {
				//onResize(null);
				if (_paused) _ns.pause();
				dispatchEvent(new StageVideoPlayerEvents(StageVideoPlayerEvents.PLAY));
			}
            if (e.info.code == "NetStream.Play.Stop" || e.info.code == "NetStream.Buffer.Empty") {
                dispatchEvent(new StageVideoPlayerEvents(StageVideoPlayerEvents.END));
            }
			if (e.info.code == "NetStream.Pause.Notify") {
                dispatchEvent(new StageVideoPlayerEvents(StageVideoPlayerEvents.PAUSE));
            }
        }
         
        public function pauseVideo():void {
			if (!_paused) {
				_paused = true;
				_ns.pause();
			}
        }
		
		public function resumeVideo():void {
			if (_paused) {
				_paused = false
				_ns.resume();
			}
        }
		
		public function deleteVideo():void {
			if (_ns) _ns.close();
            if (_stageVideo != null) _stageVideo = null;
            if (_video != null) { 
				_stage.removeChild(_video); 
				_video = null; 
			}
		}
		
    }
 
}
 
 
internal class CustomClient {
	private var _metaData:Object;
         
        public function CustomClient() {
            
        }
         
        public function onMetaData(info:Object):void {
            //trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			_metaData = info;
        }
         
        public function onCuePoint(info:Object):void {
            //trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
        }
         
        public function onXMPData(info:Object):void {
            //trace(info.toString());
			//for (var _name:Object in info) {
				//trace(_name + ':', info[_name]);
			//}
        }
		
		public function onPlayStatus(info:Object):void {
            //trace("playstatus: level=" + info.level + " code=" + info.code);
			//for (var _name:Object in info) {
				//trace(_name + ':', info[_name]);
			//}
        }
		
		public function get metaData():Object {
			return _metaData;
		}
    }