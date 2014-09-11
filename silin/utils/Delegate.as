package silin.utils
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author silin
	 */
	public class Delegate
	{
		public static var bank:Dictionary = new Dictionary();
		public function Delegate()
		{
			throw(new Error("Delegate is a static class and should not be instantiated."));
		}
		/**
		 * функция с добавочными аргументами
		 * @param	handler
		 * @param	... args
		 * @return
		 */
		public static function create(handler:Function, ... args):Function
		{
			var res:Function = function(... innerArgs):void
			{
				handler.apply(null, innerArgs.concat(args));
			}
			bank[res] = handler;
			return res;
		}
		
	}

}