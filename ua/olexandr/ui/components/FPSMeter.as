package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class FPSMeter extends Component {
		protected var _label:Label;
		protected var _startTime:int;
		protected var _frames:int;
		protected var _prefix:String = "";
		protected var _fps:int = 0;
		
		public function FPSMeter(prefix:String = "FPS:") {
			super();
			_prefix = prefix;
			_frames = 0;
			_startTime = getTimer();
			setSize(50, 20);
			if (stage != null) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public override function draw():void {
			_label.text = _prefix + _fps.toString();
		}
		
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function start():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function set prefix(value:String):void {
			_prefix = value;
		}
		
		public function get prefix():String {
			return _prefix;
		}
		
		public function get fps():int {
			return _fps;
		}
		
		
		protected override function addChildren():void {
			super.addChildren();
			_label = new Label(this, 0, 0);
		}
		
		protected function onEnterFrame(event:Event):void {
			// Increment frame count each frame. When more than a second has passed, 
			// display number of accumulated frames and reset.
			// Thus FPS will only be calculated and displayed once per second.
			// There are more responsive methods that calculate FPS on every frame. 
			// This method is uses less CPU and avoids the "jitter" of those other methods.
			_frames++;
			var time:int = getTimer();
			var elapsed:int = time - _startTime;
			if (elapsed >= 1000) {
				_fps = Math.round(_frames * 1000 / elapsed);
				_frames = 0;
				_startTime = time;
				draw();
			}
		}
		
		protected function onRemovedFromStage(event:Event):void {
			stop();
		}
		
	}
}