package ua.alexvoz.text {
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ua.olexandr.utils.FontUtils;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class Label extends TextField {
		
		public function Label(fontClass:Class, Size:int, Color:uint, Text:String = '', AutoSize:String = 'left', Align:String = 'left', Multiline:Boolean = false, Sharpness:int = -50, Thickness:int = 1) {
			var _font:String = FontUtils.registerFont(fontClass);
			var _format:TextFormat = getTextFormat();
			_format.font = _font;
			_format.size = Size;
			_format.color = Color;
			_format.align = Align;
			this.setTextFormat(_format);
			this.defaultTextFormat = _format;
			this.multiline = Multiline;
			this.wordWrap = Multiline;
			this.embedFonts = true;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.sharpness = Sharpness;
			this.thickness = Thickness;
			switch (AutoSize){
				case 'left':
					this.autoSize = TextFieldAutoSize.LEFT;
					break;
				case 'right':
					this.autoSize = TextFieldAutoSize.RIGHT;
					break;
				case 'center':
					this.autoSize = TextFieldAutoSize.CENTER;
					break;
				case 'none':
					this.autoSize = TextFieldAutoSize.NONE;
					break;
				default:
					trace('Incorrect autoSize parametr');
					this.autoSize = TextFieldAutoSize.LEFT;
					break;
			}
			this.selectable = false;
			this.mouseWheelEnabled = false;
			this.text = Text;
			this.name = 'label';
		}
		
		public function setUnderline(flag:Boolean = true):void {
			var _format:TextFormat = getTextFormat();
			_format.underline = flag;
			this.setTextFormat(_format);
			this.defaultTextFormat = _format;
		}
		
	}

}