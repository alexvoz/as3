/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.*;

	/**
	 * обертка Sprite'а с 3D-утилитами <br/>
	 * @author silin
	 */
	public class Sprite3D extends Sprite
	{
		private const ORIGIN:Vector3D = new Vector3D();
		/**
		 * множитель расстояния до наблюдателя,<br/>
		 * тестовая фича: нужно как-то разруливать сортировку для не однозначных моментов<br/>
		 */
		public var sortingPriority:Number = 1;
		//реперные точки для детекции изнанки 
		private static const P0:Point = new Point(0, 0);
		private static const P1:Point = new Point(100, 0);
		private static const P2:Point = new Point(0, 100);
		
		//приват коэффициента степени затемнения
		protected var _tintDepth:Number = 0.5;
		//приват режима изнанки
		protected var _inside:Boolean = false;
		//фильтр для затемнения
		private var _tintFilter:ColorMatrixFilter = new ColorMatrixFilter();
		
		
		
		/////////////////////////////
		/////////////////////////////
		/////////////////////////////
		//скорость автовращения по X
		private var _vX:Number = 0;
		
		//скорость автовращения по Y
		private var _vY:Number = 0;
		
		public var sortVal:Number;
		
		/**
		 * коэффициент затухания  при автовращении
		 */
		
		public var dampRotationX:Number = 0.975;
		public var dampRotationY:Number = 0.975;
		
		
		/**
		 * скорость, ниже которой не опускаемся при замедлении врщения</br> 
		 * чтобы сработало, должна быть больше rotationSpeedTolerance (0.1)
		 */
		public var minRotationSpeed:Number = 0;
		/**
		 * ограничение скорости вращения; (0 - нет ограничения)
		 */
		public var maxRotationSpeed:Number = 0;

		/**
		 * скорось полной остановки вращения
		 */
		private var rotationSpeedTolerance:Number = 0.05;
		/**
		 * флаг вращения вокруг собственной оси
		 */
		public var localRotationX:Boolean = false;
		/**
		 * флаг вращения вокруг собственной оси
		 */
		public var localRotationY:Boolean = false;

		//приват флага собственного ENTER_FRAME с autoRotate
		private var _autoRotation:Boolean = false;

		//ограничения на наклон относительно X родителя
		private var _maxSlopeX:Number;
		private var _minSlopeX:Number;
		private var _slopeXLimited:Boolean = false;
		
		//модель-саттелит
		private var _slaveObject:Sprite3D;
		
		
		public var id:int = -1;
		
		/**
		 * constructor
		 */
		public function Sprite3D()
		{
			z = 0;//инициализация transform.matrix3D
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
		}
		private function onStage(event:Event):void
		{
			if (_autoRotation) addEventListener(Event.ENTER_FRAME, autoRotate);
			if (root.transform.getRelativeMatrix3D(root) == null) root.z = 0;
		}
		
		private function onRemove(evnt:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, autoRotate);
		}
		
		
		/**
		 *  видимость, подсвечивание
		 */
		public function invalidate():void
		{
			if (!root) return;
			
			
			//видимость по расположению реперных точек в глобале
			
			var p0:Point = localToGlobal(P0);
			var p1:Point = localToGlobal(P1);
			var p2:Point = localToGlobal(P2);

			if (_inside)
			{
				visible = (p1.x - p0.x) * (p2.y - p1.y) - (p1.y - p0.y) * (p2.x - p1.x) < 0;
			}else
			{
				visible =  (p1.x - p0.x) * (p2.y - p1.y) - (p1.y - p0.y) * (p2.x - p1.x) > 0
			}
			
			
			//trace(this.name + "  visible : " + visible );
			/*//тоже самое, но  затратнее( не проверено)
			var v1:Vector3D = new Vector3D ( p1.x - p0.x, p1.y - p0.y );
			var v2:Vector3D = new Vector3D ( p2.x - p0.x, p2.y - p0.y );

			var normal:Vector3D = v1.crossProduct(v2);
			
			visible = _inside ? normal.z < 0 : normal.z > 0;*/
			
			
			//подсветка по повороту к плоскости проекции
			if (visible && _tintDepth)
			{
				var relMtrx:Matrix3D = transform.getRelativeMatrix3D(root);
				var p:Vector3D = relMtrx.deltaTransformVector(new Vector3D(0, 0, 1));
				
				var k0:Number = 1.05;//небольшой заезд в осветление
				var k:Number = k0 - _tintDepth * (1 + (_inside ? p.z : -p.z));
				
				_tintFilter.matrix =  [k, 0, 0, 0, 0, 0, k, 0, 0, 0, 0, 0, k, 0, 0, 0, 0, 0, 1, 0 ];
				filters = [_tintFilter];

			}else
			{
				filters = [];
			}
			
		}

		///перегружаем 3Д-шные свойства(для коррекции состояния при твинах и пр.)
		override public function get rotationX():Number { return super.rotationX;}
		override public function set rotationX (value:Number) : void
		{
			super.rotationX = value;
			invalidate();
			checkBinding();
		}
		override public function get rotationY():Number { return super.rotationY;}
		override public function set rotationY (value:Number) : void
		{
			super.rotationY = value;
			invalidate();
			checkBinding();
		}
		override public function get rotationZ():Number { return super.rotationZ;}
		override public function set rotationZ (value:Number) : void
		{
			super.rotationZ = value;
			invalidate();
			checkBinding();
		}

		override public function get x():Number { return super.x;}
		override public function set x (value:Number) : void
		{
			super.x = value;
			invalidate();
			checkBinding();
		}
		override public function get y():Number { return super.y;}
		override public function set y (value:Number) : void
		{
			super.y = value;
			invalidate();
			checkBinding();
		}
		override public function get z():Number { return super.z;}
		override public function set z (value:Number) : void
		{
			super.z = value;
			invalidate();
			checkBinding();
		}
		/**
		 * коэффициент степени затемнения, 0..1 (отрицательные тоже работают, но инверсно в осветление)
		 */
		public function get tintDepth():Number { return _tintDepth; }
		public function set tintDepth(value:Number):void
		{
			if (_tintDepth != value)
			{
				_tintDepth = value;
				invalidate();
			}
		}

		/**
		 *  rotation по X,Y,Z
		 */
		public function get orientation():Vector3D { return new Vector3D(rotationX, rotationY, rotationZ); }
		public function set orientation(value:Vector3D):void
		{
			rotationX = value.x;
			rotationY = value.y;
			rotationZ = value.z;
		}
		/**
		 * координаты в родителе
		 */
		public function get position():Vector3D { return transform.matrix3D.position; }
		public function set position(value:Vector3D):void { transform.matrix3D.position = value; }
		
		/**
		 * расстояние до наблюдателя в руте
		 */
		public function get viewDistance():Number 
		{ 
			if (!stage) return Number.MAX_VALUE;
			
			
			//точка наблюдателя в руте
			var projection:PerspectiveProjection = root.transform.perspectiveProjection;
			var viewPoint:Vector3D = new Vector3D(projection.projectionCenter.x, projection.projectionCenter.y, -projection.focalLength);

			//расстояния до наблюдателя
			//var gP:Vector3D = Utils3D.projectVector(transform.getRelativeMatrix3D(root), ORIGIN);
			//var distance:Number = Vector3D.distance(viewPoint, gP);
			
			var mtrx:Matrix3D = root.transform.getRelativeMatrix3D(this);
			mtrx.invert();
			
			//sortingPriority - костыль для одного мутного случая (в кубике рубика), а вообще 1
			return sortingPriority * Vector3D.distance(viewPoint, mtrx.position);
			
		}

		/**
		 * координаты в руте
		 */
		public function get globalPosition():Vector3D 
		{ 
			
			if (!stage) return null;
			var mtrx:Matrix3D = root.transform.getRelativeMatrix3D(this);
			mtrx.invert();
			return mtrx.position;
			
		}

		/**
		 * флаг изнанки (тип видимости)
		 */
		public function get inside():Boolean { return _inside; }
		public function set inside(value:Boolean):void 
		{
			if (_inside != value)
			{
				_inside = value;
				invalidate();
			}
			
		}
		
		
		///////////////////////////////////////////////////
		/**
		 * вращет вокруг X и Y родителя (или собственных, если выcтавлены localRotationX | localRotationY
		 * @param	angleX
		 * @param	angleY
		 */
		public function rotateXY(angleX:Number, angleY:Number=0):void
		{

			if (angleX || angleY)
			{
				var mtrx:Matrix3D = transform.matrix3D ;
				var pos:Vector3D = mtrx.position;
				if (_slopeXLimited)
				{
					var p:Vector3D = mtrx.deltaTransformVector(new Vector3D(0, 1, 0));
					var angle:Number = 180 / Math.PI * Math.asin(p.z);
					if (angle + angleX > _maxSlopeX) angleX = _maxSlopeX - angle;
					if (angle + angleX < _minSlopeX) angleX = _minSlopeX - angle;
				}
				//двигаем в начало координат
				mtrx.appendTranslation( -pos.x, -pos.y, -pos.z);
				//вращаем
				localRotationX ? mtrx.prependRotation(angleX, Vector3D.X_AXIS) : mtrx.appendRotation(angleX, Vector3D.X_AXIS)
				localRotationY ? mtrx.prependRotation(angleY, Vector3D.Y_AXIS) : mtrx.appendRotation(angleY, Vector3D.Y_AXIS)
				//двигаем назад
				mtrx.appendTranslation( pos.x, pos.y, pos.z);
				//коррекция
				invalidate();
				checkBinding();
			}
		}

		/**
		 * обнуляет скорости вращения
		 */
		public function stopAutoRotation():void
		{
			vX = 0;
			vY = 0;
		}

		/**
		 * вращает на шаг скоростей по осям,
		 * душит скорости в соотвтествии с dampRotaionX|dampRotaionY
		 */
		private function autoRotate(event:Event=null):void
		{
			if (vX || vY)
			{
				rotateXY(vX, vY);

				vX *= dampRotationX;
				vY *= dampRotationY;
				if (minRotationSpeed > rotationSpeedTolerance)
				{
					if (Math.abs(vX)<minRotationSpeed)vX=vX>0 ? minRotationSpeed:-minRotationSpeed;
					if (Math.abs(vY)<minRotationSpeed)vY=vY>0 ? minRotationSpeed:-minRotationSpeed;
					
				}else
				{
					if (Math.abs(vX) < 0.1) vX = 0;
					if (Math.abs(vY) < 0.1) vY = 0;
				}
				
			}
			
		}

		/**
		 * устанавливает ограничения на наклон относительно X родителя <br/>
		 * если оба предела 0 или отсутствуют, то снимает ограничение <br/>
		 * миеет смысл только для режима localRotationY=true
		 * @param	min		минимавльный угол, градусы
		 * @param	max		максимальный угол, градусы
		 */
		public function setSlopeXLimits(min:Number=0, max:Number=0):void
		{
			_slopeXLimited = min || max;
			if (_slopeXLimited)
			{
				_minSlopeX = min;
				_maxSlopeX = max;
			}
		}
		

		/**
		 * флаг автовращения на ENTER_FRAME (добавляет/убирает листенер)
		 */
		public function get autoRotation():Boolean { return _autoRotation; }

		public function set autoRotation(value:Boolean):void
		{
			if (_autoRotation != value)
			{
				_autoRotation = value;
				if (stage)
				{
					_autoRotation ? addEventListener(Event.ENTER_FRAME, autoRotate):removeEventListener(Event.ENTER_FRAME, autoRotate);
				}
			}
			transform.matrix3D
		}
		
		/**
		 * связывает две модели, так что их свойства(transform.matrix3D) дублируются на сателита<br/>
		 * 'хлипкая' фича, в стадии эксперимента пока<br/>
		 */
		public static function bindObjects(obj1:Sprite3D, obj2:Sprite3D):void
		{
			obj1._slaveObject = obj2;
			obj2._slaveObject = obj1;
		}
		/**
		 * убирает ссылку на сателита
		 */
		public function clearBinding():void
		{
			if (_slaveObject)
			{
				_slaveObject = null;
			}
			
		}
		
		
		
		
		//установка коэффицента затузания сразу по обоим осям
		public function set dampRotation(value:Number):void 
		{
			dampRotationX = value;
			dampRotationY = value;
		}
		
		/**
		 * скорость автовращения вокруг оси  X
		 */
		public function get vX():Number { return _vX; }
		public function set vX(value:Number):void 
		{
			if (value == _vX) return;
			if (maxRotationSpeed != 0)
			{
				if (value < -maxRotationSpeed) value = -maxRotationSpeed;
				if (value > maxRotationSpeed) value = maxRotationSpeed;
			}
			
			_vX = value;
			
		}
		/**
		 * скорость автовращения вокруг оси Y
		 */
		public function get vY():Number { return _vY; }
		public function set vY(value:Number):void 
		{
			if (value == _vY) return;
			if (maxRotationSpeed != 0)
			{
				if (value < -maxRotationSpeed) value = -maxRotationSpeed;
				if (value > maxRotationSpeed) value = maxRotationSpeed;
			}
			
			_vY = value;
		}
		
		private function checkBinding():void
		{
			if (_slaveObject)
			{
				_slaveObject.transform.matrix3D = transform.matrix3D.clone();
				_slaveObject.invalidate();
			}
		}
		
		
		
	}

}
