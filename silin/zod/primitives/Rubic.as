/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.primitives
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;
	import silin.zod.primitives.*;
	import silin.zod.utils.*;

	/**
	 * кубик Рубика <br/>
	 * DrawableMaterial трактуется как карта граней всего куба (front-right-back-left-floor-ceil)
	 * @author silin
	 */
	public class Rubic extends PolyhedronModel
	{

		//цвет внутренних граней
		public static var _innerColor:uint = 0x404040;
		//цвет сетки, если отрицательный, то не рисуем
		private var _gridColor:uint = 0x404040;
		//рисовать ли сетку
		private var _drawGrid:Boolean = true;

		public static var X:String = "x";
		public static var Y:String = "y";
		public static var Z:String = "z";

		//величина сдвига размеров и координат кубиков (нужна для фильтрования граней, входящих в слой, по координате)
		private const _shift:Number = 1;

		private var _size:Number;
		//массив для хранения исходного состояния
		private var _initState:Array/*InitData*/ = [];
		//виртуальная модель для слоя
		private var _layer:VirtualModel = new VirtualModel();
		//ось текущего слоя
		public var layerAxis:String = X;
		public var layerLevel:int;

		/**
		 * constructor
		 * @param	material	материал (DrawableMaterial, ColorMaterial, TextureMaterial)
		 * @param	size		размер грани всего куба
		 */
		public function Rubic(material:Material, size:Number, innreColor:uint=0x404040, gridColor:uint=0x404040, drawGrid:Boolean=true)
		{
			super(material);

			autoSorting = true;
			_size = size;
			_gridColor = gridColor;
			_innerColor = innreColor;
			_drawGrid = drawGrid;

			createFaces();
			update();

		}

		private function createFaces():void
		{
			var i:int;
			var j:int;
			var iX:int;
			var iY:int;
			var face:Face;

			var dir:Vector3D;
			var pos:Vector3D;

			var innerFacePriority:Number = 1.05;//корректор viewDistance, костыль для сотрировки
			var realSize:Number = _size-_shift;//реальные размеры меньше, чем 'официальные'
			var s:Number = realSize / 6;//полуразмер квадратиков

			var uvData:Vector.<Number>;
			var vertices:Vector.<Number> = Vector.<Number>([ -s, -s, -s, s, s, s, s, -s]);
			var indices:Vector.<int> = Vector.<int>([0, 1, 2, 0, 2, 3]);

			//Лицевые грани
			for (i = 0; i < 6; i++)
			{

				for (j = 0; j < 9; j++)
				{
					iX = j % 3;
					iY = Math.floor(j / 3);

					var u0:Number = (i + iX / 3) / 6 ;
					var u1:Number = (i + (iX + 1) / 3) / 6 ;

					var v0:Number = iY/3;
					var v1:Number = (iY + 1) / 3;
					uvData = Vector.<Number>([u0, v0, u0, v1, u1, v1, u1, v0]);
					face = new Face(material, vertices, indices, uvData);

					face.x = (iX-1) * realSize/3;
					face.y = (iY-1) * realSize/3;

					//параметры грани базового куба
					dir = Cube.FACES_ORIENTATION[i].clone();
					dir.negate();//ориентация элемента противоположна ориентации кубика
					pos = Cube.FACES_POSITION[i].clone();
					pos.scaleBy(realSize / 2);

					face.transform.matrix3D.appendRotation(dir.x, Vector3D.X_AXIS);
					face.transform.matrix3D.appendRotation(dir.y, Vector3D.Y_AXIS);
					face.transform.matrix3D.appendRotation(dir.z, Vector3D.Z_AXIS);
					face.transform.matrix3D.appendTranslation(pos.x, pos.y, pos.z);

					//frame
					if (_drawGrid)
					{
						var frame:Shape = new Shape();
						frame.graphics.lineStyle(1, _gridColor);
						frame.graphics.drawRect( -s, -s, 2 * s, 2 * s);
						face.addChild(frame);
					}

					addFace(face);
					//face.id = _faces.length;
					_initState.push( new FaceState(face) );
				}
			}

			//внутренние грани
			uvData = Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]);
			var clrMaterial:ColorMaterial = new ColorMaterial(_innerColor);
			for (i = 0; i < 6; i++)
			{
				for (j = 0; j < 9; j++)
				{
					iX = j % 3 - 1;
					iY = Math.floor(j / 3) - 1;
					if (iX == 0 && iY == 0) continue;

					//внешняя строна центального ряда
					face = new Face(clrMaterial , vertices, indices, uvData);
					face.sortingPriority = innerFacePriority;
					face.x = iX * realSize/3;
					face.y = iY * realSize/3;

					dir = Cube.FACES_ORIENTATION[i].clone();
					dir.negate();
					pos = Cube.FACES_POSITION[i].clone();
					pos.scaleBy(realSize / 2 - realSize / 3 - _shift/3);// ближе

					face.transform.matrix3D.appendRotation(dir.x, Vector3D.X_AXIS);
					face.transform.matrix3D.appendRotation(dir.y, Vector3D.Y_AXIS);
					face.transform.matrix3D.appendRotation(dir.z, Vector3D.Z_AXIS);
					face.transform.matrix3D.appendTranslation(pos.x, pos.y, pos.z);

					addFace(face);
					_initState.push( new FaceState(face) );
					//внутренняя строна внешнего ряда
					face = new Face(clrMaterial , vertices, indices, uvData);
					face.inside = true;//изнанка
					face.sortingPriority = innerFacePriority;
					face.x = iX * realSize/3;
					face.y = iY * realSize/3;

					dir = Cube.FACES_ORIENTATION[i].clone();
					dir.negate();//обратная ориентация
					pos = Cube.FACES_POSITION[i].clone();
					pos.scaleBy(realSize / 2 - realSize / 3 + _shift/3);//дальше

					face.transform.matrix3D.appendRotation(dir.x, Vector3D.X_AXIS);
					face.transform.matrix3D.appendRotation(dir.y, Vector3D.Y_AXIS);
					face.transform.matrix3D.appendRotation(dir.z, Vector3D.Z_AXIS);
					face.transform.matrix3D.appendTranslation(pos.x, pos.y, pos.z);

					addFace(face);
					_initState.push( new FaceState(face));
				}
			}
		}

		/**
		 * ставит грани в исходное пложение
		 */
		public function reset():void
		{

			for (var i:int = 0; i < _initState.length; i++)
			{
				_initState[i].reset();

			}
			invalidate();
		}

		/**
		 * определяет слой для вращения, соотвествующий глобальным точкам p1, p2<br/>
		 * складывает в виртуальную модель грани, если удалось выбрать или очищает виртуальную модель, если не удалось
		 * @param	p1				глобальная точка 'клика'
		 * @param	p2				глобальная точка направления драга
		 */
		public function setDragLayer(p1:Point, p2:Point):void
		{

			var axis:String=X;
			var level:int=0;
			var side:int = 0;
			for (var i:int = 0; i < 54; i++)
			{
				var face:Face = _faces[i];

				if (face.visible && face.hitTestPoint(p1.x, p1.y))
				{

					//позиции  в плоскости грани
					var v1:Vector3D = face.globalToLocal3D(p1);
					var v2:Vector3D = face.globalToLocal3D(p2);

					//направление
					var dir:Vector3D = new Vector3D(v2.x - v1.x, v2.y - v1.y);
					//переводим в координаты кубика
					dir = face.transform.matrix3D.deltaTransformVector(dir);

					//точность для координат
					var tol:Number = 0.9;

					

					//опрделяем к какой стороне кбуа относится текущее положение маленькой грани
					//расстояние до лицевых граней
					var dist:Number = (_size-_shift) / 2;

					if (Math.abs(face.z + dist) < tol)
					{
						side = 0;
					}else if (Math.abs(face.z - dist) < tol)
					{
						side = 2;
					}else if (Math.abs(face.x - dist) < tol)
					{
						side = 1;
					}else if (Math.abs(face.x + dist) < tol)
					{
						side = 3;
					}else if (Math.abs(face.y + dist) < tol)
					{
						side = 5;
					}else if (Math.abs(face.y - dist) < tol)
					{
						side = 4;
					}

					//trace( "side : " + side );
					//ось вращения в зависимости от стороны куба и величины сдвига по осям
					switch(side)
					{
						case 0:
						case 2:
							axis = Math.abs(dir.y) > Math.abs(dir.x) ? X : Y;
						break;
						case 1:
						case 3:
							axis = Math.abs(dir.y) > Math.abs(dir.z) ? Z : Y;
						break;
						case 5:
						case 4:
							axis = Math.abs(dir.z) > Math.abs(dir.x) ? X : Z;
						break;
					}

					/*
					switch(axis)
					{
					case X:
					dragDirection = dir.y * dir.z < 0 ? 1 : -1;
					break;
					case Y:
					dragDirection = dir.x * dir.z < 0 ? 1 : -1;
					break;
					case Z:
					dragDirection = dir.x * dir.y < 0 ? 1 : -1;
					break;

					}
					*/

					//глубниа слоя по соответствующей координате
					level = Math.round(3 * face[axis] / _size);

					setLayer(axis, level);
					return;
				}

			}
			clearLayer();
		}

		//////////////////////////////////////////////////
		/**
		 * очищает массив граней слоя
		 */
		public function clearLayer():void
		{
			//alignLayer();
			_layer.list = [];
		}

		/**
		 * выравнивает углы поворота слоя кратно 90 град.
		 */
		public function alignLayer():void
		{

			_layer.rotationX = 90 * Math.round(_layer.rotationX / 90);
			_layer.rotationY = 90 * Math.round(_layer.rotationY / 90);
			_layer.rotationZ = 90 * Math.round(_layer.rotationZ / 90);

		}

		/**
		 * складывает в слой грани соотвествующие оси axis("x","y","z") и уровня level (-1,0,1)
		 * @param	axis		ось
		 * @param	level		уровень
		 * @return
		 */
		public function setLayer(axis:String, level:int):void
		{
			alignLayer();
			clearLayer();
			var dist:Number = level * _size / 3;
			var tol:Number = _size / 6;
			for (var i:int = 0; i < numChildren; i++)
			{
				var face:Face = Face(getChildAt(i));
				if (Math.abs(face[axis] - dist) < tol)
				{
					_layer.list.push(face);
				}
			}

			layerAxis = axis;
			layerLevel = level;
		}

		/**
		 * есть ли слой
		 */
		public function get hasLayer():Boolean
		{
			return layer.list.length > 0;
		}

		/**
		 * размер грани
		 */
		public function get size():Number { return _size; }
		/**
		 * виртуальная модель текущего слоя
		 */
		public function get layer():VirtualModel { return _layer; }
		
		/*override public function set material(value:Material):void
		{
			throw(new Error("Rubic d't suuprt set material"));
		}*/

	}

}

////////////////////////////////////////////
////////////////////////////////////////////
import flash.geom.Vector3D;
import silin.zod.core.Face;
class FaceState
{
	private var _face:Face;
	private var _position:Vector3D;
	private var _orientation:Vector3D;

	public function FaceState(face:Face):void
	{
		_face = face;
		_position = face.position;
		_orientation = face.orientation;
	}
	public function reset():void
	{
		_face.position = _position;
		_face.orientation = _orientation;
	}
}

