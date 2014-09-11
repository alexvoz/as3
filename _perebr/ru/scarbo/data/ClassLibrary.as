package ru.scarbo.data 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author ...
	 */
	public class ClassLibrary 
	{
		protected static var _inited:Boolean = false;
		protected static var _appDomain:ApplicationDomain;
		
		static public function init(appDomain:ApplicationDomain):void {
			if (!ClassLibrary._inited) {
				ClassLibrary._appDomain = appDomain;
				ClassLibrary._inited = true;
			}
		}
		
		static public function getClass(name:String):Class {
			return ClassLibrary._inited ? ClassLibrary._appDomain.getDefinition(name) as Class : null;
		}
		static public function getBitmapData(name:String):BitmapData {
			var className:Class = ClassLibrary.getClass(name) as Class;
			return (className != null) ? new className(0, 0) as BitmapData : null;
		}
		static public function getDisplayObject(name:String):DisplayObject {
			var className:Class = ClassLibrary.getClass(name) as Class;
			return (className != null) ? new className() as DisplayObject : null;
		}
		static public function getClassObject(name:String):Object {
			var className:Class = ClassLibrary.getClass(name) as Class;
			return (className != null) ? new className() as Object : null;
		}
	}

}