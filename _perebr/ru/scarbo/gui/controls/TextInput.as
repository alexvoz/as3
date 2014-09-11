package ru.scarbo.gui.controls 
{
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import ru.scarbo.gui.core.BasicFormat;
	import ru.scarbo.gui.core.BasicSprite;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class TextInput extends BasicSprite
	{
		private var _skinContainer:Sprite;
		private var _skin:DisplayObject;
		private var _text:TextField;
		private var _padding:uint = 2;
		private var _format:BasicFormat;
		
		public function TextInput() 
		{
			super();
		}
		
		public function set skin(value:DisplayObject):void {
			while (this._skinContainer.numChildren > 0) this._skinContainer.removeChildAt(0);
			this._skin = value;
			this._skinContainer.addChild(this._skin);
		}
		
		public function get text():String { return this._text.text; }
		public function set text(value:String):void {
			this._text.text = value;
		}
		
		public function set restrict(value:String):void {
			this._text.restrict = value;
		}
		
		override protected function _init():void {
			this._skinContainer = new Sprite();
			this.addChild(this._skinContainer);
			//
			this._format = new BasicFormat('font:Calibri,color:#333333,size:19');
			this._text = new TextField();
			this._text.type = TextFieldType.INPUT;
			this._text.mouseEnabled = true;
			//this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.defaultTextFormat = this._format;
			this._text.addEventListener(Event.CHANGE, _dispathHandler);
			this._text.addEventListener(TextEvent.TEXT_INPUT, _dispathHandler);
			this.addChild(this._text);
			//
			super._init();
		}
		
		override protected function _draw():void {
			this._skin.width = this._width;
			this._skin.height = this._height;
			this._text.height = this._height - this._padding * 2;
			this._text.width = this._width - this._padding * 2;
			this._text.x = this._text.y = this._padding;
			//
			super._draw();
		}
		
		private function _dispathHandler(e:Event):void {
			this.dispatchEvent(e.clone());
		}
		
	}

}