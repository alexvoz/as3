package ua.olexandr.tools.loader.loaders {
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	[Event(name="start", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="init", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="success", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="finish", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="fail", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	[Event(name="progress", type="ua.olexandr.tools.loader.events.LoaderEvent")]
	public interface ILoader extends IEventDispatcher {
		
		function load():void;
		
		function close():void;
		
		function destroy():void;
		
		function isRunning():Boolean;
		
		function get request():URLRequest;
		
		function get bytesLoaded():uint;
		function get bytesTotal():uint;
		function get percentage():Number;
		
		function get content():*
		function get error():String;
		
	}
	
}