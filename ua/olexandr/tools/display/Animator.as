package ua.olexandr.tools.display  {
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class Animator /*extends DisplayObject*/ {
		
		/**
		 * 
		 */
		public static var defaultTransition    :Function = Equations.easeNone;
		/**
		 * 
		 */
		public static var defaultTransitionIn  :Function = Equations.easeInSine;
		/**
		 * 
		 */
		public static var defaultTransitionOut :Function = Equations.easeOutSine;
		
		/**
		 * 
		 */
		public static var defaultTimeIn        :Number = .2;
		/**
		 * 
		 */
		public static var defaultTimeOut       :Number = .3;
		
		/**
		 * 
		 * @param	target
		 * @param	parent
		 * @param	params
		 * @return
		 */
		public static function showByAlpha(target:DisplayObject, parent:DisplayObjectContainer = null, params:Object = null):Animator {
			var _anim:Animator = new Animator();
			
			if (!params)							params = { };
			if (params.transition == undefined) 	params.transition = defaultTransitionOut;
			if (params.time == undefined)			params.time = defaultTimeIn;
			if (params.alpha == undefined)			params.alpha = 1;
			
			if (parent && target)
				parent.addChild(target);
			
			params.onComplete = function():void {
				if (_anim.onComplete != null)
					_anim.onComplete();
			}
			
			params.onUpdate = function():void {
				if (_anim.onUpdate != null)
					_anim.onUpdate();
			}
			
			Tweener.addTween(target, params);
			
			return _anim;
		}
		
		/**
		 * 
		 * @param	child
		 * @param	parent
		 * @param	params
		 * @return
		 */
		public static function hideByAlpha(child:DisplayObject, parent:DisplayObjectContainer = null, params:Object = null):Animator {
			var _anim:Animator = new Animator();
			
			if (!params)							params = { };
			if (params.transition == undefined) 	params.transition = defaultTransitionIn;
			if (params.time == undefined)			params.time = defaultTimeOut;
			if (params.alpha == undefined)			params.alpha = 0;
			
			params.onComplete = function():void {
				if (parent && child && child.parent === parent)
					parent.removeChild(child);
				if (_anim.onComplete != null) _anim.onComplete();
			}
			
			params.onUpdate = function():void {
				if (_anim.onUpdate != null) _anim.onUpdate();
			}
			
			Tweener.addTween(child, params);
			
			return _anim;
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	point
		 * @param	params
		 * @return
		 */
		public static function moveToPoint(target:DisplayObject, point:Point, params:Object = null):Animator {
			var _anim:Animator = new Animator();
			
			if (!params)							params = { };
			if (params.transition == undefined) 	params.transition = defaultTransitionOut;
			if (params.time == undefined)			params.time = defaultTimeIn;
			if (params.x == undefined)				params.x = point.x;
			if (params.y == undefined)				params.y = point.y;
			
			params.onComplete = function():void {
				if (_anim.onComplete != null)
					_anim.onComplete();
			}
			
			params.onUpdate = function():void {
				if (_anim.onUpdate != null)
					_anim.onUpdate();
			}
			
			Tweener.addTween(target, params);
			
			return _anim;
		}
		
		
		/**
		 * 
		 */
		public var onComplete:Function;
		/**
		 * 
		 */
		public var onUpdate:Function;
		
		/**
		 * 
		 */
		public function Animator():void {
			
		}
		
	}

}