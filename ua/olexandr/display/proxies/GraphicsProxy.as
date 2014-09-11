package ua.olexandr.display.proxies {
	import flash.display.Graphics;
	import ua.olexandr.display.proxies.BaseProxy;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class GraphicsProxy extends BaseProxy {
		
		private var _graphics:Graphics;
		
		public function GraphicsProxy(graphics:Graphics) {
			_graphics = graphics;
		}
		
		
		public function beginFill(color:uint, alpha:Number):GraphicsProxy {
			_graphics.beginFill(color, alpha);
			return this;
		}
		
		public function lineStyle(thickness:Number = null, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):GraphicsProxy {
			_graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
			return this;
		}
		
		public function moveTo(x:Number, y:Number):GraphicsProxy {
			_graphics.moveTo(x, y);
			return this;
		}
		
		public function lineTo(x:Number, y:Number):GraphicsProxy {
			_graphics.lineTo(x, y);
			return this;
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):GraphicsProxy {
			_graphics.curveTo(controlX, controlY, anchorX, anchorY);
			return this;
		}
		
		public function endFill():GraphicsProxy {
			_graphics.endFill();
			return this;
		}
		
		public function clear():GraphicsProxy {
			_graphics.clear();
			return this;
		}
		
		
		public function drawCircle(x:Number, y:Number, radius:Number):GraphicsProxy {
			_graphics.drawCircle(x, y, radius);
			return this;
		}
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):GraphicsProxy {
			_graphics.drawEllipse(x, y, width, height);
			return this;
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):GraphicsProxy {
			_graphics.drawRect(x, y, width, height);
			return this;
		}
		
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = null):GraphicsProxy {
			_graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
			return this;
		}
		
	}

}
