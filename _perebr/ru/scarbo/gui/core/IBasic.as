package ru.scarbo.gui.core 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public interface IBasic extends IEventDispatcher
	{
		function set name(name:String):void;
		function get name():String;
		function set x(x:Number):void;
		function get x():Number;
		function set y(y:Number):void;
		function get y():Number;
		function get width():Number;
		function get height():Number;
		function set scaleX(scaleX:Number):void;
		function get scaleX():Number;
		function set scaleY(scaleY:Number):void;
		function get scaleY():Number;
		function set visible(visible:Boolean):void;
		function get visible():Boolean;
		function set alpha(alpha:Number):void;
		function get alpha():Number;
		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;
		function get stage():Stage;
		
		function addChild(child:DisplayObject):DisplayObject;
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		function removeChild(child:DisplayObject):DisplayObject;
		function removeChildAt(index:int):DisplayObject;
		function contains(child:DisplayObject):Boolean;
		function getChildAt(index:int):DisplayObject;
		function get parent():DisplayObjectContainer;
		function get numChildren():int;
		
		function setSize(width:int, height:int):void;
	}
	
}