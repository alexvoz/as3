package ua.alexvoz.utils {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class Ranger extends Sprite {
		
		public function Rangers():void {
			
		}
		
		static public function rangeHorisontal(mc:DisplayObject = null, n:int = 1, i:int = 0, w:Number = 0, h:Number = 0, offsetX:Number = 0, offsetY:Number = 0):void {
			if (w == 0) w = mc.width;
			if (h == 0) h = mc.height;
			mc.x = (Math.floor(i / n) * w) + offsetX;
			mc.y = ((i % n) * h) + offsetY;
		}
		
		static public function rangeHorisontalArray(arr:Array, n:int = 1, w:Number = 0, h:Number = 0, offsetX:Number = 0, offsetY:Number = 0):void {
			for (var i:int = 0; i < arr.length; i++) {
				if (w == 0) w = arr[i].width;
				if (h == 0) h = arr[i].height;
				arr[i].x = (Math.floor(i / n) * w) + offsetX;
				arr[i].y = ((i % n) * h) + offsetY;
			}
		}
		
		static public function rangeVertical(mc:DisplayObject = null, n:int = 1, i:int = 0, w:Number = 0, h:Number = 0, offsetX:Number = 0, offsetY:Number = 0):void {
			if (w == 0) w = mc.width;
			if (h == 0) h = mc.height;
			mc.x = ((i % n) * w) + offsetX;
			mc.y = (Math.floor(i / n) * h) + offsetY;
		}
		
		static public function rangeVerticalArray(arr:Array, n:int = 1, w:Number = 0, h:Number = 0, offsetX:Number = 0, offsetY:Number = 0):void {
			for (var i:int = 0; i < arr.length; i++) {
				if (w == 0) w = arr[i].width;
				if (h == 0) h = arr[i].height;
				arr[i].x = ((i % n) * w) + offsetX;
				arr[i].y = (Math.floor(i / n) * h) + offsetY;
			}
		}
		
	}

}