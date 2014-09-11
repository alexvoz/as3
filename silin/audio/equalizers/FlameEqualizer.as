/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	import flash.display.GradientType;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	
	/**
	 * типа свечка
	 *
	 * @author silin
	 */
	public class FlameEqualizer extends GradientEqualizer
	{
		
		private var maxHeight:Number = 80;
		private var minHeight:Number = 40;
		
		private var c1w:Number = 1;
		private var c2w:Number = 1;
		private var counter:int = 0;
		private var defaultColors:Array = [0xCC3300, 0xFFDD00, 0xD0A030, 0xFFCECE];
		private var pTop:FlamePoint;
		private var pLeft:FlamePoint;
		private var pRight:FlamePoint;
		private var pBottom:FlamePoint = new FlamePoint();
		
		private var nGen:int = 3;
		private var rndXArr:Array = [];
		private var rndYArr:Array = [];
		
		private var size:Number;
		
		/**
		 *
		 * @param	colorArr		массив цветов (только 4 цвета)
		 * @param	minHeight		минимальная высота
		 * @param	maxHeight		масксимальная высота
		 */
		public function FlameEqualizer(colorArr:Array /*uint*/ = null, minHeight:Number = 40, maxHeight:Number = 80)
		{
			this.minHeight = minHeight;
			this.maxHeight = maxHeight;
			
			
			var colors:Array = (colorArr && colorArr.length == 4)?colorArr:defaultColors;
			super(colors);
			
			size = 0.25 * minHeight;
			
			
			pTop = new FlamePoint(0, -minHeight, 0, 0, 0, -minHeight);
			pLeft = new FlamePoint(-size, -size, 0, 0, -size, -size);
			pRight = new FlamePoint(size, -size, 0, 0, size, -size);
			
			for (var i:int = 0; i < nGen; i++)
			{
				rndXArr.push(Math.random() - 1);
				rndYArr.push(Math.random() - 0.5);
			}
		
		}
		
		public override function set bands(value:uint):void
		{
			throw(new Error("FlameEqualizer#bands may be only 3"));
		}
		
		private function calcGen(i:int, v:int, y:Number):Number
		{
			return 2 * level * Math.sin((rndXArr[i] * v) + rndYArr[i] + y);
		}
		
		protected override function render():void
		{
			
			var i:int;
			
			
			counter++;
			
			for (i = 0; i < rndXArr.length; i++)
			{
				
				pTop.tX = pTop.tX + calcGen(i, counter, pTop.y);
				pTop.tY = pTop.tY + calcGen(i, counter, pTop.x);
				pLeft.tX = pLeft.tX + calcGen(i, counter, pLeft.tY);
				pLeft.tY = pLeft.tY + calcGen(i, counter, pLeft.tX);
				pRight.tX = pRight.tX + calcGen(i, counter, pRight.tY);
				pRight.tY = pRight.tY + calcGen(i, counter, pRight.tX);
				
				c1w += calcGen(i, counter, c1w + pTop.x);
				c2w += calcGen(i, counter, c2w - pTop.x);
			}
			
			if (c1w < 0.5) c1w = 0.5;
			if (c1w > 1) c1w = 1;
			if (c2w < 0.5) c2w = 0.5;
			if (c2w > 1) c2w = 1;
			
			pTop.tX *= 0.9;
			var h:Number = minHeight + (maxHeight - minHeight) * level * 2;
			pTop.tY = -0.8 * h + 0.2 * pTop.tY;
			
			pLeft.tX = (0.1 * (pTop.tX - (2 * size * Math.abs(c1w)))) + (0.8 * pLeft.tX);
			pLeft.tY = ((0.1 * pTop.tY) + (0.7 * pBottom.tY)) + (0.2 * pLeft.tY);
			pRight.tX = (0.1 * (pTop.tX + (2 * size * Math.abs(c2w)))) + (0.8 * pRight.tX);
			pRight.tY = ((0.1 * pTop.tY) + (0.7 * pBottom.tY)) + (0.2 * pRight.tY);
			
			pTop.vX += ((pTop.tX - pTop.x) * 0.05);
			pTop.vX *= 0.9;
			pLeft.vX += ((pLeft.tX - pLeft.x) * 0.05);
			pLeft.vX *= 0.9;
			pRight.vX += ((pRight.tX - pRight.x) * 0.05);
			pRight.vX *= 0.9;
			pTop.vY += ((pTop.tY - pTop.y) * 0.3);
			pTop.vY *= 0.9;
			pLeft.vY += ((pLeft.tY - pLeft.y) * 0.05);
			pLeft.vY *= 0.9;
			pRight.vY += ((pRight.tY - pRight.y) * 0.05);
			pRight.vY *= 0.9;
			
			pTop.x += pTop.vX;
			pLeft.x += pLeft.vX;
			pRight.x += pRight.vX;
			pTop.y += pTop.vY;
			pLeft.y += pLeft.vY;
			pRight.y += pRight.vY;
			
			//draw
			graphics.clear();
			var mtrx:Matrix = new Matrix();
			mtrx.createGradientBox(2 * (pRight.x - pLeft.x), (-2 * pTop.y) - size, 0, -(pRight.x - pLeft.x), pTop.y);
			
			alphas = [0, 25, 25, 0];
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mtrx);
			graphics.moveTo(pBottom.x, pBottom.y);
			graphics.curveTo(pLeft.x - 0.3 * size, pLeft.y, pTop.x, pTop.y - 0.7 * size);
			graphics.lineTo(pBottom.x, pBottom.y);
			graphics.endFill();
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mtrx);
			graphics.curveTo(pRight.x + 0.3 * size, pRight.y, pTop.x, pTop.y - 0.7 * size);
			graphics.lineTo(pBottom.x, pBottom.y);
			graphics.endFill();
			
			alphas = [10, 50, 50, 15];// [10, 30, 30, 15];
			ratios[1] *= 1.25;
			ratios[2] = 0.5 * (ratios[1] + ratios[3]);
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mtrx);
			graphics.moveTo(pBottom.x, pBottom.y);
			graphics.curveTo(pLeft.x - 0.15 * size, pLeft.y, pTop.x, pTop.y - 0.25 * size);
			graphics.lineTo(pBottom.x, pBottom.y);
			graphics.endFill();
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mtrx);
			graphics.curveTo(pRight.x + 0.15 * size, pRight.y, pTop.x, pTop.y - 0.25 * size);
			graphics.lineTo(pBottom.x, pBottom.y);
			graphics.endFill();
			
			alphas = [60, 80, 80, 50];// [30, 40, 40, 25];
			ratios[1] *= 1.25;
			ratios[2] = 0.5 * (ratios[1] + ratios[3]);
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mtrx);
			graphics.moveTo(pBottom.x, pBottom.y);
			graphics.curveTo(pLeft.x, pLeft.y, pTop.x, pTop.y + 0.25 * size);
			graphics.lineTo(pBottom.x, pBottom.y);
			graphics.endFill();
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mtrx);
			graphics.curveTo(pRight.x, pRight.y, pTop.x, pTop.y + 0.25 * size);
			graphics.lineTo(pBottom.x, pBottom.y);
			graphics.endFill();
			
			
			
			// TODO: узаконить ли яркость-альфу  ?
			this.alpha = 0.35 + 3 * level;
			var br:Number =  16 * level - 1;
			if (br > 0) br = 0;
			

			var brMtrx:Array = [1, 0, 0, 0, 255 * br,
								0, 1, 0, 0, 255 * br,
								0, 0, 1, 0, 255 * br,
								0, 0, 0, 1, 0 ];
								
			filters = [new ColorMatrixFilter(brMtrx)];
			
			
		}
	}

}

////////////////////////////////
class FlamePoint
{
	public var x:Number;
	public var y:Number;
	public var tX:Number;
	public var tY:Number;
	public var vX:Number;
	public var vY:Number;
	
	public function FlamePoint(x:Number = 0, y:Number = 0, vX:Number = 0, vY:Number = 0, tX:Number = 0, tY:Number = 0)
	{
		this.x = x;
		this.y = y;
		this.vX = vX;
		this.vY = vY;
		this.tX = tX;
		this.tY = tY;
	}

}