package ru.cartoonizer.data 
{
	/**
	 * ...
	 * @author Vyacheslav Makhotkin <retardeddude@gmail.com>
	 */
	public class UserData 
	{
		
		protected var _sex:String = '';
		
		public function UserData() 
		{
			
		}
		
		public function get sex():String {
			return this._sex;
		}
		
		public function set sex(value:String):void {
			this._sex = value;
		}
	}

}