package ua.olexandr.managers {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * @author Olexandr Fedorow
	 */
	public class EventsManager {
		
		// Hash(target) -> Object(type) -> Array(dispatcher) -> Dispatcher(handler,capture)
		
		private static var _hash:Dictionary = new Dictionary(true);
		
		
		/**
		 * Добавить слушатель
		 * @param	target слушатель
		 * @param	type тип события
		 * @param	handler слушатель
		 */
		[Inline]
		public static function addListener(target:EventDispatcher, type:String, handler:Function, needEvent:Boolean = true, ...attributes):void {
			addParamListener(target, type, handler, false, false, needEvent, attributes);
		}
		
		/**
		 * Добавить слушатель с захватом
		 * @param	target слушатель
		 * @param	type тип события
		 * @param	handler слушатель
		 */
		[Inline]
		public static function addListenerWithCapture(target:EventDispatcher, type:String, handler:Function, needEvent:Boolean = true, ...attributes):void {
			addParamListener(target, type, handler, true, false, needEvent, attributes);
		}
		
		
		/**
		 * Добавить одноразовый слушатель (удаление после первого вызова)
		 * @param	target слушатель
		 * @param	type тип события
		 * @param	handler слушатель
		 */
		[Inline]
		public static function addOneTimeListener(target:EventDispatcher, type:String, handler:Function, needEvent:Boolean = true, ...attributes):void {
			addParamListener(target, type, handler, false, true, needEvent, attributes);
		}
		
		/**
		 * Добавить одноразовый слушатель (удаление после первого вызова) с захватом
		 * @param	target слушатель
		 * @param	type тип события
		 * @param	handler слушатель
		 */
		[Inline]
		public static function addOneTimeListenerWithCapture(target:EventDispatcher, type:String, handler:Function, needEvent:Boolean = true, ...attributes):void {
			addParamListener(target, type, handler, true, true, needEvent, attributes);
		}
		
		
		/**
		 * Удалить слушатель
		 * @param	target диспетчер
		 * @param	type тип события
		 * @param	handler слушатель
		 */
		[Inline]
		public static function removeListener(target:EventDispatcher, type:String, handler:Function):void {
			removeParamListener(target, type, handler, false);
		}
		
		/**
		 * Удалить слушатель с захватом
		 * @param	target диспетчер
		 * @param	type тип события
		 * @param	handler слушатель
		 */
		[Inline]
		public static function removeListenerWithCapture(target:EventDispatcher, type:String, handler:Function):void {
			removeParamListener(target, type, handler, true);
		}
		
		
		/**
		 * Удалить все слушатели с диспетчера
		 * @param	target диспетчер
		 */
		[Inline]
		public static function removeListenersFrom(target:EventDispatcher):void {
			if (!_hash[target])
				return;
			
			var _obj:Object = _hash[target];
			var _item:Dispatcher;
			
			for each (var arr:Array in _obj) {
				while (arr.length) {
					_item = arr.pop() as Dispatcher;
					_item.destroy();
					_item = null;
				}
			}
			
			delete _hash[target];
		}
		
		/**
		 * Удалить все слушатели
		 */
		[Inline]
		public static function removeListenersFromAll():void {
			for (var _obj:Object in _hash)
				removeListenersFrom(_obj as EventDispatcher);
		}
		
		
		private static function addParamListener(target:EventDispatcher, type:String, handler:Function, capture:Boolean, oneTime:Boolean, needEvent:Boolean, attributes:Array):void {
			if (!_hash[target])
				_hash[target] = { };
			if (!_hash[target][type])
				_hash[target][type] = [];
			
			var _arr:Array = _hash[target][type] as Array;
			var _len:int = _arr.length;
			var _item:Dispatcher;
			
			for (var i:int = 0; i < _len; i++) {
				_item = _arr[i] as Dispatcher;
				if (_item.isEquals(handler, capture)) {
					_item.oneOff = false;
					return;
				}
			}
			
			_item = new Dispatcher(target, type, handler, capture, needEvent, attributes);
			_item.oneOff = oneTime;
			_arr.push(_item);
		}
		
		[Inline]
		public static function removeParamListener(target:EventDispatcher, type:String, handler:Function, capture:Boolean):void {
			if (!_hash[target] || !_hash[target][type])
				return;
			
			var _arr:Array = _hash[target][type] as Array;
			var _len:int = _arr.length;
			var _item:Dispatcher;
			
			for (var i:int = 0; i < _len; i++) {
				_item = _arr[i] as Dispatcher;
				if (_item.isEquals(handler, capture)) {
					_item.destroy();
					_item = null;
					
					_arr.splice(i, 1);
					break;
				}
			}
			
			
			if (isEmpty(target, type)) {
				delete _hash[target][type];
				
				if (isEmpty(target))
					delete _hash[target];
			}
		}
		
		
		private static function isEmpty(target:EventDispatcher, type:String = null):Boolean {
			if (type) {
				
				if (!_hash[target] || !_hash[target][type])
					return true;
				return !(_hash[target][type] as Array).length;
				
			} else {
				
				var _len:uint;
				for (var _obj:Object in _hash[target])
					_len++;
					
				return !_len;
				
			}
		}
		
	}

}


import flash.events.Event;
import flash.events.EventDispatcher;
import ua.olexandr.managers.EventsManager;

/**
 * @author Olexandr Fedorow
 */
internal class Dispatcher {
	
	public var oneOff:Boolean;
	
	private var _target:EventDispatcher;
	private var _type:String;
	private var _handler:Function;
	private var _capture:Boolean;
	private var _needEvent:Boolean;
	private var _attributes:Array;
	
	public function Dispatcher(target:EventDispatcher, type:String, handler:Function, capture:Boolean, needEvent:Boolean, attributes:Array) {
		_target = target;
		_type = type;
		_handler = handler;
		_capture = capture;
		_needEvent = needEvent;
		_attributes = attributes;
		
		_target.addEventListener(_type, typeHandler, _capture);
	}
	
	public function destroy():void {
		_target.removeEventListener(_type, typeHandler, _capture);
		
		_target = null;
		_handler = null;
		_attributes = null;
	}
	
	public function isEquals(handler:Function, capture:Boolean):Boolean {
		return _handler == handler && _capture == capture;
	}
	
	
	private function typeHandler(e:Event):void {
		if (_needEvent) 	_handler.apply(null, [e].concat(_attributes));
		else 				_handler.apply(null, _attributes);
		
		if (oneOff) {
			if (_capture)	EventsManager.removeListenerWithCapture(_target, _type, _handler);
			else			EventsManager.removeListener(_target, _type, _handler);
		}
	}
	
}
