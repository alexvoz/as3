/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.zod.primitives
{

	import flash.display.*;
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;

	/**
	 * куб <br/>
	 * DrawableMaterial трактуется как карта граней с расположением  front-right-back-left-floor-ceil
	 * @author silin
	 */
	public class Cube extends PolyhedronModel
	{

		/**
		 * базовая ориентиация граней, градусы
		 */
		public static const FACES_ORIENTATION:Array/*Vector3D*/=
		[
		new Vector3D(0, 0, 0),
		new Vector3D(0, 90, 0),
		new Vector3D(0, 180, 0),
		new Vector3D(0, -90, 0),
		new Vector3D(-90, 0, 0),
		new Vector3D(90, 0, 0)
		];

		/**
		 * нормализованные координаты граней
		 */
		public static const FACES_POSITION:Array/*Vector3D*/=
		[
		new Vector3D(0, 0, -1),
		new Vector3D(1, 0, 0),
		new Vector3D(0, 0, 1),
		new Vector3D(-1, 0, 0),
		new Vector3D(0, 1, 0),
		new Vector3D(0, -1, 0)
		];

		private var _size:Number;

		/**
		 *
		 * @param	material	материал (DrawableMaterial, ColorMaterial, TextureMaterial)
		 * @param	size		размер грани
		 */
		public function Cube(material:Material, size:int=0)
		{

			super(material);
			
			_size = size || material.sourceRect.height;
			createFaces();
			update();

		}

		private function createFaces():void
		{

			var s:Number = _size / 2;
			var vertices:Vector.<Number> = Vector.<Number>([ -s, -s, -s, s, s, s, s, -s]);
			var indices:Vector.<int> = Vector.<int>([0, 1, 2, 0, 2, 3]);
			var uvData:Vector.<Number>;

			for (var i:int = 0; i < 6; i++)
			{

				var rot:Vector3D = FACES_ORIENTATION[i].clone();
				rot.negate();
				var pos:Vector3D = FACES_POSITION[i].clone();
				pos.scaleBy(size / 2);

				var k:Number =  material.sourceRect ? 1 / material.sourceRect.width : 0;//1px в карте
				var u0:Number = i / 6 + k;
				var u1:Number = (i + 1) / 6 -k;

				k = material.sourceRect ? 1 / material.sourceRect.height :0;
				var v0:Number = k;
				var v1:Number = 1 - k;

				uvData = Vector.<Number>([u0, v0, u0, v1, u1, v1, u1, v0]);

				var mtrx:Matrix3D = new Matrix3D();
				mtrx.prependRotation(rot.x, Vector3D.X_AXIS);
				mtrx.prependRotation(rot.y, Vector3D.Y_AXIS);
				mtrx.prependRotation(rot.z, Vector3D.Z_AXIS);
				mtrx.appendTranslation(pos.x, pos.y,pos.z);
				createPolygonFace(vertices, indices, uvData, mtrx);

			}
		}

		/**
		 * размер грани
		 */
		public function get size():Number { return _size; }

	}
}

