package ua.olexandr.text {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import ua.olexandr.net.NetNavigator;
	import ua.olexandr.text.Label;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Link extends Sprite {
		
		public var url:String;
		public var target:String;
		public var visitedMode:Boolean;
		
		private const NORMAL:uint = 0;
		private const HOVER:uint = 1;
		private const PRESS:uint = 2;
		
		private var _hovered:Boolean;
		private var _pressed:Boolean;
		
		private var _underlineHover:Boolean = false;
		private var _textColor:uint = 0x0000EE;
		private var _textAlpha:Number = 1;
		private var _textColorHover:uint = 0x0000EE;
		private var _textAlphaHover:Number = 1;
		private var _textColorPress:uint = 0x551A8B;
		private var _textAlphaPress:Number = 1;
		
		private var _label:Label;
		private var _state:int;
		
		/**
		 * 
		 * @param	color
		 * @param	size
		 */
		public function Link(text:String, url:String = "", visitedMode:Boolean = true) {
			this.url = url;
			this.visitedMode = visitedMode;
			
			_label = new Label(0x000000, 12);
			_label.text = text;
			addChild(_label);
			
			_hovered = false;
			_pressed = false;
			
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, overHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, outHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, upHandler, false, 0, true);
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			_state = -1;
			setState(NORMAL);
		}
		
		/**
		 * 
		 */
		public function get label():Label { return _label; }
		
		/**
		 * 
		 */
		public function get underlineHover():Boolean { return _underlineHover; }
		public function set underlineHover(value:Boolean):void {
			_underlineHover = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get textColor():uint { return _textColor; }
		public function set textColor(value:uint):void {
			_textColor = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get textAlpha():Number { return _textAlpha; }
		public function set textAlpha(value:Number):void {
			_textAlpha = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get textColorHover():uint { return _textColorHover; }
		public function set textColorHover(value:uint):void {
			_textColorHover = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get textAlphaHover():Number { return _textAlphaHover; }
		public function set textAlphaHover(value:Number):void {
			_textAlphaHover = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get textColorPress():uint { return _textColorPress; }
		public function set textColorPress(value:uint):void {
			_textColorPress = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get textAlphaPress():Number { return _textAlphaPress; }
		public function set textAlphaPress(value:Number):void { 
			_textAlphaPress = value;
			updateView();
		}
		
		
		private function overHandler(e:MouseEvent):void {
			_hovered = true;
			setState(_pressed ? PRESS : HOVER);
		}
		
		private function outHandler(e:MouseEvent):void {
			_hovered = false;
			setState(_pressed ? PRESS : NORMAL);
		}
		
		private function downHandler(e:MouseEvent):void {
			_pressed = true;
			setState(PRESS);
		}
		
		private function upHandler(e:MouseEvent):void {
			_pressed = false;
			setState(_hovered ? HOVER : NORMAL);
		}
		
		private function clickHandler(e:MouseEvent):void {
			NetNavigator.gotoURL(url, target);
			
			if (visitedMode) {
				_textColor = _textColorPress;
				_textAlpha = _textAlphaPress;
				
				_textColorHover = _textColor;
				_textAlphaHover = _textAlpha;
				
				updateView();
			}
		}
		
		
		private function setState(state:int):void {
			if (_state == state)
				return;
			
			_state = state;
			updateView();
		}
		
		private function updateView():void {
			switch(_state) {
				case NORMAL: {
					_label.underline = !_underlineHover;
					_label.textColor = _textColor;
					_label.alpha = _textAlpha;
					break;
				}
				case HOVER: {
					_label.underline = _underlineHover;
					_label.textColor = _textColorHover;
					_label.alpha = _textAlphaHover;
					break;
				}
				case PRESS: {
					_label.underline = _underlineHover;
					_label.textColor = _textColorPress;
					_label.alpha = _textAlphaPress;
					break;
				}
			}
		}
		
	}

}