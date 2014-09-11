package ru.scarbo.gui.core
{
	import flash.display.DisplayObject;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import ru.scarbo.gui.events.ButtonEvent;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class BasicButton extends BasicContainer
	{
		public static const SKIN:uint = 0;
		public static const SKIN_OVER:uint = 1;
		public static const SKIN_PRESS:uint = 2;
		public static const SKIN_SELECTED:uint = 3;

		protected var _skins:Dictionary;
		protected var _currentSkin:DisplayObject;
		protected var _selected:Boolean;

		public function BasicButton()
		{
			super();
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			this._selected = value;
			if (this._selected) {
				this._setSkin(BasicButton.SKIN_SELECTED);
			}else {
				this._setSkin(BasicButton.SKIN);
			}
		}

		public function setSkin(skin:DisplayObject, state:uint):void {
			var _skin:DisplayObject = this._skins[state] as DisplayObject;
			if (_skin) this.removeChild(_skin);
			if (skin) this.addChild(skin);
			this._skins[state] = skin;
			this._setSkin(state);
		}

		override protected function _init():void {
			this.mouseChildren = false;
			this.buttonMode = true;
			this.mouseEnabled = true;
			this._skins = new Dictionary(true);
			//
			super._init();
		}
		override protected function _build():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, this._mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this._mouseOutHandler);
			this.addEventListener(MouseEvent.CLICK, this._mouseClickHandler);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this._mouseDoubleClickHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
			//
			this._setSkin(BasicButton.SKIN);
			super._build();
		}
		override protected function _destroy():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, this._mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this._mouseOutHandler);
			this.removeEventListener(MouseEvent.CLICK, this._mouseClickHandler);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, this._mouseDoubleClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler, true);
			//
			super._destroy();
		}

		protected function _buttonOverHandler():void { }
		protected function _buttonOutHandler():void { }
		protected function _buttonPressHandler():void { }
		protected function _buttonReleaseHandler():void { }
		protected function _buttonReleaseOutsideHandler():void { }
		protected function _buttonClickHandler():void { }
		protected function _buttonDoubleClickHandler():void { }

		private function _mouseOverHandler(e:MouseEvent):void {
			this._buttonOverHandler();
			if (!this._selected) this._setSkin(BasicButton.SKIN_OVER);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.OVER));
		}
		private function _mouseOutHandler(e:MouseEvent):void {
			this._buttonOutHandler();
			if (!this._selected) this._setSkin(BasicButton.SKIN);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.OUT));
		}
		private function _mouseDownHandler(e:MouseEvent):void {
			this._buttonPressHandler();
			if (!this._selected) this._setSkin(BasicButton.SKIN_PRESS);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler, true);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
		}
		private function _mouseUpHandler(e:MouseEvent):void {
			if (e.eventPhase == EventPhase.BUBBLING_PHASE) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler, true);
			//
			if (e.target == this) {
				this._buttonReleaseHandler();
				//this._setSkin(BasicButton.SKIN_OVER);
				this.dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE));
			}else {
				this._buttonReleaseOutsideHandler();
				//this._setSkin(BasicButton.SKIN);
				this.dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUTSIDE));
			}
		}
		private function _mouseClickHandler(e:MouseEvent):void {
			this._buttonClickHandler();
			this.dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
		}
		private function _mouseDoubleClickHandler(e:MouseEvent):void {
			this._buttonDoubleClickHandler();
			this.dispatchEvent(new ButtonEvent(ButtonEvent.DOUBLE_CLICK));
		}

		private function _setSkin(value:uint):void {
			var skin:DisplayObject = this._skins[value] as DisplayObject;
			if (skin) {
				if (this._currentSkin) this._currentSkin.visible = false;
				this._currentSkin = skin;
				this._currentSkin.visible = true;
				this.changed = true;
			}
		}
	}

}
