package ua.olexandr._.geo
{
	import com.greensock.data.BlurFilterVars;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import net.vis4.data.DataView;
	import net.vis4.geo.projection.MapProjection;
	import net.vis4.renderer.polygon.IPolygonRenderer;
	
	/**
	 * ...
	 * @author gka
	 */
	public class AnimatedWorldMap extends WorldMap
	{
		
		public function AnimatedWorldMap(data:String, width:Number, height:Number, mp:MapProjection, pr:IPolygonRenderer, countryColorFunc:Function = null, countryFilterFunc:Function = null) 
		{
			super(data, width, height, mp, pr, countryColorFunc, countryFilterFunc);
		}
		
		protected var _targetBounds:Rectangle;
		protected var _tweenVars:Object = { t: 0 };
		
		public function showCountry(c:Country):void
		{
			animateTo(countryBounds(c), 1, Cubic.easeInOut);
		}
		
		private function interpolateRect(r1:Rectangle, r2:Rectangle, t:Number):Rectangle
		{
			return new Rectangle(
				r1.x + t * (r2.x - r1.x),
				r1.y + t * (r2.y - r1.y),
				r1.width + t * (r2.width - r1.width),
				r1.height + t * (r2.height - r1.height)
			);	
		}
		
		public function animateTo(targetRect:Rectangle, duration:Number, easingFunc:Function):void
		{
			_targetBounds = targetRect;
			_tweenVars.t = 0;
			
			new TweenLite(_tweenVars, 3.5, { t: 1, onUpdate: _animateStep, onComplete: finishAnimation });
			
			
			var a:Rectangle = _view.cr(targetRect);
			
			/*finishAnimation();
			
			var dd:DataView = new DataView(targetRect, _dataBounds);
			var dv:DataView = new DataView(targetRect, _viewBounds);
			var ds:Number = dv.scale,
				dx:Number = -a.left*dv.scale,
				dy:Number = -a.top*dv.scale;
			
			trace(dx, dy, ds);

			TweenLite.to(_mapLayer, duration, { 
				x: dx,  
				y: dy, 
				scaleX: ds, 
				scaleY: ds, 
				ease: easingFunc, 
				onComplete: finishAnimation 
			});
			*/
		}
		
		private function finishAnimation():void
		{
			
			//_mapLayer.filters = [];
			cropView(_targetBounds);
			
		}
		private function _animateStep():void
		{
			var r:Rectangle = interpolateRect(viewBounds, _targetBounds, _tweenVars.t);
			cropView(r);
		}
	}
	
	
	
}