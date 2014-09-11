/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	import flash.display.Shape;
	import flash.display.TriangleCulling;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;
	
	
	/**
	 * спрайт для отрисовки шейпа <br/>
	 * DrawableMaterial (beginBitmapFill+drawTriangles): нужны vertices, indices, uvData <br/>
	 * TextureMaterial (beginBitmapFill+lineTo): нужны vertices <br/>
	 * ColorMaterial ( beginFill+lineTo): нужны vertices <br/>
	 * 
	 * @author silin
	 */
	public class Face extends Sprite3D
	{
		
		private var _material:Material;
		private var _vertices:Vector.<Number>;
		private var _uvData:Vector.<Number>;
		private var _indices:Vector.<int> ;
		private var _matrix:Matrix = null;
		//геометрический центр на карте
		private var _cX:Number = 0;
		private var _cY:Number = 0;
		
		//public var id:int = -1;
		/**
		 * constructor
		 * @param	material	материал отрисовки
		 * @param	vertices	массив вершин [x0,y0,x1,y1,..] CCW
		 * @param	indices		индексы треугольников  (DrawableMaterial)
		 * @param	uvData		нормализованные координаты заливики  (DrawableMaterial)
		 */
		public function Face(material:Material, vertices:Vector.<Number>, indices:Vector.<int> , uvData:Vector.<Number>) 
		{
			_material = material;
			_vertices = vertices;
			_uvData = uvData;
			_indices = indices;
			
			//считаем матрицу подгонки текстуры
			if (_material is TextureMaterial)
			{
				calculateFitMatrix();
			}
			
			//геометрический центр грани в UV-координатах на карте материала
			var cU:Number = 0;
			var cV:Number = 0;
			if (_material.sourceRect)
			{
				var len:int = _uvData.length;
				for (var i:int = 0; i < len; i+=2) 
				{
					cU += _uvData[i];
					cV += _uvData[i + 1];
				}
				len/=2;
				cU /= len;
				cV /= len;
				//центр в пиксельных координатах
				_cX = cU * _material.sourceRect.width;
				_cY = cV * _material.sourceRect.height;
			}
			
			cacheAsBitmap = true;
		}
		
		/**
		 * перерисовывает шейп
		 */
		public function update():void 
		{
			
			var i:int;
			graphics.clear();
			if (_material is DrawableMaterial)
			{
				graphics.beginBitmapFill(DrawableMaterial(_material).bitmapData, null, true, _material.smoothing);
				graphics.drawTriangles(_vertices, _indices, _uvData, TriangleCulling.NONE);
			}else if (_material is ColorMaterial)
			{
				graphics.beginFill(ColorMaterial(_material).color);
				graphics.moveTo(_vertices[_vertices.length - 2], _vertices[_vertices.length - 1]);
				for (i = 0; i < _vertices.length; i+=2) 
				{
					graphics.lineTo(_vertices[i], _vertices[i + 1]);
				}
			}else if (_material is TextureMaterial)
			{
				graphics.beginBitmapFill(TextureMaterial(_material).bitmapData, _matrix, true, _material.smoothing);
				graphics.moveTo(_vertices[_vertices.length - 2], _vertices[_vertices.length - 1]);
				for (i = 0; i < _vertices.length; i+=2) 
				{
					graphics.lineTo(_vertices[i], _vertices[i + 1]);
				}
			}
			graphics.endFill();
			
		}
		
		private function calculateFitMatrix():void
		{
			var tmp:Shape = new Shape();
			tmp.graphics.beginFill(0x0);
			tmp.graphics.moveTo(_vertices[_vertices.length - 2], _vertices[_vertices.length - 1]);
			for (var i:int = 0; i < _vertices.length; i+=2) 
			{
				tmp.graphics.lineTo(_vertices[i], _vertices[i + 1]);
			}
			var bounds:Rectangle = tmp.getBounds(tmp);
			tmp.graphics.clear();
			_matrix = TextureMaterial(material).getFitMatrix(bounds.width, bounds.height);
		}
		
		public function get material():Material { return _material; }
		
		public function set material(value:Material):void 
		{
			_material = value;
			//считаем матрицу подгонки текстуры
			if (_material is TextureMaterial)
			{
				calculateFitMatrix();
			}
		}
		
		/**
		 * координаты геометрического центра в материале (актуально только для DrawableMaterial)
		 */
		public function get materialPoint():Point 
		{ 
			return new Point(_cX, _cY);
		}
	}

}