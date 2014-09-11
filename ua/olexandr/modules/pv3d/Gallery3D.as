package ua.olexandr.modules.pv3d {
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import ua.olexandr.events.AnimationEvent;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	[Event(name="start", type="ua.olexandr.events.AnimationEvent")]
	[Event(name="end", type="ua.olexandr.events.AnimationEvent")]
	public class Gallery3D extends Sprite {
		
		private var _pause:Boolean;
		private var _animation:Boolean;
		
		private var _width:Number;
		private var _height:Number;
		private var _list:Array;
		private var _count:int;
		
		private var _step:Number;
		private var _current:Number;
		private var _rotationY:Number
		
		private var _scene:Scene3D;
		private var _viewport:Viewport3D;
		private var _camera:Camera3D;
		private var _renderEngine:BasicRenderEngine;
		
		private var _content:DisplayObject3D;
		
		/**
		 * 
		 * @param	w
		 * @param	h
		 * @param	list
		 */
		public function Gallery3D(w:Number, h:Number, list:Array) {
			
			_pause 			= false;
			_animation		= false;
			
			_width 			= w;
			_height 		= h;
			_list 			= list;
			_count 			= _list.length;
			
			_step			= 360 / _count;
			_current		= 0;
			
			_scene 			= new Scene3D();
			_viewport 		= new Viewport3D(_width, _height, false, true);
			_camera 		= new Camera3D();
			_renderEngine 	= new BasicRenderEngine();
			_content 		= new DisplayObject3D();
			
			for (var i:int = 0; i < _count; i++) {
				var _material:MovieMaterial = new MovieMaterial(list[i]);
				_material.oneSide = false;
				_material.smooth = true;
				_material.tiled = true;
				var _plane:Plane = new Plane(_material, 0, 0, 4, 4);
				
				var _angle:Number = _step * i;
				var _angleA:Number = _angle + 180;
				var _angleB:Number = 90 - _angleA;
				
				var _sideC:Number = _width * .85;
				var _sideA:Number = _sideC * Math.sin(_angleA / 180 * Math.PI);
				var _sideB:Number = _sideC * Math.sin(_angleB / 180 * Math.PI);
				
				_plane.rotationY = _angle;
				_plane.x = _sideA;
				_plane.z = _sideB;
				
				_content.addChild(_plane);
			}
			
			_scene.addChild(_content);
			_camera.z = -825;
			
			tweenUpdate();
			tweenComplete();
			
			addChild(_viewport);
		}
		
		/**
		 * 
		 */
		public function get current():Number { 
			return (_current + _count - 1) % _count;
		}
		
		/**
		 * 
		 */
		public function get pause():Boolean { return _pause; }
		/**
		 * 
		 */
		public function set pause(value:Boolean):void { 
			_pause = value;
			if (!_pause) tweenStart(1);
		}
		
		/**
		 * 
		 */
		public function get animation():Boolean { return _animation; }
		
		
		private function tweenStart(seconds:Number):void {
			setTimeout(function():void {
				if (!_pause) {
					_animation = true;
					dispatchEvent(new AnimationEvent(AnimationEvent.START));
					
					Tweener.addTween(_content, { 	localRotationY:_rotationY, time:3, 
													onUpdate:tweenUpdate, onComplete:tweenComplete } );
				}
			}, seconds * 1000);
		}
		
		private function tweenStop():void {
			Tweener.removeTweens(_content);
		}
		
		private function tweenComplete():void {
			_animation = false;
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
			
			_rotationY = (_current + 1) * _step;
			_current = (_current + 1) % _count;
			
			if (_content.localRotationY >= 360) 
				_content.localRotationY = _content.localRotationY % 360;
			
			if (!_pause) tweenStart(2);
		}
		
		private function tweenUpdate():void {
			_renderEngine.renderScene(_scene, _camera, _viewport);
		}
		
	}
}