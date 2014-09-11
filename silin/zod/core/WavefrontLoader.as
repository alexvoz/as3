/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;

	/**
	 * загрузчик текстутры и Wavefront OBJ файла,<br/>
	 * по завершении загрузки создает WavefrontModel
	 * @author silin
	 */
	
	
	 
	public class WavefrontLoader extends EventDispatcher
	{
		/**
		 * диспатчим после загрузки файлов и создания модели
		 * @eventType flash.events.Event.COMPLETE
		 */
		[Event(name = "complete", type = "flash.events.Event")]
		/**
		 * диспатчим при невозможности загрузки
		 * @eventType flash.events.IOErrorEvent.IO_ERROR
		 */
		[Event(name = "ioError", type = "flash.events.IOErrorEvent")]  
		
		private var _model:WavefrontModel;
		private var _objLoader:URLLoader = new URLLoader();
		private var _textureLoader:Loader = new Loader();
		private var _loadCounter:int = 0;
		

		
		
		/**
		 * constructor
		 */
		public function WavefrontLoader()
		{
			_objLoader.addEventListener(Event.COMPLETE, onLoaded);
			_objLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);

			_textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_textureLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		/**
		 * стартует загрузку файлов модели и текcтуры,<br/>
		 * по завершении загрузки создает модель
		 * @param	objUrl
		 * @param	textureUrl
		 */
		public function load(objUrl:String, textureUrl:String=null):void
		{
			_textureLoader.unload();
			if (textureUrl) _textureLoader.load(new URLRequest(textureUrl));
			
			_objLoader.load(new URLRequest(objUrl));
			_loadCounter = textureUrl ? 0 : 1;
			_model = null;
		}

		/**
		 * модель
		 */
		public function get model():WavefrontModel { return _model; }

		private function onError(evnt:IOErrorEvent):void
		{
			//dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			dispatchEvent(evnt);
		}

		private function onLoaded(evnt:Event):void
		{
			if (++_loadCounter == 2)
			{
				var mat:DrawableMaterial = _textureLoader.content ? new DrawableMaterial(_textureLoader.content) : null;
				_model = new WavefrontModel(mat, _objLoader.data);
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
		}


	}

}
