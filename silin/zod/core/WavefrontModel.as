/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;
	

	/**
	 * PolyhedronModel из данных формата Wavefront OBJ; <br/>
	 * получается далеко не для всякой модели, <br/>
	 * пересекающиеся грани не можем, <br/>
	 * текстура одна на модель (файл .obj)
	 *
	 * @author silin
	 */

	public class WavefrontModel extends PolyhedronModel
	{
		private var _vertices:Array/*Vector3D*/ = [];//массив вершин данных
		private var _uvPoints:Array/*Vector3D*/= [];//массив uv-координат

		private var _facesArr:Array/*Array*/ = [];//грани (массивы индексов вершин)
		private var _uvArr:Array/*Array*/ = [];//координаты заливки (массивы индексов uv-координат)
		private var _center:Vector3D;
		
		private var _scale:Number = 1;
		

		/**
		 *
		 * @param	material			материал
		 * @param	wavefrontOBJ		строка с данными (содержимое OBJ файла)
		 * @param	scale				масштабирование 
		 */
		public function WavefrontModel(material:Material, wavefrontOBJ:String, scale:Number = 1 )
		{
			super(material);
			_scale = scale;
			if (parseData(wavefrontOBJ))
			{
				createFaces();
				update();
			}else
			{
				throw(new Error("invalid OBJ data"));
			}
			
		}

		private function createFaces():void
		{
			for (var i:int = 0; i < _facesArr.length; i++)
			{
				createFace(i);
			}
		}
		
		//считаем плоские координаты заливки и углы координаты в 3D-пространстве
		private function createFace(num:int):void
		{
			
			var i:int;

			//массив нормализованных координат заливки в источнике
			var uvData:Vector.<Number> = new Vector.<Number>();
			//массив координат заливки
			var vertices:Vector.<Number> = new Vector.<Number>();
			//массив индексов вершин
			var indices:Vector.<int> = new Vector.<int>();

			var fArr:Array = _facesArr[num];//массив индексов вершин
			
			var tArr:Array = _uvArr[num];//массив индексов uv-координат
			
			
			//число вершин
			var len:int = fArr.length;

			//массив вершин многоугольника
			var vertArr:Array/*Vector3D*/ = [];// [_vertices[fArr[0]], _vertices[fArr[1]], _vertices[fArr[2]]];
			for (i = 0; i < len; i++) vertArr.push(_vertices[fArr[i]]);
			
			
			
			
			//массив uv-координат заливки
			var coords:Array/*Point*/= [];// [_uvPoints[tArr[0]], _uvPoints[tArr[1]], _uvPoints[tArr[2]]];
			for (i = 0; i < len; i++) coords.push(_uvPoints[tArr[i]]);
			
			//массив для вершин треугольнка, развернутого перпендикуляпрно Z
			var planeVertArr:Array/*Vector3D*/= [];

			//нормаль
			var v1:Vector3D = vertArr[0].subtract(vertArr[1]);
			var v2:Vector3D = vertArr[0].subtract(vertArr[2]);
			

			var normal:Vector3D = v2.crossProduct(v1);
			

			//центр тяжести в 3D-мире

			var cV:Vector3D = new Vector3D();// vertArr[0].add(vertArr[1]).add(vertArr[2]);
			for (i = 0; i < len; i++) cV = cV.add(vertArr[i]);
			cV.scaleBy(1 / len);
			
			//иначе будет дырка из-за того, что точки сольюются, а так ничего..
			if (cV.z == 0)
			{
				cV.z = 1e-6;
			}

			//TODO: непонятные щели, никак не выходит чертов каменный цветок
			//двигам грань к центру, пропорцонально координате, дальние подвинуться больше
			//понятно, что все это никуда не годится
			//cV.scaleBy(0.985);


			//матрица разворота в плоскость XY
			var mtrx:Matrix3D = new Matrix3D();
			mtrx.appendTranslation( cV.x, cV.y, 0);
			mtrx.pointAt(cV, normal);
			
			

			//вершины полигона, развернутого паралельно XY
			for (i = 0; i < len; i++)
			{
				//planeVertArr[i] = mtrx.deltaTransformVector(vertArr[i]);
				planeVertArr[i] = mtrx.transformVector(vertArr[i]);
				
			}
			
			

			//центр тяжести в плоскости
			
			var cX:Number = 0;
			var cY:Number = 0;
			for (i = 0; i < len; i++)
			{
				cX += planeVertArr[i].x;
				cY += planeVertArr[i].y;
				
			}
			cX /= len;
			cY /= len;
			
			
			for (i = 0; i < len; i++)
			{
				//координаты заливки (рисуем относительно центра)
				var pX:Number = (planeVertArr[i].x - cX);
				var pY:Number = (planeVertArr[i].y - cY);
				
				
				//снова борьба со щелями между: раздвигаем вершины на пиксель
				//наиболее адекватный вариант тоже шаманство, но иначе все плохо
				
				
				var r:Number = Math.sqrt(pX * pX + pY * pY);
				//для существенных расстояний (>4, например) берем пиксель, 
				//для меньших хз пока..
				var k:Number = r > 4 ? (r + 1) / r : 1;
				pX *= k;
				pY *= k;
				
				
				/*pX = (int(20 * pX)+1) / 20;
				pY = (int(20 * pY)+1) / 20;*/
				/*
				var del:Number = 1;
				pX = pX > 0? pX + del : pX - del;
				pY = pY > 0? pY + del : pY - del;
				*/
				
				/*//сдвигаемся  от центра
				var k:Number =  (r + 0.5) / r;
				
				pX *= k;
				pY *= k;*/

				vertices.push(pX, pY);
				
				

				//нормализованные координаты в источнике для моделей, у которых есть
				if (coords[i])
				{
					var tX:Number = coords[i].x;
					var tY:Number = coords[i].y;
					//var tZ:Number = coords[i].z;
					uvData.push(tX);
					uvData.push(1-tY);
				}
			}
			mtrx.invert();
			/*var k1:Number = (cV.length - 0.05) / cV.length;
			cV.scaleBy(k1);*/
			mtrx.position = cV;
			
			
			
			

			
			//индексы вершин треугольников (приемлимо только для выпуклых полигонов)
			for (i = 0; i < len-2; i++) 
			{
				var last:int = (i + 2) % len;
				indices.push(0, i + 1, last);
			}
			
			createPolygonFace(vertices, indices, uvData, mtrx);
			
		}

		//парсим данные
		private function parseData(data:String):Boolean
		{
			var arr:Array;
			//массив строк данных

			var strArr:Array = data.split("\n");
			

			for (var i:int = 0; i < strArr.length; i++)
			{
				var str:String = strArr[i];

				str = str.split("   ").join(" ");//лишние пробелы
				str = str.split("  ").join(" ");

				switch(str.substr(0, 2))//начало строчки
				{
					case "v "://верщины
						arr = str.substr(2).split(" ");
						var v:Vector3D = new Vector3D( _scale * parseFloat(arr[0]), -_scale * parseFloat(arr[1]), -_scale * parseFloat(arr[2]));
						_vertices.push(v);

					break;

					case "vt"://координаты текстуры

						arr = str.substr(3).split(" ");
						//var p:Point = new Point(parseFloat(arr[0]), parseFloat(arr[1]));
						var p:Vector3D = new Vector3D(parseFloat(arr[0]), parseFloat(arr[1]), parseFloat(arr[2]));
						_uvPoints.push(p);
					break;

					case "f "://грани
						arr = str.substr(2).split(" ");
						var fArr:Array = [];
						var tArr:Array = [];
						for (var j:int = 0; j < arr.length; j++)
						{
							var itemStr:String = arr[j];
							var dat:Array = itemStr.split("/");
							fArr.push(parseInt(dat[0])-1);
							tArr.push(parseInt(dat[1])-1);
					}
					_facesArr.push(fArr);
					
					
					_uvArr.push(tArr);
					break;
				}
				
			}
			
			//вершины и грани нужны по-любому
			if (!_facesArr.length ||  !_vertices.length)
			{
				return false;
			}

			//для DrawableMaterial нужны еще и UV-координаты заливки
			if (material is DrawableMaterial && (!_uvPoints.length||!_uvArr.length))
			{
				return false;
			}
			return true;
		}

	}

}

