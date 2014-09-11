/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.utils
{
	import flash.events.*;
	
	/**
	 * Broadcaster <br/>
	 * статический диспатчер для глобального вещания событий
	 * 
	 * @author silin
	 */
	public class Broadcaster 
	{
		public static const ALL_EVENTS:String = "*";
		private static const _DISPATCHER : EventDispatcher = new EventDispatcher();
		private static var _permittances:Object = { };
		
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function Broadcaster() 
		{
			throw(new Error("Broadcaster is a static class and should not be instantiated."));
			
		}
		
		/**
		 * рассылает событие 
		 * @param	event		рассылаемое событие
		 * @return 				true если событие разослано
		 */
		public static function dispatchEvent(event:Event):Boolean
		{
			return _permittances[event.type] ?  _DISPATCHER.dispatchEvent(event) : false;
		}
		
		/**
		 * добавляет литенер в список глобального вещания
		 * @param	type				тип события
		 * @param	listener			метод, обрабатывающий событие
		 * @param	priority			приоритет листенера 
		 * @param	useWeakReference	использовать ли мягкие ссылки
		 */
		public static function addEventListener(type:String, listener:Function,  
								priority:int = 0, useWeakReference:Boolean = false): void
		{
			_permittances[type] = true;
			//useCapture  всегда false
			_DISPATCHER.addEventListener(type, listener, false, priority, useWeakReference);
		}
		
		/**
		 * удаляет листенер их списка глобального вещания
		 * @param	type			тип события
		 * @param	listener		удаляемый листенер
		 */
		public static function removeEventListener(type:String, listener:Function): void
		{
			_DISPATCHER.removeEventListener(type, listener, false);
			if (!hasEventListener(type))
			{
				delete _permittances[type];
			}
		}
		
		/**
		 * проверяет есть ли листенеры указанного типа
		 * @param	type		тип события
		 * @return				true, если есть листенеры, слушающие такой тип
		 */
		public static function hasEventListener(type:String): Boolean
		{
			return _DISPATCHER.hasEventListener(type);
		}
		
		/**
		 * блокирует расссылку событий указанного типа
		 * @param	type	тип события
		 */
		public static function lock(type:String=ALL_EVENTS):void
		{
			if (type == ALL_EVENTS)
			{
				for (var key:String in _permittances)
				{
					_permittances[key] = false;
				}
			}else
			{
				_permittances[type] = false;
			}
		}
		
		/**
		 * разблокирует расссылку событий указанного типа
		 * @param	type	тип события
		 */
		public static function unlock(type:String=ALL_EVENTS):void
		{
			if (type == ALL_EVENTS)
			{
				for (var key:String in _permittances)
				{
					_permittances[key] = true;
				}
			}else
			{
				_permittances[type] = true;
			}
			
		}
		//TODO: добавить удалятели
		/*
		public static function removeListenersForObject(obj:Object):void
		{
			
		}
		
		public static function removeListenersForEventType(type:String):void
		{
			
		}	
		*/
	}
	
}


