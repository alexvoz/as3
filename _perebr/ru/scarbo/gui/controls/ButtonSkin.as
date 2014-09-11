package ru.scarbo.gui.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ru.scarbo.gui.core.BasicFormat;
	import ru.scarbo.gui.core.IBasic;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ButtonSkin extends Sprite implements IBasic 
	{
		private var _width:int;
		private var _height:int;
		
		protected var _skin:DisplayObject;
		protected var _text:TextField;
		protected var _format:TextFormat;
		protected var _paddingTop:uint;
		protected var _paddingBottom:uint;
		protected var _paddingLeft:uint;
		protected var _paddingRight:uint;
		
		public function ButtonSkin(skin:DisplayObject = null, format:String = null)
		{
			this.mouseChildren = this.mouseEnabled = false;
			this._createSkin();
			this._createLabel();
			this.format = new BasicFormat(format);
			this.skin = skin;
		}
		
		public function get text():TextField { return this._text; }
		
		public function set format(value:TextFormat):void 
		{
			this._format = value;
			this._text.defaultTextFormat = this._format;
			this.redraw();
		}
		
		public function set skin(value:DisplayObject):void {
			if (this._skin) this.removeChild(this._skin);
			this._skin = value;
			this.addChildAt(this._skin, 0);
		}
		
		public function set paddingTop(value:uint):void 
		{
			this._paddingTop = value;
			this.redraw();
		}
		public function set paddingBottom(value:uint):void 
		{
			this._paddingBottom = value;
			this.redraw();
		}
		public function set paddingLeft(value:uint):void 
		{
			this._paddingLeft = value;
			this.redraw();
		}
		public function set paddingRight(value:uint):void 
		{
			this._paddingRight = value;
			this.redraw();
		}
		
		public function setSize(width:int, height:int):void 
		{
			this._width = width;
			this._height = height;
			this.redraw();
		}
		
		public function redraw():void {
			this._skin.width = this._width;
			this._skin.height = this._height;
			this._text.x = (this._width - (this._paddingLeft + this._paddingRight) - this._text.width) / 2;
			this._text.y = (this._height - (this._paddingTop + this._paddingBottom) - this._text.height) / 2;
		}
		
		protected function _createSkin():void {
			this._skin = new Shape();
			this.addChild(this._skin);
		}
		protected function _createLabel():void {
			this._text = new TextField();
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(this._text);
		}
	}

}