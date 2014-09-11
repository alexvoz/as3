/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.primitives
{

	import flash.display.*;
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;


	/**
	 * гексагедрон (кубик из пирамидок) <br/>
	 * DrawableMaterial трактуется как карта граней базового куба с расположением  front-right-back-left-floor-ceil
	 * @author silin
	 */
	public class Hexahedron extends PolyhedronModel
	{

		private var _size:Number;
		private var _angle:Number;

		/**
		 *
		 * @param	material	материал (DrawableMaterial, ColorMaterial, TextureMaterial)
		 * @param	size		размер грани базового куба
		 * @param	angle		угол 'выпученности'
		 */
		public function Hexahedron(material:Material, size:int, angle:Number=34.485622774)
		{
			super(material);
			_size = size;
			_angle = angle;
			createFaces();
			update();
		}

		private function createFaces():void
		{
			var i:int;
			var face:Face;
			var uvData:Vector.<Number>;
			var vertices:Vector.<Number>;
			var mtrx:Matrix3D;
			var dir:Vector3D;
			var pos:Vector3D;
			
			//угол 'выпуклости'
			//var fi:Number = 22.5;// Math.atan(Math.SQRT2 - 1);
			//var fi:Number = 36.20602311300311;// Math.atan(Math.SQRT3 - 1);
			//var fi:Number = 34.485622774072098433977540125332;// 2*Math.atan(Math.SQRT(2+0.25) - 1);

			var triW:Number = 0.5 * _size;//половина основания треугольника
			var triH:Number = triW / Math.cos(Math.PI / 180 * _angle);//высота треугольника

			for (i = 0; i < 6; i++)
			{
				//костыль для того чтобы  брать uv координтаы на пиксель ближе к центу, иначе вылезают какие-то артефакты
				var k:Number = material.sourceRect ?  1.05 / material.sourceRect.width  : 0; //1px в карте
				var u0:Number = i / 6 + k;
				var u5:Number = (i + 0.5) / 6;
				var u1:Number = (i + 1) / 6 -k;

				k = material.sourceRect ? 1.05 / material.sourceRect.height  : 0;
				var v0:Number = k;
				var v5:Number = 0.5;
				var v1:Number = 1 - k;
				
				
				

				//параметры грани базового куба
				dir = Cube.FACES_ORIENTATION[i].clone();
				dir.negate();//ориентация элемента противоположна ориентации кубика
				pos = Cube.FACES_POSITION[i].clone();

				pos.scaleBy(size / 2);

				//грани пирамиды
				//четыре треугольника заливкой шейпа из соответсвующего фрагмента  битмапа
				//поворачиваем-сдвигаем, чтобы каждый встал как грань пирамидки

				//BOTTOM
				uvData = Vector.<Number>([u0, v1, u1, v1, u5, v5]);
				vertices = Vector.<Number>([ -triW, 0,  triW, 0, 0, -triH]);
				
				mtrx = new Matrix3D();
				mtrx.prependTranslation(0, triW, 0);
				mtrx.prependRotation(_angle, Vector3D.X_AXIS);
				mtrx.appendRotation(dir.x, Vector3D.X_AXIS);
				mtrx.appendRotation(dir.y, Vector3D.Y_AXIS);
				mtrx.appendRotation(dir.z, Vector3D.Z_AXIS);
				mtrx.appendTranslation(pos.x, pos.y, pos.z);
				createPolygonFace(vertices, null, uvData, mtrx);

				//LEFT
				uvData = Vector.<Number>([u0, v0, u0, v1, u5, v5]);
				vertices = Vector.<Number>([ -0, -triW,  -0, triW, triH, 0]);
				
				mtrx = new Matrix3D();
				mtrx.prependTranslation(-triW, 0, 0);
				mtrx.prependRotation(_angle, Vector3D.Y_AXIS);
				mtrx.appendRotation(dir.x, Vector3D.X_AXIS);
				mtrx.appendRotation(dir.y, Vector3D.Y_AXIS);
				mtrx.appendRotation(dir.z, Vector3D.Z_AXIS);
				mtrx.appendTranslation(pos.x, pos.y, pos.z);
				createPolygonFace(vertices, null, uvData, mtrx);

				//TOP
				uvData = Vector.<Number>([u0, v0, u5, v5, u1, v0]);
				vertices = Vector.<Number>([ -triW, -0, 0, triH, triW, -0 ]);
				
				mtrx = new Matrix3D();
				mtrx.prependTranslation(0, -triW,  0);
				mtrx.prependRotation(-_angle, Vector3D.X_AXIS);
				mtrx.appendRotation(dir.x, Vector3D.X_AXIS);
				mtrx.appendRotation(dir.y, Vector3D.Y_AXIS);
				mtrx.appendRotation(dir.z, Vector3D.Z_AXIS);
				mtrx.appendTranslation(pos.x, pos.y, pos.z);
				createPolygonFace(vertices, null, uvData, mtrx);

				//RIFGHT
				uvData = Vector.<Number>([u1, v0, u5, v5,  u1, v1]);
				vertices = Vector.<Number>([ 0, -triW, -triH, 0, 0, triW]);
				
				mtrx = new Matrix3D();
				mtrx.prependTranslation(triW, 0, 0);
				mtrx.prependRotation(-_angle, Vector3D.Y_AXIS);
				mtrx.appendRotation(dir.x, Vector3D.X_AXIS);
				mtrx.appendRotation(dir.y, Vector3D.Y_AXIS);
				mtrx.appendRotation(dir.z, Vector3D.Z_AXIS);
				mtrx.appendTranslation(pos.x, pos.y, pos.z);
				createPolygonFace(vertices, null, uvData, mtrx);
			}

		}

		
		
		/**
		 * размер грани базового куба
		 */
		public function get size():Number { return _size; }

	}
}

