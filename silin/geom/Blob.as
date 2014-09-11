package  silin.geom
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author silin
	 */
	public class Blob 
	{
		public var iterations:int = 16;
		public var controlPoints:Array/*Point*/;
		private var _splinePoints:Array/*Point*/;
		
		public function Blob(controlPonts:Array/*Point*/= null, iterations:int = 16) 
		{
			this.controlPoints = controlPoints;
			this.iterations = iterations;
		}
		private function calc():void
		{
			var i:int;
			var _splinePoints:Array = [];
			var len:int = controlPoints.length;
			
			
			
			var step:Number = 1 / iterations;
			for (i = 0; i < len; i++)
			{ 
				var p0:Point = controlPoints[i];
				var p1:Point = controlPoints[(i + 1) % controlPoints.length];
				var p2:Point = controlPoints[(i + 2) % controlPoints.length];
				var p3:Point = controlPoints[(i + 3) % controlPoints.length];
				
				
				for (var t:Number = 0; t < 1; t += step)
				{ 	
					
					var t2:Number = t * t;
					var t3:Number = t2 * t;
					var tX:Number = 0.5 * ((2 * p1.x) + ( -p0.x + p2.x) * t + 
									(2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 + 
									( -p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3);
					var tY:Number = 0.5 * ((2 * p1.y) + ( -p0.y + p2.y) * t + 
									(2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 + 
									( -p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3);
					_splinePoints.push(new Point(tX, tY));
				}
			}
			
			tX = 0.5 * ((2 * p1.x) + ( -p0.x + p2.x) + 
				(2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) + 
				( -p0.x + 3 * p1.x - 3 * p2.x + p3.x));
			tY = 0.5 * ((2 * p1.y) + ( -p0.y + p2.y) + 
				(2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) + 
				( -p0.y + 3 * p1.y - 3 * p2.y + p3.y));
			_splinePoints.push(new Point(tX, tY));
				
		}
		
		
		
		
		
	}

}