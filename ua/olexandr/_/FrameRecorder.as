package ua.olexandr._ {
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import net.vis4.Utils;
	
	/**
	 * ...
	 * @author gka
	 */
	public class FrameRecorder {
		private var _screen:DisplayObject;
		private var _w:uint;
		private var _h:uint;
		private var _buffer:Array;
		private var _bgcol:uint;
		
		public function FrameRecorder(obj:DisplayObject, width:uint, height:uint, bgcol:uint = 0) {
			_screen = obj;
			_w = width;
			_h = height;
			_bgcol = bgcol;
		}
		
		public function startRecording():void {
			_buffer = [];
			_screen.addEventListener(Event.ENTER_FRAME, recordFrame);
		}
		
		public function stopRecording():void {
			_screen.removeEventListener(Event.ENTER_FRAME, recordFrame);
		}
		
		public function storeFrames(urlbase:String):void {
			var j:uint = _buffer.length;
			for (var i:uint = 0; i < j; i++) {
				new DelayedExecution(i * 500, this, storeFrame, i, urlbase);
			}
		}
		
		private function storeFrame(frame:uint, urlbase:String):void {
			var png:ByteArray = PNGEncoder.encode(_buffer[frame] as BitmapData);
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var req:URLRequest = new URLRequest(urlbase + Utils.leadingZeros(frame, 4) + ".png");
			req.requestHeaders.push(header);
			req.method = URLRequestMethod.POST;
			req.data = png;
			new URLLoader(req);
		}
		
		private function recordFrame(e:Event):void {
			var frame:BitmapData = new BitmapData(_w, _h, false, _bgcol);
			frame.draw(_screen);
			_buffer.push(frame);
		}
		
		public static function recordAndStore(obj:DisplayObject, w:Number, h:Number, url:String, scale:Number = 1):void {
			var frame:BitmapData = new BitmapData(w * scale, h * scale, false, 0xffffff);
			// obj.scaleX = obj.scaleY = scale;
			frame.draw(obj);
			
			var png:ByteArray = PNGEncoder.encode(frame);
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var req:URLRequest = new URLRequest(url);
			req.requestHeaders.push(header);
			req.method = URLRequestMethod.POST;
			req.data = png;
			new URLLoader(req);
		}
	
	}

}