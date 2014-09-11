/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.gadgets
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	
	/**
	 * кружочки по радиусу, по таймеру меняем альфу по кругу 
	 * @author silin
	 */
	public class Preloader extends Sprite
	{
		private var _list:Array = [];
		private var _age:int = 0;
		private var _timer:Timer = new Timer(80);
		private var _label:TextField = new TextField();
		
		/**
		 * constructor
		 * @param	size		размер основоного кргуга
		 * @param	color		цвет 
		 * @param	alpha		альфа
		 * @param	delay		задержка перестановки альфы кружков
		 */
		public function Preloader(size:int = 100, color:int = 0x808080, alpha:Number = 0.25, delay:int=80) 
		{
			
			_timer.delay = delay;
			var r:int = size / 2;
			var r1:int = Math.floor(size * Math.PI / 16) -1;
			
			
			var fmt:TextFormat = new TextFormat("_sans", 1.25*r1, color, true);
			_label.defaultTextFormat = fmt;
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.filters = [new BlurFilter(0, 0)];
			_label.alpha = alpha;
			addChild(_label);
			
			
			for (var i:int = 0; i < 8; i++) 
			{
				var u:Shape = new Shape();
				u.graphics.beginFill(color, alpha);
				u.graphics.drawCircle(0, 0, r1);
				u.x = r * Math.cos(i * Math.PI / 4);
				u.y = r * Math.sin(i * Math.PI / 4);
				addChild(u);
				_list.push(u);
			}
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			blendMode = BlendMode.INVERT;
		}
		
		
		
		private function onTimer(evnt:TimerEvent):void 
		{
			_age++;
			for (var i:int = 0; i < 8; i++) {
				var u:Shape = _list[i];
				var indx:int = (_age - i) % 8;
				u.alpha = 1 - 0.05 * indx;
			}
			evnt.updateAfterEvent();
		}
		/**
		 * надпись (по центру)
		 */
		public function get label():String { return _label.text; }
		
		public function set label(value:String):void 
		{
			
			_label.text = value;
			_label.x = -_label.width / 2;
			_label.y = -_label.height / 2;
			
			
		}
		
	}
	
}
