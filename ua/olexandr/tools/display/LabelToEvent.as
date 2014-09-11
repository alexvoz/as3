package ua.olexandr.tools.display {
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import ua.olexandr.functions.createHandler;
	
	/**
	* @author Sergey Vanichkin aka ALiEN
	*/
	
	public class LabelToEvent {
		
		/*
		var movie:MovieClip = new Movie();
		addChild(movie);
		
		// в Movie есть метки с названиями "myLabel1" и "myLabel2"
		movie.addEventListener("myLabel1", _onEvent);
		movie.addEventListener("myLabel2", _onEvent);
		
		LabelToEvent.addTo(movie);
		
		function _onEvent(e:Event):void {
			trace(e.type);
		}
		*/
		
		[Inline]
		public static function addTo(mc:MovieClip):Array {
			var _labels:Array = mc.currentLabels;
			var _names:Array = [];
			
			var _len:uint = _labels.length;
			for ( var i:uint = 0, len:uint = _len; i < len; i++ ) {
				var _label:FrameLabel = _labels[i];
				var _index:uint = _label.frame - 1;
				var _event:Event = new Event(_label.name);
				
				mc.addFrameScript(_index, createHandler(mc.dispatchEvent, _event));
				
				_names[i] = _label.name;
			}
			
			return _names;
		}
		
	}
}


