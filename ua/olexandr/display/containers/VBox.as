package ua.olexandr.display.containers {
	import flash.display.DisplayObject;
	import ua.olexandr.tools.display.Arranger;
	import ua.olexandr.tools.display.HAligner;
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class VBox extends Box {
		
		protected var _hAlign:String;
		
		/**
		 * 
		 * @param	space
		 * @param	hAlign
		 */
		public function VBox(space:Number = 0, hAlign:String = 'C', children:Array = null) {
			_hAlign = hAlign;
			
			_secureKey = true;
			super(space, children);
		}
		
		/**
		 * 
		 */
		public function get hAlign():String { return _hAlign; }
		/**
		 * 
		 */
		public function set hAlign(value:String):void {
			_hAlign = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		override protected function measure():void {
			_height = Arranger.calcHeight(_children, _space);
			
			_width = 0;
			for (var i:int = 0, _len:int = _children.length; i < _len; i++)
				_width = Math.max(_width, (_children[i] as DisplayObject).width);
		}
		
		/**
		 * 
		 */
		override protected function draw():void {
			Arranger.arrangeByV(_children, _space);
			
			var _child:DisplayObject;
			switch(_hAlign) {
				case HAligner.L: {
					for each (_child in _children)
						_child.x = 0;
					break;
				}
				case HAligner.R: {
					for each (_child in _children)
						_child.x = _width - _child.width;
					break;
				}
				default: {
					for each (_child in _children)
						_child.x = (_width - _child.width) / 2;
				}
			}
		}
		
	}

}