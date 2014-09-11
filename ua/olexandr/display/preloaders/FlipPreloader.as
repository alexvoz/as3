package ua.olexandr.display.preloaders {  
	import flash.display.Shape;
	import ua.olexandr.tools.tweener.Easing;
	import ua.olexandr.tools.tweener.Tweener;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.2
	 */
	
	public class FlipPreloader extends BasePreloader {  
		
		private var _item:Shape;
		
		/**
		 * 
		 * @param	color
		 * @param	size
		 */
		public function FlipPreloader(color:uint = 0xFFFFFF, alpha:Number = 1, size:int = 50) {
			super(false);
			
			_item = new Shape();
			_item.graphics.beginFill(color, alpha);
			_item.graphics.drawRect(-size * .5, -size * .5, size, size);
			_item.graphics.endFill();
			
			_holder.addChild(_item);
		}  
		
		override protected function startIn():void {
			if (_item.rotationX == 0)
				tweenX();
		}
		
		
		private function tweenX():void {
			if (_animating) {
				_item.rotationY = 0;
				Tweener.addTween(_item, .5, { rotationX:180, ease:Easing.sineIn, onComplete:tweenY } );
			}
		}
		
		private function tweenY():void {
			_item.rotationX = 0;
			Tweener.addTween(_item, .5, { rotationY:180, ease:Easing.sineOut, onComplete:tweenX } );
		}
		
		
   }  
}  