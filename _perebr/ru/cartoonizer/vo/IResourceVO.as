package ru.cartoonizer.vo 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public interface IResourceVO 
	{
		function get id():uint;
		function set id(value:uint):void;
		function get weight():uint;
		function get icons():Object;
	}
	
}