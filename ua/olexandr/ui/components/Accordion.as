package ua.olexandr.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class Accordion extends Component {
		protected var _windows:Array;
		protected var _winWidth:Number = 100;
		protected var _winHeight:Number = 100;
		protected var _vbox:VBox;
		
		public function Accordion() {
			super();
		}
		
		public function addWindow(title:String):void {
			addWindowAt(title, _windows.length);
		}
		
		public function addWindowAt(title:String, index:int):void {
			index = Math.min(index, _windows.length);
			index = Math.max(index, 0);
			var window:Window = new Window(null, 0, 0, title);
			_vbox.addChildAt(window, index);
			window.minimized = true;
			window.draggable = false;
			window.grips.visible = false;
			window.addEventListener(Event.SELECT, onWindowSelect);
			_windows.splice(index, 0, window);
			_winHeight = _height - (_windows.length - 1) * 20;
			setSize(_winWidth, _winHeight);
		}
		
		public function getWindowAt(index:int):Window {
			return _windows[index];
		}
		
		public override function setSize(w:Number, h:Number):void {
			super.setSize(w, h);
			_winWidth = w;
			_winHeight = h - (_windows.length - 1) * 20;
			draw();
		}
		
		public override function draw():void {
			_winHeight = Math.max(_winHeight, 40);
			for (var i:int = 0; i < _windows.length; i++) {
				_windows[i].setSize(_winWidth, _winHeight);
				_vbox.draw();
			}
		}
		
		public override function set width(w:Number):void {
			_winWidth = w;
			super.width = w;
		}
		
		public override function set height(h:Number):void {
			_winHeight = h - (_windows.length - 1) * 20;
			super.height = h;
		}
	
		
		protected override function init():void {
			super.init();
			setSize(100, 120);
		}
		
		protected override function addChildren():void {
			_vbox = new VBox(this);
			_vbox.spacing = 0;
			
			_windows = new Array();
			for (var i:int = 0; i < 2; i++) {
				var window:Window = new Window(_vbox, 0, 0, "Section " + (i + 1));
				window.grips.visible = false;
				window.draggable = false;
				window.addEventListener(Event.SELECT, onWindowSelect);
				if (i != 0)
					window.minimized = true;
				_windows.push(window);
			}
		}
		
		protected function onWindowSelect(event:Event):void {
			var window:Window = event.target as Window;
			if (window.minimized) {
				for (var i:int = 0; i < _windows.length; i++) {
					_windows[i].minimized = true;
				}
				window.minimized = false;
			}
			_vbox.draw();
		}
		
	}
}