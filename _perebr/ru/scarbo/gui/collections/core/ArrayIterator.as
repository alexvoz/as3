package ru.scarbo.gui.collections.core 
{
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ArrayIterator implements IListIterator 
	{
		protected var _array:Array;
		protected var _length:int;
		protected var _next:int;
		protected var _current:int = -1;
		
		public function ArrayIterator(array:Array, index:uint = 0) 
		{
			this._array = array;
			this._length = (this._array.length) ? this._array.length : -1;
			this._next = (index >= this._length) ? -1 : index;
		}
		
		public function get array():Array { return this._array; }
		
		public function get previousIndex():int 
		{
			return (this._next == -1) ? this._length - 1 : this._next - 1;
		}
		public function get index():int 
		{
			return this._current;
		}
		public function get nextIndex():int 
		{
			return this._next;
		}
		
		public function hasPrevious():Boolean 
		{
			return this._next && this._length > -1;
		}
		public function hasNext():Boolean 
		{
			return this._next > -1;
		}
		
		public function previous():* 
		{
			if (this._next == 0 || this._length == -1) {
				this._current = -1;
				return undefined;
			}
			this._next = (this._next == -1) ? this._length - 1 : this._next - 1;
			this._current = this._next;
			return this._array[this._current];
		}
		public function get current():* 
		{
			return this._array[this._current];
		}
		public function next():* 
		{
			if (this._next == -1) {
				this._current = -1;
				return undefined;
			}
			this._current = this._next;
			this._next = (this._next >= this._length - 1) ? -1 : this._next + 1;
			return this._array[this._current];
		}
		
		public function start():void 
		{
			this._next = (this._length != -1) ? 0 : -1;
			this._current = -1;
		}
		public function end():void 
		{
			this._next = this._current = -1;
		}
		public function remove():Boolean 
		{
			if (this._current == -1) return false;
			if (this._current == this._next) {
				if (this._next >= this._length - 1) this._next = -1;
			} else {
				if (this._next > 0) this._next--;
			}
			this.removeCurrent();
			this._current = -1;
			return true;
		}
		
		protected function removeCurrent():void {
			this._array.splice(this._current, 1)[0];
		}
		
	}

}