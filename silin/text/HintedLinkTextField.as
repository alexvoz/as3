/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.text
{
	import flash.events.*;
	import flash.text.*;
	import silin.utils.*;
	
	/**
	 * текстфилд с всплывающими подсказками url ссылок
	 * @author silin
	 */
	public class HintedLinkTextField extends TextField 
	{
		private var prevState:Boolean = false;
		
		public function HintedLinkTextField() 
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMove);
		}
		
		private function this_addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			Hint.register(stage);
			
		}
		
		private function this_mouseMove(e:MouseEvent):void 
		{
			var fmt:TextFormat = getTextFormat(getCharIndexAtPoint(mouseX, mouseY));
			var currState:Boolean = (fmt.url && fmt.url.length);
			if (currState != prevState) (prevState = currState) ? Hint.show(fmt.url) : Hint.clear();
			
		}
		
		
	}
}