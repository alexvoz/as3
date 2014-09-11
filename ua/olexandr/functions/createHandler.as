package ua.olexandr.functions {
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	
	/**
	 * 
	 * @param	handler
	 * @param	...args
	 * @return
	 */
	public function createHandler(handler:Function, ...args):Function {
		var _handler:Function = function(...innerArgs):void {
			handler.apply(this, innerArgs.concat(args));
		};
		
		return _handler;
	}

}