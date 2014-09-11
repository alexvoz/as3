package ru.scarbo.gui.controls 
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ru.scarbo.gui.core.BasicButton;
	import ru.scarbo.gui.core.BasicFormat;
	import ru.scarbo.gui.core.IBasic;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class Button extends BasicButton 
	{
		protected var _text:TextField;
		protected var _format:BasicFormat;
		
		private var _label:String;
		
		public function Button() 
		{
			super();
			super.setSize(164, 41);
		}
		
		public function get label():String { return this._label; }
		public function set label(value:String):void {
			this._label = value;
			this.changed = true;
		}
		
		override public function setSkin(skin:DisplayObject, state:uint):void {
			if (skin is ButtonSkin) {
				super.setSkin(skin, state);
			}
		}
		
		override protected function _draw():void {
			ButtonSkin(this._currentSkin).text.text = this._label;
			ButtonSkin(this._currentSkin).setSize(this._width, this._height);
			//
			super._draw();
		}
	}

}