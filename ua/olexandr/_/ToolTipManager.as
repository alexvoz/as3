package ua.olexandr._ {
	import flash.display.Stage;
	import flash.events.Event;
	import ua.olexandr.display.ToolTip;
	import ua.olexandr.tools.tweener.Tweener;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class ToolTipManager {
		
		private static var _stage:Stage;
		
		private static var _tips:Array = [];
		
		//private var _showTimer:Timer; 
		//private var _hideTimer:Timer;
		
		public static function init(stage:Stage):void {
			_stage = stage;
		}
		
		public static function show(tip:ToolTip):void {
			//_showTimer = new Timer(600, 1);
			//_showTimer.addEventListener(TimerEvent.TIMER, show);
			//_hideTimer = new Timer(6000, 1);
			//_hideTimer.addEventListener(TimerEvent.TIMER, hide);
			
			if (_stage) {
				_tips.push(tip);
				
				tip.alpha = 0;
				_stage.addChild(tip);
				
				tip.addEventListener(Event.ENTER_FRAME, onTipEnterFrame);
				Tweener.addTween(tip, .3, {alpha: 1});
			}
		}
		
		public static function hide(tip:ToolTip):void {
			var index:int = _tips.indexOf(tip);
			if (index != -1) {
				_tips.splice(index, 1);
				
				Tweener.addTween(tip, .3, {alpha: 0, onComplete: function():void {
						tip.removeEventListener(Event.ENTER_FRAME, onTipEnterFrame);
					}});
			}
		}
		
		private static function onTipEnterFrame(e:Event):void {
			var tip:ToolTip = e.target as ToolTip;
			
			tip.x = _stage.mouseX;
			tip.y = _stage.mouseY;
			
			var offset:int = tip.tailOffset + tip.tailCenter;
			if (tip.x > _stage.stageWidth - tip.width + offset)
				tip.x = _stage.stageWidth - tip.width + offset;
			if (tip.x < offset)
				tip.x = offset;
			
			if (tip.y > _stage.stageHeight)
				tip.y = _stage.stageHeight;
			if (tip.y < tip.height)
				tip.y = tip.height;
		
			//_showTimer.reset();
			//_showTimer.start();
		}
	
	}

}