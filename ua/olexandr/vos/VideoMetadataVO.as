package ua.olexandr.vos {
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class VideoMetadataVO {
		
		private var _canSeekToEnd:Boolean;
		private var _cuePoints:Array;
		private var _audiocodecid:Number;
		private var _audiodelay:Number;
		private var _audiodatarate:Number;
		private var _framerate:Number;
		private var _videocodecid:Number;
		private var _videodatarate:Number;
		private var _height:Number;
		private var _width:Number;
		private var _duration:Number;
		
		/**
		 * 
		 * @param	data
		 */
		public function VideoMetadataVO(data:Object) {
			_canSeekToEnd = data.canSeekToEnd;
			_cuePoints = data.cuePoints;
			_audiocodecid = data.audiocodecid;
			_audiodelay = data.audiodelay;
			_audiodatarate = data.audiodatarate;
			_framerate = data.framerate;
			_videocodecid = data.videocodecid;
			_videodatarate = data.videodatarate;
			_height = data.height;
			_width = data.width;
			_duration = data.duration;
		}
		
		/**
		 * 
		 */
		public function get canSeekToEnd():Boolean { return _canSeekToEnd; }
		
		/**
		 * 
		 */
		public function get cuePoints():Array { return _cuePoints; }
		
		/**
		 * 
		 */
		public function get audiodelay():Number { return _audiocodecid; }
		/**
		 * 
		 */
		public function get audiocodecid():Number { return _audiodelay; }
		/**
		 * 
		 */
		public function get audiodatarate():Number { return _audiodatarate; }
		
		/**
		 * 
		 */
		public function get framerate():Number { return _framerate; }
		/**
		 * 
		 */
		public function get videocodecid():Number { return _videocodecid; }
		/**
		 * 
		 */
		public function get videodatarate():Number { return _videodatarate; }
		
		/**
		 * 
		 */
		public function get height():Number { return _height; }
		/**
		 * 
		 */
		public function get width():Number { return _width; }
		/**
		 * 
		 */
		public function get duration():Number { return _duration; }
		
	}

}