package ua.olexandr.functions {
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	
	/**
	 * 
	 * @param	func
	 * @param	count
	 * @return
	 */
	public function getExecutionTime(func:Function, count:uint):int {
		var _time:int = getTimer();
		
		while(count--)
			func();
		
		return getTimer() - _time;
	}
		

}