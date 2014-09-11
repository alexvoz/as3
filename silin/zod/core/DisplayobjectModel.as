/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.engine.ContentElement;
	
	
	/**
	 * модель из дисплейОбжектов
	 * @author silin
	 */
	public class DisplayobjectModel extends Container3D
	{
		/**
		 * constructor
		 * @param	objects		массив объектов
		 * @param	matrices	масиив матриц 3D-состояния объектов
		 * @param	center		надо ли центрировать объекты
		 */
		public function DisplayobjectModel(objects:Array/*DisplayObject*/, matrices:Array/*Matrix3D*/, centreObjects:Boolean = true) 
		{
			
			if (objects.length != matrices.length )
			{
				throw(new Error("DisplayobjectModel.DisplayobjectModel > objects : " + objects + ", matrices : " + matrices));
			}
			
			for (var i:int = 0; i < objects.length; i++) 
			{
				var obj:DisplayObject = objects[i] as DisplayObject || new Sprite();
				var mtrx:Matrix3D = matrices[i] as Matrix3D || new Matrix3D();
				
				var face:Sprite3D = new Sprite3D();
				face.name = ""+i;
				face.addChild(obj);
				
				//центрируем контент
				if (centreObjects && obj.width && obj.height)
				{
					var bounds:Rectangle = obj.getBounds(obj);
					obj.x = -obj.scaleX * (bounds.x + bounds.width / 2);
					obj.y = -obj.scaleY * (bounds.y + bounds.height / 2);
				}
				face.transform.matrix3D = mtrx;
				super.addChild(face);
			}
		}
		
		
		
		public function swapFaceBitmap(face:Sprite3D, obj:IBitmapDrawable):void
		{
			var bmd:BitmapData = (face.getChildAt(0) as Bitmap).bitmapData;
			bmd.draw(obj);
		}
		
		public function swapFaceContent(face:Sprite3D, obj:DisplayObject):void
		{
			
			
			while (face.numChildren) face.removeChildAt(0);
			
			
			var bounds:Rectangle = obj.getBounds(obj);
			obj.x = -obj.scaleX * (bounds.x + bounds.width / 2);
			obj.y = -obj.scaleY * (bounds.y + bounds.height / 2);
			
			
			face.addChild(obj);
			
			invalidate();
			
			
			
		}
		
		
		
		
	}

}