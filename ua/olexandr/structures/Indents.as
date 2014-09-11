package ua.olexandr.structures {
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class Indents {
		
		public var left:Number;
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		
		/**
		 * Constructor
		 * @param	l
		 * @param	t
		 * @param	r
		 * @param	b
		 */
		public function Indents(l:Number = 0, t:Number = 0, r:Number = 0, b:Number = 0) {
			left = l;
			top = t;
			right = r;
			bottom = b;
		}
		
		/**
		 * Проверка на равенство всех оступов
		 * @return
		 */
		public function isEquals():Boolean {
			return left == top == right == bottom;
		}
		
		public function get width():Number {
			return right - left;
		}
		
		public function get height():Number {
			return bottom - top;
		}
		
	}

}