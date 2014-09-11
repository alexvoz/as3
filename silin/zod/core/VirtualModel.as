/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	
	
	import flash.geom.Vector3D;
	import silin.zod.core.*;

	
	/**
	 * 
	 * утилита для управления группой объектов как единым объектом; <br/>предполагается, что все члены группы лежат в одном контейнере
	 * 
	 * @author silin
	 */
	public class VirtualModel 
	{
		private var _list:Array = [];
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		
		
		/**
		 * conctructor
		 */
		public function VirtualModel() 
		{
			
		}
		
		/**
		 * число объектов 
		 */
		public function get length():uint {
			return _list.length;
		}
		
		/**
		 * определяет присутствует ли объект в массиве
		 * @param	obj
		 * @return	
		 */
		public function hasObject(obj:Sprite3D):Boolean
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				if (_list[i] == obj) return true;
			}
			return false;
		}
		
		/**
		 * добавляет объект
		 * @param	obj
		 */
		public function addObject(obj:Sprite3D):void
		{
			if(!hasObject(obj)) _list.push(obj);
		}
		/**
		 * удаляет объект
		 * @param	obj
		 */
		public function removeObject(obj:Sprite3D):void
		{
			for (var i:int = 0; i < length; i++) 
			{
				if (_list[i] == obj)
				{
					_list.splice(i, 1);
				}
			}
			
		}
		
		///передача 3D свойств объеткам
		public function get rotationX():Number { return _rotationX;}
		public function set rotationX (value:Number) : void
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].transform.matrix3D.appendRotation(value-_rotationX, Vector3D.X_AXIS);
			}
			_rotationX = value;
			invalidate();
		}
		
		
		public function get rotationY():Number { return _rotationY;}
		public function set rotationY (value:Number) : void
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].transform.matrix3D.appendRotation(value-_rotationY, Vector3D.Y_AXIS);
			}
			_rotationY = value;
			invalidate();
		}
		
		public function get rotationZ():Number { return _rotationZ;}
		public function set rotationZ (value:Number) : void
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].transform.matrix3D.appendRotation(value-_rotationZ, Vector3D.Z_AXIS);
			}
			_rotationZ = value;
			invalidate();
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void 
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].x += value-_x;
			}
			_x = value;
			invalidate();
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void 
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].y += value-_y;
			}
			_y = value;
			invalidate();
		}
		
		public function get z():Number { return _z; }
		public function set z(value:Number):void 
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].z += value-_z;
			}
			_z = value;
			invalidate();
		}
		
		/**
		 * массив  объектов
		 */
		public function get list():Array { return _list; }
		public function set list(value:Array):void 
		{
			_list = value;
		}
		
		
		//перетрязиваем контайнер, содержащий участников движения
		private function invalidate():void
		{
			if (length)
			{
				var container:Container3D = _list[0].parent as Container3D;
				
				if (container) 
				{
					container.invalidate();
				}
			}
			
		}
		
	}

}