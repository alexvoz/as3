package ua.olexandr.text {
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class Label extends TextField {
		
		/**
		 * 
		 */
		public static const ALIGN_CENTER:String 	= TextFormatAlign.CENTER;
		/**
		 * 
		 */
		public static const ALIGN_JUSTIFY:String 	= TextFormatAlign.JUSTIFY;
		/**
		 * 
		 */
		public static const ALIGN_LEFT:String 		= TextFormatAlign.LEFT;
		/**
		 * 
		 */
		public static const ALIGN_RIGHT:String 		= TextFormatAlign.RIGHT;
		
		/**
		 * 
		 */
		public static const AUTOSIZE_CENTER:String 	= TextFieldAutoSize.CENTER;
		/**
		 * 
		 */
		public static const AUTOSIZE_LEFT:String 	= TextFieldAutoSize.LEFT;
		/**
		 * 
		 */
		public static const AUTOSIZE_NONE:String 	= TextFieldAutoSize.NONE;
		/**
		 * 
		 */
		public static const AUTOSIZE_RIGHT:String 	= TextFieldAutoSize.RIGHT;
		
		/**
		 * 
		 */
		public static const FONT_SANS:String 		= '_sans';
		/**
		 * 
		 */
		public static const FONT_SERIF:String 		= '_serif';
		/**
		 * 
		 */
		public static const FONT_TYPEWRITER:String 	= '_typewriter';
		
		
		/**
		 * 
		 */
		public var roundingSize:Boolean = true;
		/**
		 * 
		 */
		public var roundingPosition:Boolean = true;
		
		private var _format:TextFormat;
		private var _embedded:Boolean;
		
		/**
		 * 
		 * @param	color
		 * @param	size
		 */
		public function Label(color:uint = 0x000000, size:Number = 12) {
			_format = super.getTextFormat();
			
			setSize(100, 20);
			
			autoSize = AUTOSIZE_LEFT;
			mouseWheelEnabled = false;
			selectable = false;
			
			this.size = size;
			textColor = color;
			font = FONT_SANS;
			
			multiline = false;
			wordWrap = false;
		}
		
		/**
		 * Установить шрифт и параметры
		 * @param	font
		 * @param	bold
		 * @param	italic
		 */
		public function setFont(font:String, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false):void {
			this.font = font;
			this.bold = bold;
			this.italic = italic;
			this.underline = underline;
		}
		
		/**
		 * Обрезать строку
		 * @param	label
		 * @param	text
		 * @param	ellipsis
		 */
		public function truncate(ellipsis:String = "…"):void
        {
			var _t:String = text;
			if (textWidth > width - 4 || (numLines > 1 && textHeight > height - 4)) {
				text = ellipsis;
				var elipsisW:Number = textWidth + 4;
				
				text = _t;
				while (textWidth > width - elipsisW || (numLines > 1 && textHeight > height - 4))
					text = text.substring(0, text.length - 1);
				appendText(ellipsis);
			}
        }
		
		
		/**
		 * Выравнивание текста
		 */
		public function get align():String { return _format.align; }
		/**
		 * Выравнивание текста
		 */
		public function set align(value:String):void {
			_format.align = value;
			updateFormat();
		}
		
		/**
		 * Размер текста
		 */
		public function get size():Number { return Number(_format.size); }
		/**
		 * Размер текста
		 */
		public function set size(value:Number):void {
			_format.size = value;
			updateFormat();
		}
		
		/**
		 * Шрифт текста
		 */
		public function get font():String { return _format.font; }
		/**
		 * Шрифт текста
		 */
		public function set font(value:String):void {
			_format.font = value;
			updateFormat();
			
			embedded = (value != FONT_SANS && value != FONT_SERIF && value != FONT_TYPEWRITER)
		}
		
		/**
		 * Встроенный шрифт
		 */
		public function get embedded():Boolean { return _embedded; }
		/**
		 * 
		 */
		public function set embedded(value:Boolean):void {
			_embedded = value;
			
			embedFonts = _embedded;
			antiAliasType = _embedded ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
		}
		
		
		/**
		 * Полужирный текст
		 */
		public function get bold():Boolean { return _format.bold; }
		/**
		 * 
		 */
		public function set bold(value:Boolean):void {
			_format.bold = value;
			updateFormat();
		}
		
		/**
		 * Курсивный текст
		 */
		public function get italic():Boolean { return _format.italic; }
		/**
		 * 
		 */
		public function set italic(value:Boolean):void {
			_format.italic = value;
			updateFormat();
		}
		
		/**
		 * Подчеркнутый текст
		 */
		public function get underline():Boolean { return _format.underline; }
		/**
		 * 
		 */
		public function set underline(value:Boolean):void {
			_format.underline = value;
			updateFormat();
		}
		
		/**
		 * Отступ от левого поля до первого символа в абзаце
		 */
		public function get indent():Object { return _format.indent; }
		/**
		 * 
		 */
		public function set indent(value:Object):void {
			_format.indent = value;
			updateFormat();
		}
		
		/**
		 * Левое поле абзаца 
		 */
		public function get leftMargin():Object { return _format.leftMargin; }
		/**
		 * 
		 */
		public function set leftMargin(value:Object):void {
			_format.leftMargin = value;
			updateFormat();
		}
		
		/**
		 * Правое поле абзаца 
		 */
		public function get rightMargin():Object { return _format.rightMargin; }
		/**
		 * 
		 */
		public function set rightMargin(value:Object):void {
			_format.rightMargin = value;
			updateFormat();
		}
		
		/**
		 * Междустрочный интервал
		 */
		public function get leading():Object { return _format.leading; }
		/**
		 * 
		 */
		public function set leading(value:Object):void {
			_format.leading = value;
			updateFormat();
		}
		
		/**
		 * Включен ли межбуквенный интервал
		 */
		public function get kerning():Object { return _format.kerning; }
		/**
		 * 
		 */
		public function set kerning(value:Object):void {
			_format.kerning = value;
			updateFormat();
		}
		
		/**
		 * Межбуквенный интервал
		 */
		public function get letterSpacing():Object { return _format.letterSpacing; }
		/**
		 * 
		 */
		public function set letterSpacing(value:Object):void {
			_format.letterSpacing = value;
			updateFormat();
		}
		
		
		/**
		 * Четкость глифов в процентах
		 */
		public function get sharpnessRatio():Number { return (sharpness + 400) / 800; }
		/**
		 * 
		 */
		public function set sharpnessRatio(value:Number):void { sharpness = value * 800 - 400 }
		
		/**
		 * Толщина глифов в процентах
		 */
		public function get thicknessRatio():Number { return (thickness + 200) / 400; }
		/**
		 * 
		 */
		public function set thicknessRatio(value:Number):void { thickness = value * 400 - 200 }
		
		
		/**
		 * 
		 */
		override public function get defaultTextFormat():TextFormat { return _format }
		/**
		 * 
		 */
		override public function set defaultTextFormat(format:TextFormat):void {
			_format = format;
			updateFormat();
		}
		
		/**
		 * 
		 */
		override public function getTextFormat(begin:int = -1, end:int = -1):TextFormat { return _format }
		/**
		 * 
		 */
		override public function setTextFormat(format:TextFormat, begin:int = -1, end:int = -1):void {
			_format = format;
			updateFormat(begin, end);
		}
		
		
		/**
		 * 
		 * @param	w
		 * @param	h
		 */
		public function setSize(w:Number, h:Number):void {
			super.width = roundingSize ? Math.round(w) : w;
			super.height = roundingSize ? Math.round(h) : h;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 */
		public function move(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 
		 */
		override public function get width():Number { return super.width; }
		/**
		 * 
		 */
		override public function set width(value:Number):void {
			setSize(value, height);
		}
		
		/**
		 * 
		 */
		override public function get height():Number { return super.height; }
		/**
		 * 
		 */
		override public function set height(value:Number):void {
			setSize(width, value);
		}
		
		/**
		 * 
		 */
		override public function set x(value:Number):void {
			super.x = roundingPosition ? Math.round(value) : value;
		}
		
		/**
		 * 
		 */
		override public function set y(value:Number):void {
			super.y = roundingPosition ? Math.round(value) : value;
		}
		
		
		private function updateFormat(beginIndex:int = -1, endIndex:int = -1):void {
			super.defaultTextFormat = _format;
			super.setTextFormat(_format, beginIndex, endIndex);
		}
		
	}

}