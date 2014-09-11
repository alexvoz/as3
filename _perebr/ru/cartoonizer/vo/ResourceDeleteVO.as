package ru.cartoonizer.vo 
{
	import flash.display.Bitmap;
	import ru.scarbo.data.ClassLibrary;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ResourceDeleteVO implements IResourceVO 
	{
		
		public function get icons():Object 
		{
			return { 0:ClassLibrary.getDisplayObject('DeleteButtonSkin') };
		}
		
		public function get id():uint { return 0; }
		public function set id(value:uint):void { }
		public function get weight():uint { return 0; }
		
	}

}