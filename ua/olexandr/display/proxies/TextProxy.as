package ua.olexandr.display.proxies {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ua.olexandr.events.FrameEvent;
	import ua.olexandr.text.Label;
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	[Event(name="complete", type="ua.olexandr.events.FrameEvent")]
	[Event(name="change", type="ua.olexandr.events.FrameEvent")]
	public class TextProxy extends DisplayProxy {
		
		/**
		 * Contructor
		 * @param	target
		 * @param	frame
		 */
		public function TextProxy(target:TextField) {
			super(target);
			
			//textField.mouseWheelEnabled = false;
			//textField.selectable = false;
			
			//this.size = size;
			//textField.textColor = color;
			//textField.font = FONT_SANS;
			
			//textField.multiline = false;
			//textField.wordWrap = false;
		}
		
		/**
		 * Установить шрифт и параметры
		 * @param	font
		 * @param	bold
		 * @param	italic
		 */
		public function setFont(font:String, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false):void {
			font = font;
			bold = bold;
			italic = italic;
			underline = underline;
		}
		
		
		/**
		 * Выравнивание текста
		 */
		public function get align():String { return textField.getTextFormat().align; }
		/**
		 * Выравнивание текста
		 */
		public function set align(value:String):void {
			var _format:TextFormat = textField.getTextFormat();
			_format.align = value;
			textField.setTextFormat(_format);
		}
		
		/**
		 * Шрифт текста
		 */
		public function get font():String { return textField.getTextFormat().font; }
		/**
		 * Шрифт текста
		 */
		public function set font(value:String):void {
			var _format:TextFormat = textField.getTextFormat();
			_format.font = value;
			textField.setTextFormat(_format);
			
			embedded = (value != Label.FONT_SANS && value != Label.FONT_SERIF && value != Label.FONT_TYPEWRITER)
		}
		
		/**
		 * Встроенный шрифт
		 */
		public function get embedded():Boolean { return textField.embedFonts; }
		/**
		 * Встроенный шрифт
		 */
		public function set embedded(value:Boolean):void {
			textField.embedFonts = value;
			textField.antiAliasType = value ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
		}
		
		/**
		 * Подчеркнутый текст
		 */
		public function get underline():Boolean { return Boolean(textField.getTextFormat().underline); }
		/**
		 * Подчеркнутый текст
		 */
		public function set underline(value:Boolean):void {
			var _format:TextFormat = textField.getTextFormat();
			_format.underline = value;
			textField.setTextFormat(_format);
		}
		
		/**
		 * Полужирный текст
		 */
		public function get bold():Boolean { return Boolean(textField.getTextFormat().bold); }
		/**
		 * Полужирный текст
		 */
		public function set bold(value:Boolean):void {
			var _format:TextFormat = textField.getTextFormat();
			_format.bold = value;
			textField.setTextFormat(_format);
		}
		
		/**
		 * Курсивный текст
		 */
		public function get italic():Boolean { return Boolean(textField.getTextFormat().italic); }
		/**
		 * Курсивный текст
		 */
		public function set italic(value:Boolean):void {
			var _format:TextFormat = textField.getTextFormat();
			_format.italic = value;
			textField.setTextFormat(_format);
		}
		
		/**
		 * Размер текста
		 */
		public function get size():Number { return Number(textField.getTextFormat().size); }
		/**
		 * Размер текста
		 */
		public function set size(value:Number):void {
			var _format:TextFormat = textField.getTextFormat();
			_format.size = value;
			textField.setTextFormat(_format);
		}
		
	}

}