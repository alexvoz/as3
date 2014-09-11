/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.utils 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.*;
	import silin.zod.core.*;

	
	/**
	 * управление стандартным поведение моделек через статический класс<br/>
	 * 
	 * @author silin
	 */
	public class BehaviourManager
	{
		/**
		 * шаг перемещения по стрелкам клавиатуры
		 */
		public static var MOVE_STEP:Number = 5;
		
		private static var _stage:Stage;
		private static var _rotationByDragList:Vector.<Sprite3D> = new Vector.<Sprite3D>();
		private static var _rotationByMoveList:Vector.<Sprite3D> = new Vector.<Sprite3D>();
		private static var _rotationByMoveCoefList:Vector.<Number> = new Vector.<Number>();
		
		private static var _keyList:Vector.<Sprite3D> = new Vector.<Sprite3D>();
		private static var _prevX:Number;
		private static var _prevY:Number;
		private static var _currTarget:Sprite3D;
		private static var _keys:Array = [];
		private static const _dispatcher : EventDispatcher = new EventDispatcher();
		
		private static var _registered:Boolean = false;
		
		
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function BehaviourManager():void 
		{
			trace ("BehaviourManager is a static class and should not be instantiated. ");
		}
		
		
		/**
		 * ссылка на stage; добавление листенеров stage
		 * @param	stage
		 */
		public static function register(stage:Stage):void
		{
			if (_registered) return;
			_registered = true;
			_stage = stage;
			
			_stage.addEventListener(Event.ENTER_FRAME, enterFrameActions);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		//отпускание клавиши
		private static function keyUpHandler(evnt:KeyboardEvent):void 
		{
			for (var i:int = 0; i < _keys.length; i++) 
			{
				if (_keys[i] == evnt.keyCode) _keys.splice(i, 1);
			}
		}
		//нажатие клавиши
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
		 * нажата ли клавиша key
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
		 * код последней нажатой клавиши
		 */
		public static function get lastPressed():int 
		{ 
			return _keys.length ? _keys[_keys.length - 1] : 0;
		}
		/**
		 * добавляет объект к списку вращаемых при драге мыши
		 * @param	model
		 */
		public static function addDragRotaiveObject(model:Sprite3D):void
		{
			cleanUp();
			for (var i:int = 0; i < _rotationByDragList.length; i++) if (model == _rotationByDragList[i]) return;
			_rotationByDragList.push(model);
			model.autoRotation = true;
			
		}
		/**
		 * добавляет вращаемый  по перемещенеию мыши объект
		 * @param	model
		 */
		public static function addMoveRotativeObject(model:Sprite3D, coef:Number=0.05):void
		{
			cleanUp();
			for (var i:int = 0; i < _rotationByMoveList.length; i++) if (model == _rotationByMoveList[i]) return;
			_rotationByMoveList.push(model);
			_rotationByMoveCoefList.push(coef);
			model.autoRotation = true;
		}
		/**
		 * добавлянт объект к списку двигаемых по клавшам стрелок
		 * @param	model
		 */
		public static function addKeyMovingObject(obj:Sprite3D):void
		{
			cleanUp();
			for (var i:int = 0; i < _keyList.length; i++) if (obj == _keyList[i]) return;
			_keyList.push(obj);
			
		}
		/**
		 * очищает все списки
		 */
		public static function removeAll():void
		{
			_keyList = new Vector.<Sprite3D>();
			_rotationByDragList = new Vector.<Sprite3D>();
			_rotationByMoveList = new Vector.<Sprite3D>();
			_rotationByMoveCoefList = new Vector.<Number>();
			
		}
		
		private static function cleanUp():void
		{
			var i:int;
			for (i = 0; i < _rotationByDragList.length; i++)if (!_rotationByDragList[i]) _rotationByDragList.splice(i, 1);
			
			for (i = 0; i < _rotationByMoveCoefList.length; i++)if (!_rotationByMoveCoefList[i])
			{
				 _rotationByMoveCoefList.splice(i, 1);
				 _rotationByMoveCoefList.splice(i, 1);
			}
			for (i = 0; i < _keyList.length; i++) if (!_keyList[i]) _keyList.splice(i, 1);
			
			
		}
		//глобальный MouseUp
		private static function onMouseUp(evnt:MouseEvent):void
		{
			_currTarget = null;
		}
		//глобальный MouseDown
		private static function onMouseDown(evnt:MouseEvent):void
		{
			var model:Sprite3D;
			var i:int;
			_prevX = _stage.mouseX;
			_prevY = _stage.mouseY;
			
			var obj:DisplayObject = DisplayObject(evnt.target);
			//trace( "obj : " + obj );
			//сам объект в списке
			if (obj is Sprite3D)
			{
				model = obj as Sprite3D;
				//если модель в списке, то считаем ее текущей
				for (i = 0; i < _rotationByDragList.length; i++) 
				{
					if (model == _rotationByDragList[i])
					{
						_currTarget =  model;
						return;
					}
				}
			}
			
			//кто-то из родителей в списке
			while (obj.parent && !(obj.parent is Stage) ) 
			{
				
				obj = obj.parent;
				if (obj is Sprite3D)
				{
					model = obj as Sprite3D;
					//если модель в списке, то считаем ее текущей
					for (i = 0; i < _rotationByDragList.length; i++) 
					{
						if (model == _rotationByDragList[i])
						{
							_currTarget =  model;
							return;
						}
					}	
				}
			}
		}
		
		//enterFrame renderer
		private static function enterFrameActions(evnt:Event):void
		{
			var i:int;
			if (_currTarget)
			{
				_currTarget.vX = (_stage.mouseY - _prevY);
				_currTarget.vY = -(_stage.mouseX - _prevX);
				_prevX = _stage.mouseX;
				_prevY = _stage.mouseY;
				
			}
			//обработка объектов, вращаемых по положению мышки без драга
			for (i = 0; i < _rotationByMoveList.length; i++) 
			{
				var model:Sprite3D = _rotationByMoveList[i];
				var sP:Point = model.localToGlobal(new Point());
				var dX:Number = sP.x - _stage.mouseX;
				var dY:Number = sP.y - _stage.mouseY;
				model.vY = dX * _rotationByMoveCoefList[i];
				model.vX = dY * _rotationByMoveCoefList[i];
				
				
				//model.vX=
			}
			
			if (_keyList.length)
			{
				if (isKeyDown(Keyboard.UP))
				{
					for (i = 0; i < _keyList.length; i++) _keyList[i].z -= MOVE_STEP;
					
				}
				if (isKeyDown(Keyboard.DOWN))
				{
					for (i = 0; i < _keyList.length; i++) _keyList[i].z += MOVE_STEP;
					
				}

				if (isKeyDown(Keyboard.LEFT))
				{
					for (i = 0; i < _keyList.length; i++) _keyList[i].x -= MOVE_STEP;
					
				}

				if (isKeyDown(Keyboard.RIGHT))
				{
					for (i = 0; i < _keyList.length; i++) _keyList[i].x += MOVE_STEP;
					
				}
			}
		}
		
		
	}

}