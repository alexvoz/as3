/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.text
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * для FD проектов: текстфилд с датой компиляции 
	 * @author silin
	 */
	public class TimeStamp extends TextField 
	{
		private var align:String;
		private var prefix:String = "";
		/**
		 * 
		 * @param	align  расположение в стиле StageAlign
		 */
		public function TimeStamp(align:String=StageAlign.BOTTOM_LEFT, prefix:String="_______\n") 
		{
			
			this.align =  align;
			this.prefix = prefix;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			text = prefix + (CONFIG::timeStamp).split("/").join(".");
			
			autoSize = TextFieldAutoSize.LEFT;
			setTextFormat(new TextFormat("_sans", 11, 0x808080));
			switch(align)
			{
			case StageAlign.TOP_RIGHT:
				x = stage.stageWidth - textWidth;
			break;
			case StageAlign.BOTTOM_LEFT:
				y = stage.stageHeight - textHeight;
			break;
			case StageAlign.BOTTOM_RIGHT:
				x = stage.stageWidth - textWidth;
				y = stage.stageHeight - textHeight;
			break;
			default:
			}
		}
		
	}

}