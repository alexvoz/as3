package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import ua.olexandr.ui.Style;
	
	[Event(name="change",type="flash.events.Event")]
	public class Text extends Component {
		protected var _tf:TextField;
		protected var _text:String = "";
		protected var _editable:Boolean = true;
		protected var _panel:Panel;
		protected var _selectable:Boolean = true;
		protected var _html:Boolean = false;
		protected var _format:TextFormat;
		
		public function Text(text:String = "") {
			this.text = text;
			super();
			setSize(200, 100);
		}
		
		public override function draw():void {
			super.draw();
			
			_panel.setSize(_width, _height);
			_panel.draw();
			
			_tf.width = _width - 4;
			_tf.height = _height - 4;
			if (_html) {
				_tf.htmlText = _text;
			} else {
				_tf.text = _text;
			}
			if (_editable) {
				_tf.mouseEnabled = true;
				_tf.selectable = true;
				_tf.type = TextFieldType.INPUT;
			} else {
				_tf.mouseEnabled = _selectable;
				_tf.selectable = _selectable;
				_tf.type = TextFieldType.DYNAMIC;
			}
			_tf.setTextFormat(_format);
		}
		
		public function set text(t:String):void {
			_text = t;
			if (_text == null)
				_text = "";
			invalidate();
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get textField():TextField {
			return _tf;
		}
		
		public function set editable(b:Boolean):void {
			_editable = b;
			invalidate();
		}
		
		public function get editable():Boolean {
			return _editable;
		}
		
		public function set selectable(b:Boolean):void {
			_selectable = b;
			invalidate();
		}
		
		public function get selectable():Boolean {
			return _selectable;
		}
		
		public function set html(b:Boolean):void {
			_html = b;
			invalidate();
		}
		
		public function get html():Boolean {
			return _html;
		}
		
		public override function set enabled(value:Boolean):void {
			super.enabled = value;
			_tf.tabEnabled = value;
		}
	
		
		protected override function init():void {
			super.init();
		}
		
		protected override function addChildren():void {
			_panel = new Panel();
			_panel.color = Style.TEXT_BACKGROUND;
			
			_format = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
			
			_tf = new TextField();
			_tf.x = 2;
			_tf.y = 2;
			_tf.height = _height;
			_tf.embedFonts = Style.embedFonts;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
			_tf.defaultTextFormat = _format;
			_tf.addEventListener(Event.CHANGE, onChange);
			addChild(_tf);
		}
		
		protected function onChange(event:Event):void {
			_text = _tf.text;
			dispatchEvent(event);
		}
		
	}
}