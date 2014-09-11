package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ua.olexandr.ui.Style;
	
	[Event(name="resize",type="flash.events.Event")]
	public class Label extends Component {
		protected var _autoSize:Boolean = true;
		protected var _text:String = "";
		protected var _tf:TextField;
		private var _size:Object;
		
		public function Label(text:String = "", size:Object = null) {
			this.text = text;
			_size = size;
			super();
		}
		
		public override function draw():void {
			super.draw();
			_tf.text = _text;
			if (_autoSize) {
				_tf.autoSize = TextFieldAutoSize.LEFT;
				_width = _tf.width;
				_height = _tf.height = 18;
				dispatchEvent(new Event(Event.RESIZE));
			} else {
				_tf.autoSize = TextFieldAutoSize.NONE;
				_tf.width = _width;
				_tf.height = _height;
			}
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
		
		public function set autoSize(b:Boolean):void {
			_autoSize = b;
		}
		
		public function get autoSize():Boolean {
			return _autoSize;
		}
		
		public function get textField():TextField {
			return _tf;
		}
		
		
		protected override function init():void {
			super.init();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		protected override function addChildren():void {
			_height = 18;
			_tf = new TextField();
			_tf.height = _height;
			_tf.embedFonts = Style.embedFonts;
			_tf.antiAliasType = Style.fontAntiAlias;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = new TextFormat(Style.fontName, _size || Style.fontSize, Style.LABEL_TEXT);
			_tf.text = _text;
			addChild(_tf);
			draw();
		}
		
	}
}