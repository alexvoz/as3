package ua.alexvoz.display {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */

	public class Zoomer extends MovieClip {
		public static var STAGE:Stage
		
		public function Zoomer() {
			
		}
		
		static public function moveToPlace(mc:MovieClip, rect:Rectangle = null):void {
			if (rect == null) rect = new Rectangle(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			if (mc.width > rect.width){
				if (mc.x > rect.x) mc.x = rect.x;
				if (mc.x < rect.x - (mc.width - rect.width)) mc.x = rect.x - (mc.width - rect.width);
			} else 	mc.x = rect.x + rect.width / 2 - mc.width / 2;
			if (mc.height > rect.height){
				if (mc.y > rect.y) mc.y = rect.y;
				if (mc.y < rect.y - (mc.height - rect.height)) mc.y = rect.y - (mc.height - rect.height);
			} else mc.y = rect.y +  rect.height / 2 - mc.height / 2;
		}
		
		static public function moveToCentre(mc:MovieClip, rect:Rectangle = null, tween:Boolean = false):void {
			if (rect == null) rect = new Rectangle(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			if (tween) {
				Tweener.addTween(mc, { x:(rect.x + rect.width / 2 - mc.width / 2), y:(rect.y + rect.height / 2 - mc.height / 2), time:1 } )
			} else {
				mc.x = rect.x + rect.width / 2 - mc.width / 2;
				mc.y = rect.y + rect.height / 2 - mc.height / 2;
			}
		}
		
		/**
		 * Задает Масштаб мувиклипу
		 * @param	mc - мувиклип для масштабирования
		 * @param	size - 'min'/'max' - вписать или описать мувик в область отображения
		 * @param	scale - нужный масштаб
		 * @param	tween - аминирование масштабирования
		 * @param	centrToCur - считать ли центром масштабирования координаты курсора
		 * @param	moveToCur - двигать ли центр масштабирования в центр области отображения
		 * @param	rect - область отображения (по ум. размер stage)
		 * @param	centerX - центр масштабирования по Х
		 * @param	centerY - центр масштабирования по Y
		 */
		static public function changeScale(mc:MovieClip, size:String = 'max', scale:Number = 1, rect:Rectangle = null, tween:Boolean = false, centrToCur:Boolean = false, moveToCur:Boolean = false, centerX:Number = -1000, centerY:Number = -1000):void {
			if (rect == null) rect = new Rectangle(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			if (centerX == -1000) centerX = rect.x + rect.width / 2;
			if (centerY == -1000) centerY = rect.y + rect.height / 2;
			var _globalScale:Number;
			if (size == 'max') _globalScale = Math.max((rect.width) / (mc.width / mc.scaleX), (rect.height) / (mc.height / mc.scaleY));
			if (size == 'min') _globalScale = Math.min((rect.width) / (mc.width / mc.scaleX), (rect.height) / (mc.height / mc.scaleY));
			var _scale:Number = _globalScale * scale;
			var _origW:Number = mc.width / mc.scaleX;
			var _origH:Number = mc.height / mc.scaleY;
			var _needW:Number = _origW * _scale;
			var _needH:Number = _origH * _scale;
			if (centrToCur){
				centerX = STAGE.mouseX; 
				centerY = STAGE.mouseY;
			} 
			var _needX:Number = centerX - ((centerX - mc.x) / mc.scaleX * _scale);
			var _needY:Number = centerY - ((centerY - mc.y) / mc.scaleY * _scale);
			if (moveToCur) {
				_needX += (rect.x + rect.width / 2 - STAGE.mouseX);
				_needY += (rect.y + rect.height / 2 - STAGE.mouseY);
			}
			if (tween) {
				Tweener.addTween(mc, { width:_needW, height:_needH, x:_needX, y:_needY, time:1, onUpdate:function():void { moveToPlace(mc, rect) } } );
			} else {
				mc.width = _needW;
				mc.height = _needH;
				mc.x = _needX;
				mc.y = _needY;
				moveToPlace(mc, rect);
			}
			
		}
		
		static public function zoomToObject(mc:MovieClip, container:MovieClip, size:Number = 1, rect:Rectangle = null, tween:Boolean = false):void {
			if (rect == null) rect = new Rectangle(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			var _scale:Number = Math.min((rect.width * size) / mc.width, (rect.height * size) / mc.height);
			var _x:Number = rect.width / 2 - ((mc.x + mc.width / 2) * _scale);
			var _y:Number = rect.height / 2 - ((mc.y + mc.height / 2) * _scale);
			if (tween) {
				Tweener.addTween(container, { x:_x, y:_y, scaleX:_scale, scaleY:_scale, time:1 } )
			} else {
				container.x = _x;
				container.y = _y;
				container.scaleX = container.scaleY = _scale;
			}
		}
		
	}

}