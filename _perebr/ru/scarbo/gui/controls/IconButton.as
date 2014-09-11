package ru.scarbo.gui.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import ru.scarbo.gui.core.BasicButton;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class IconButton extends BasicButton 
	{
		protected var _icon:DisplayObject;
		protected var _padding:uint;
		
		public function IconButton() 
		{
			super();
		}
		
		public function set icon(value:DisplayObject):void {
			this.setSkin(value, BasicButton.SKIN);
			this.setSkin(null, BasicButton.SKIN_OVER);
			this.setSkin(null, BasicButton.SKIN_PRESS);
			this._currentSkin = value;
			this.changed = true;
		}
		
		override protected function _draw():void {
			if (this._currentSkin && this._width > 0 && this._height > 0) {
				this._currentSkin.x = (this._width - this._padding * 2 - this._currentSkin.width) / 2;
				this._currentSkin.y = (this._height - this._padding * 2 - this._currentSkin.height) / 2;
				//
				super._draw();
			}
		}
	}

}