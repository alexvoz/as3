/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.utils
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * отслеживание нажатых клавиш; <br/>
	 * перед использованием обязателен вызов Key.register() 
	 * @author silin
	 */
	public class Key
	{
		private static var _keys:Array = [];
		private static var _stage:Stage;
		private static var _enabled:Boolean = true;
		
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function Key()
		{
			throw(new Error("Key is a static class and should not be instantiated."))
		}
		/**
		 * привязка к stage <br/>
		 * обязательный метод
		 * @param	stage	ссылка на stage
		 */
		public static function register(stage:Stage):void
		{
			
			_stage = stage;
			if (_enabled)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				
			}
			
			
		}
		
		private static function keyUpHandler(evnt:KeyboardEvent):void 
		{
			for (var i:int = 0; i < _keys.length; i++) 
			{
				if (_keys[i] == evnt.keyCode) _keys.splice(i, 1);
			}
		}
		
		private static function keyDownHandler(evnt:KeyboardEvent):void 
		{
			
			var key:int = evnt.keyCode;
			
			for (var i:int = 0; i < _keys.length; i++) 
			{
				if (_keys[i] == key) return;
			}
			_keys.push(key);
		}
		
		/**
		 * нажата ли клавиша с кодом key
		 * @param	key
		 * @return
		 */
		public static function isKeyDown(key:int):Boolean
		{
			
			for (var i:int = 0; i < _keys.length; i++) 
			{
				if (_keys[i] == key) return true;
			}
			return false;
		}
		/**
		 * последняя нажатая клавиша, если все отпущены, то 0
		 */
		public static function get lastPressed():int 
		{ 
			return _keys.length ? _keys[_keys.length - 1] : 0;
		}
		
		/**
		 * включает/выключает прослушивание/сохранение нажатий клавиш
		 */
		public static function get enabled():Boolean { return _enabled; }
		public static function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return;
			_enabled = value;
			_keys = [];
			if (_enabled)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}else
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
		}
		
	}
	
}