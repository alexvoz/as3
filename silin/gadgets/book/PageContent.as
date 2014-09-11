/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.gadgets.book
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	

	/**
	 * генерится при ошибке(невозможности) загрузки
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")] 


	/**
	 * генерится при удачном завершении загрузки
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")] 
	
	
	/**
	 * контейнер для контента страниц<br/>
	 * в конструктор передаем  перечислением список елементов (дисплейОбжекты или строка url для внешнего файла) <br/>
	 * загружаемый файл может быть только один
	 * @author silin
	 */
	public class PageContent extends Sprite
	{
		
		private var _url:String;
		private var _loader:Loader;
		private var _preloaderIcon:DisplayObject;
		private var _errorIcon:DisplayObject;
		/**
		 * constructor
		 * список объектов перечислением,<br/> 
		 * из урл загрузки (String) создается лоадер (возможен только один),<br/> 
		 * из BitmapData создается битмап
		 * @param	...arg
		 */
		public function PageContent(...arg)
		{
			
			for (var i:int = 0; i < arg.length; i++) 
			{
				var par:*= arg[i];
				//if (par is URLRequest) par = URLRequest(par).url;
				
				if (par is String)
				{
					addLoader(par);
				}else if (par is BitmapData)
				{
					addChild(new Bitmap(par as BitmapData, PixelSnapping.NEVER, true));
				}else if (par is DisplayObject)
				{
					addChild(par);
				}else
				{
					throw(new Error("невалидный параметр: " + par));
				}
			}
			mouseEnabled = false;
			//mouseChildren = false;
		}
		
		/**
		 * добавляет загрузчик контента из заданного url
		 * @param	url
		 */
		public function addLoader(url:String):void
		{
			if (_loader)
			{
				trace("PageContent поддерживает только одну загрузку: предыдущая похерена");
				return;
				
			}
			_url = url;
			_loader = new Loader();
			_loader.mouseEnabled = false;
			
			addChild(_loader);
			
		}
		
		
		/**
		 * стартует загрузку лоадера (если определен и еще не загружен)
		 * @param	preloader
		 * @param	errorIcon
		 */
		public function load():void
		{
			//если ничего не надо грузить или уже загружено, то ничего и не делаем
			if (!_loader || _loader.content) return;
			
			_loader.load(new URLRequest(_url));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, omSecurityError);
			
		}
		
		private function omSecurityError(evnt:SecurityErrorEvent):void 
		{
			//Console.log( "PageContent.omSecurityError > evnt : " + evnt );
			
		}
		
		
		
		
		/**
		 * центрирует загруженный контент, мчходя из переданных  размеров страницы
		 * @param	w
		 * @param	h
		 */
		public function centerLoaderContent(w:Number, h:Number):void
		{
			try
			{
				if (_loader && _loader.content)
				{
					_loader.x = (w - _loader.contentLoaderInfo.width) / 2;
					_loader.y = (h - _loader.contentLoaderInfo.height) / 2;
				}
			}catch(err:Error){}
			
		}
		
		//окончание звгрузки
		private function onLoadComplete(evnt:Event):void 
		{
			evnt.target.removeEventListener(Event.COMPLETE, onLoadComplete);
			if (_preloaderIcon && _preloaderIcon.parent) {
				removeChild(_preloaderIcon);
				_preloaderIcon = null;
			}
			_errorIcon = null;
			dispatchEvent(evnt);
			try
			{
				if (_loader.content is Bitmap) Bitmap(_loader.content).smoothing = true;
			}catch(err:Error){}
			
			
		}
		//облом загрузки
		private function onLoadError(evnt:IOErrorEvent):void 
		{
			if (_preloaderIcon && _preloaderIcon.parent) {
				removeChild(_preloaderIcon);
				_preloaderIcon = null;
			}
			if(_errorIcon) addChild(_errorIcon);
			dispatchEvent(evnt);
		}
		
		/**
		 * урл загрузки
		 */
		public function get url():String { return _url; }
		
		public function get preloaderIcon():DisplayObject { return _preloaderIcon; }
		
		public function set preloaderIcon(value:DisplayObject):void 
		{
			_preloaderIcon = value;
			addChild(_preloaderIcon);
		}
		
		public function get errorIcon():DisplayObject { return _errorIcon; }
		
		public function set errorIcon(value:DisplayObject):void 
		{
			_errorIcon = value;
		}
		

	}

}
