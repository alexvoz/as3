/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * принудительный вызов GC
	 * @author silin
	 */
	public class GarbageCollector
	{
		//лоадер
		private static const LOADER:Loader = new Loader();
		//'пустой' gif
		private static const GIF:Array = [
			71, 73, 70, 56, 57, 97, 1, 0, 1, 0, -128, 0, 0, -1, -1, -1, 0, 0, 0, 33, 
			-7, 4, 0, 7, 0, -1, 0, 44, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 2, 68, 1, 0, 59
		];

		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function GarbageCollector() 
		{
			throw(new Error("GarbageCollector is a static class and should not be instantiated."))
		}
		/**
		 * провоцирует запуск GC за счет загрузки и unloadAndStop() 'пустой' картинки
		 */
		public static function force():void
		{
			
			LOADER.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplteteHandler);
			
			var ba:ByteArray = new ByteArray();
			for (var i:int = 0; i < GIF.length; i++) 
			{
				ba.writeByte(GIF[i]);
			}
			LOADER.loadBytes(ba);
		}
		private static function loaderComplteteHandler(evnt:Event):void 
		{
			LOADER.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplteteHandler);
			try 
			{
				LOADER.unloadAndStop();
			}catch (err:Error) 
			{ 
				throw(new Error( "GarbageCollector.force: FP10+ is required" ));
			}
		}
	}

}