package ua.olexandr.display.containers {
	import flash.display.DisplayObject;
	import ua.olexandr.tools.display.Arranger;
	import ua.olexandr.tools.display.VAligner;
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.2
	 */
	public class HBox extends Box {
		
		private var _vAlign:String;
		
		/**
		 * 
		 * @param	space
		 * @param	vAlign
		 */
		public function HBox(space:Number = 0, vAlign:String = 'C', children:Array = null) {
			_vAlign = vAlign;
			
			_secureKey = true;
			super(space, children);
		}
		
		/**
		 * 
		 */
		public function get vAlign():String { return _vAlign; }
		/**
		 * 
		 */
		public function set vAlign(value:String):void {
			_vAlign = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		override protected function measure():void {
			_width = Arranger.calcWidth(_children, _space);
			
			_height = 0;
			for (var i:int = 0, _len:int = _children.length; i < _len; i++)
				_height = Math.max(_height, (_children[i] as DisplayObject).height);
		}
		
		/**
		 * 
		 */
		override protected function draw():void {
			Arranger.arrangeByH(_children, _space);
			
			var _child:DisplayObject;
			switch(_vAlign) {
				case VAligner.T: {
					for each (_child in _children)
						_child.y = 0;
					break;
				}
				case VAligner.B: {
					for each (_child in _children)
						_child.y = _height - _child.height;
					break;
				}
				default: {
					for each (_child in _children)
						_child.y = (_height - _child.height) / 2;
				}
			}
		}
		
	}

}