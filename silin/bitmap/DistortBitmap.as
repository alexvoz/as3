/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.bitmap{
	import flash.display.*;
	import flash.geom.*;
	/**
	 * спрайт с механизмом отрисовки текстуры  в произволные точки; <br>
	 * реализован за счет создания треугольных битмапов и их трансформации через transform.matrix; <br>
	 * @author silin
	 */
	public class DistortBitmap extends Sprite {
		private var nx:int;//число разбиений
		private var ny:int;
		private var imageW:Number;
		private var imageH:Number;
		private var isLinear:Boolean;
		private var fragArr:Array=[];
		/**
		 * constructor
		 * @param	source	исходный BitmapData  
		 * @param	divX	число фрагментов по горизонтали
		 * @param	divY	число фрагментов по вертикали<br>
		 * если число фрагментов 0 (по верикали или горизонтали), то трансформируем битмап целиком, без разбиения на треугольники<br>
		 */
		public function DistortBitmap(source:BitmapData, divX:Number = 0, divY:Number = 0)
		{
			nx=divX;
			ny=divY;
			isLinear=!nx || !ny;//только линейная транформация
			if (isLinear)
			{
				imageW=source.width;
				imageH=source.height;
				addChild(new Bitmap(source));
			}else
			{
				var fragW:int = Math.floor(source.width / nx)// размеры фрагментов
				var fragH:int = Math.floor(source.height / ny);
				var fragRect:Rectangle = new Rectangle(0, 0, fragW, fragH);
				for (var i:int = 0; i < 2 * nx * ny; i++)// 2*nx*ny битмапа 
				{
					var odd:Boolean=Boolean(i%2);
					if (!odd)//для пары треугольников область копирования одинаковая
					{
						fragRect.x=((i/2)%nx)*fragW;
						fragRect.y=Math.floor(i/2/nx)*fragH;
					}
					var triBitmap :TriBitmap = new TriBitmap(source, fragRect, odd);
					fragArr.push(triBitmap);	
					addChild(triBitmap);
				}
				source.dispose();
			}
			
		}	
		/*
		* трансформирует спрайт в координаты углов, переданных в points (начиная с TL по часовой<br>
		* для линейной трансформации четвертая точка не при делах
		*/
		public function distort(points:Array):void{
			if (isLinear)
			{
				//по трем точкам, четвертая не при делах
				var tl:Point=new Point(points[0].x,points[0].y);
				var tr:Point=new Point(points[1].x,points[1].y);
				var br:Point=new Point(points[2].x,points[2].y);
				//var bl:Point=new Point(points[3].x,points[3].y);
				var sx:Number = (tr.x - tl.x) / imageW;
				var skx:Number = (br.x - tr.x) / imageH;
				var sy:Number = (br.y - tr.y) / imageH;
				var sky:Number = (tr.y - tl.y) / imageW;
				var tx:Number = tl.x;
				var ty:Number = tl.y;
				transform.matrix=new Matrix(sx,sky,skx,sy,tx,ty);
			}else
			{
				var i:int;
				var j:int;
				var n:int;
				var gridArr:Array=[];// сетка 
				
				for (j = 0; j < ny + 1; j++)
				{
					var rl:Point = new Point(points[0].x + (points[3].x - points[0].x) * j / ny,
											points[0].y + (points[3].y - points[0].y) * j / ny);
					var rr:Point = new Point(points[1].x + (points[2].x - points[1].x) * j / ny,
											points[1].y + (points[2].y - points[1].y) * j / ny);
					gridArr[j]=[];
					for(i = 0;i<nx+1;i++) 
						gridArr[j].push(new Point(Math.floor(rl.x+i*(rr.x-rl.x)/nx),
												Math.floor(rl.y+i*(rr.y-rl.y)/nx)));
				}
				
				for (n = 0; n < nx * ny; n++)
				{//плющим битмапы в координаты сетки
					i = n % nx;//столбец
					j = Math.floor(n/nx);// строка
					fragArr[2 * n].trans(gridArr[j][i + 1],//верхн.
										gridArr[j][i],
										gridArr[j + 1][i]);
					fragArr[2*n+1].trans(gridArr[j][i+1],//нижн
										gridArr[j+1][i+1],
										gridArr[j+1][i]);
				}
			}
		}
	}
}			
/////////////////////////////
import flash.display.*;
import flash.geom.*;
class TriBitmap extends Bitmap {
	private var w:int;//исходные размеры
	private var h:int;
	private var inv:Boolean;//true для нижнего треугольника 
	private const ORIGIN:Point=new Point();
	
	public function TriBitmap(bmp:BitmapData,drawAreaRect:Rectangle,isDwn:Boolean){
		w=Math.round(drawAreaRect.width);
		h=Math.round(drawAreaRect.height);
		inv=isDwn;
		super(new BitmapData(w,h));	
		smoothing=true;
		x=drawAreaRect.right;
		y=drawAreaRect.top;
		var shape:Shape=new Shape();//треугольник
		var g:Graphics=shape.graphics;	
		g.lineStyle(1);
		g.beginFill(0);
		g.moveTo(w,0);
		g.lineTo(0,h);
		g.lineTo(inv ? w : 0, inv ? h: 0);//углом вверх или вниз
		g.lineTo(w,0);
		g.endFill();
		
		
		var maskBMP:BitmapData=new BitmapData(w,h,true,0x00FFFFFF);
		maskBMP.draw(shape,new Matrix());
		//копируем фрагмент с треугольной маской
		bitmapData.copyPixels(bmp,drawAreaRect,ORIGIN,maskBMP,ORIGIN);
		maskBMP.dispose();
		
	}
	//линейно растягивает в  tl,tr,br
	public function trans(tl:Point, tr:Point, br:Point):void {
		
		//'вывертываем' если нижний
		if (inv) tr = new Point(tl.x + br.x - tr.x, tl.y + br.y - tr.y);
		transform.matrix=new Matrix((tl.x - tr.x)/w,
									(tl.y - tr.y)/w,
									(br.x - tr.x)/h,
									(br.y - tr.y)/h,
									tr.x, tr.y);	
	}
}