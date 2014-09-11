package ua.olexandr.display.containers {
	import flash.display.DisplayObject;
	import ua.olexandr.display.ResizableObject;
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class Box extends ResizableObject {
		
		protected static var _secureKey:Boolean = false;
		
		protected var _space:Number;
		protected var _children:Array;
		
		/**
		 * 
		 * @param	space
		 * @param	vAlign
		 */
		public function Box(space:Number = 0, children:Array = null) {
			if (_secureKey) {
				_secureKey = false;
				
				_space = space;
				
				_width = 0;
				_height = 0;
				
				_children = [];
				if (children is Array) {
					var len:int = children.length;
					for (var i:int = 0; i < len; i++) 
						addChild(children[i] as DisplayObject);
				}
			} else {
				throw new Error("You can not create Box. Use HBox or VBox");
			}
		}
		
		/**
		 * 
		 */
		public function clear():void {
			while (numChildren)
				removeChildAt(0);
			
			_children = [];
			invalidate();
		}
		
		/**
		 * 
		 * @param	child
		 * @return
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			
			_children.push(child);
			invalidate();
			
			return child;
		}
		
		/**
		 * 
		 */
		public function get space():Number { return _space; }
		/**
		 * 
		 */
		public function set space(value:Number):void {
			_space = value;
			invalidate();
		}
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 */
		override public function setSize(width:Number, height:Number):void { }
		
		/**
		 * 
		 */
		override public function set width(value:Number):void { }
		/**
		 * 
		 */
		override public function set height(value:Number):void { }
		
	}

}