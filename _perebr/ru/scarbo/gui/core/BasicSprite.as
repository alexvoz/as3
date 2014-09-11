package ru.scarbo.gui.core 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import ru.scarbo.gui.events.BasicEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BasicSprite extends Sprite implements IBasic
	{
		protected var _width:int = -1;
		protected var _height:int = -1;
		protected var _data:Object = { };
		protected var _initialised:Boolean = false;
		protected var _builted:Boolean = false;
		protected var _changed:Boolean = false;
		protected var _regenerate:Boolean = false;
		
		public function BasicSprite() 
		{
			super();
			this._init();
			this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
		}
		
		override public final function get width():Number { return this._width; }
		override public final function get height():Number { return this._height; }
		
		public final function get initialised():Boolean { return this._initialised; }
		public final function get builded():Boolean { return this._builted; }
		
		public final function get regenerate():Boolean { return _regenerate; }
		public final function set regenerate(value:Boolean):void 
		{
			_regenerate = value;
		}
		
		public final function get changed():Boolean { return this._changed; }
		public final function set changed(value:Boolean):void {
			this._changed = value;
			if (value) {
				this._renderExecute();
			}
		}
		
		public function get data():Object { return this._data; }
		public function set data(value:Object):void 
		{
			if (this._data != value) {
				this._data = value;
				this.dispatchEvent(new BasicEvent(BasicEvent.DATA_CHANGE));
			}
		}
		
		public final function setSize(width:int, height:int):void {
			if (width == this._width && height == this._height) return;
			if (width < 0) this._width = 0;
			if (height < 0) this._height = 0;
			//
			if (this._width != width) {
				this._width = width;
			}
			if (this._height != height) {
				this._height = height;
			}
			//
			this.changed = true;
		}
		
		public function redraw():void {
			this._draw();
			this._changed = false;
		}
		
		
		protected function _addedToStageHandler(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler);
			this.stage.addEventListener(Event.RENDER, this._renderHandler);
			//
			if (!this._builted) {
				this._build();
			}
			if (this._changed) {
				this._renderExecute();
			}
		}
		protected function _removedFromStageHandler(e:Event):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler);
			this.stage.removeEventListener(Event.RENDER, this._renderHandler);
			this._destroy();
			if (this._regenerate) this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
		}
		
		protected function _init():void {
			this._initialised = true;
			this.dispatchEvent(new BasicEvent(BasicEvent.INITIALIZE));
		}
		protected function _build():void {
			this._builted = true;
			this.changed = true;
			this.dispatchEvent(new BasicEvent(BasicEvent.BUILD));
		}
		protected function _destroy():void {
			this._builted = false;
			this.dispatchEvent(new BasicEvent(BasicEvent.DESTROY));
		}
		protected function _draw():void {
			this.dispatchEvent(new BasicEvent(BasicEvent.DRAW));
		}
		
		
		private function _renderHandler(e:Event):void {
			if (this._changed) {
				this._draw();
				this._changed = false;
			}
		}
		private function _renderExecute():void {
			if (this.stage) {
				this.stage.invalidate();
			}
		}
	}

}