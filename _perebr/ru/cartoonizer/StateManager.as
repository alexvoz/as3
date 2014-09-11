package ru.cartoonizer 
{
	import flash.display.Sprite;
	import ru.scarbo.data.ClassLibrary;
	import ru.scarbo.gui.collections.core.ArrayIterator;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class StateManager 
	{
		private var _states:ArrayIterator;
		
		public function StateManager(value:Array) 
		{
			this._states = new ArrayIterator(value);
		}
		
		public function prevState():Sprite {
			return this._getState(this._states.previous());
		}
		public function nextState():Sprite {
			return this._getState(this._states.next());
		}
		public function currentState():Sprite {
			return this._getState(this._states.current);
		}
		
		private function _getState(state:String):Sprite {
			return (state) ? ClassLibrary.getDisplayObject(state) as Sprite : null;
		}
	}

}