package ua.olexandr.functions {
	import flash.net.LocalConnection;
	
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	
	/**
	 * 
	 */
	public function gc():void {
		try {
			new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
		} catch (e:Error){
			//trace(e.message);
		}
	}

}