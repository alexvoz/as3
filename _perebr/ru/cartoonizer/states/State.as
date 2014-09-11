package ru.cartoonizer.states 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import ru.cartoonizer.data.UserData;
	import ru.scarbo.gui.core.BasicSprite;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class State extends BasicSprite
	{
		protected var _libSprite:Sprite;
		protected var _userData:UserData;
		
		public function State() 
		{
			super();
		}
		
		public function set libSprite(value:Sprite):void {
			this._libSprite = value;
			super.addChild(this._libSprite);
		}
		
		public function set userData(value:UserData):void {
			this._userData = value;
		}
		
		override final public function addChild(child:DisplayObject):DisplayObject {
			var child:DisplayObject = this._libSprite.addChild(child);
			return child;
		}
	}

}