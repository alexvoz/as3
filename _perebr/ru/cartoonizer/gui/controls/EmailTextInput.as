package ru.cartoonizer.gui.controls 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import ru.scarbo.gui.controls.TextInput;
	import ru.scarbo.data.ClassLibrary;
	import ru.scarbo.utils.StringUtils;
	import ru.cartoonizer.gui.events.ValidateEvent;
	
	/**
	 * ...
	 * @author Vyacheslav Makhotkin <retardeddude@gmail.com>
	 */
	public class EmailTextInput extends Sprite
	{
		private var _crossIcon:Sprite;
		private var _textInput:TextInput;
		private var _tickIcon:Sprite
		
		public function EmailTextInput() 
		{
			super();
			
			this._textInput = new TextInput();
			this._textInput.setSize(350, 30);
			this._textInput.skin = ClassLibrary.getDisplayObject('TextInputUpSkin');
			this._textInput.restrict = '_-0-9a-zA-Z@.';
			this.addChild(this._textInput);
			
			this._textInput.addEventListener(FocusEvent.FOCUS_OUT, this._emailFocusOutHandler);
			this._textInput.addEventListener(Event.CHANGE, this._emailChangeHandler);
			
			this._tickIcon = ClassLibrary.getDisplayObject('TickIcon') as Sprite;
			this._addIcon(this._tickIcon);
			
			this._crossIcon = ClassLibrary.getDisplayObject('CrossIcon') as Sprite;
			this._addIcon(this._crossIcon);
		}
		
		private function _addIcon(icon:Sprite):void {
			icon.x = this._textInput.width + 10;
			icon.y = this._textInput.y + this._textInput.height / 2 - icon.height / 2;
			icon.visible = false;
			this.addChild(icon);
		}
		
		private function _emailChangeHandler(e:Event):void {
			var isValid:Boolean = this._isValidEmail();
			if (isValid) {
				this.dispatchEvent(new Event(ValidateEvent.VALID));
			} else {
				this.dispatchEvent(new Event(ValidateEvent.INVALID));
			}
			this._tickIcon.visible = isValid;
			this._crossIcon.visible = false;
		}
		
		private function _emailFocusOutHandler(e:FocusEvent):void {
			var isValid:Boolean = this._isValidEmail();
			if (isValid) {
				this.dispatchEvent(new Event(ValidateEvent.VALID));
			} else {
				this.dispatchEvent(new Event(ValidateEvent.INVALID));
			}
			this._tickIcon.visible = isValid;
			this._crossIcon.visible = !isValid;
		}
		
		private function _isValidEmail():Boolean {
			var email:String = this._textInput.text;
			return StringUtils.checkEmail(email);
		}
		
		public function hasValidValue():Boolean {
			var email:String = this._textInput.text;
			return email.length && StringUtils.checkEmail(email);
		}
		
		public function get value():String {
			return this._textInput.text;
		}
		
		public function showErrorIcon():void {
			this._crossIcon.visible = true;
		}
	}

}