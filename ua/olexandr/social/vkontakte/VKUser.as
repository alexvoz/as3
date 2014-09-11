package ua.olexandr.social.vkontakte {
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class VKUser{
		
		public var uid			:String = '';
		public var first_name	:String = '';
		public var last_name	:String = '';
		public var nickname		:String = '';
		public var sex			:String = '';
		public var bdate		:String = '';
		public var city			:String = '';
		public var country		:String = '';
		public var timezone		:String = '';
		public var photo		:String = '';
		public var photo_medium	:String = '';
		public var photo_big	:String = '';
		public var has_mobile	:String = '';
		public var rate			:String = '';
		
		/**
		 * 
		 * @param	$data
		 */
		public function VKUser($data:XML = null) {
			if ($data) {
				uid = 				String($data.user.uid.text());
				first_name = 		String($data.user.first_name.text());
				last_name = 		String($data.user.last_name.text());
				if ($data.user.hasOwnProperty('nickname'))
					nickname = 		String($data.user.nickname.text());
				if ($data.user.hasOwnProperty('sex'))
					sex = 			String($data.user.sex.text());
				if ($data.user.hasOwnProperty('bdate'))
					bdate = 		String($data.user.bdate.text());
				if ($data.user.hasOwnProperty('city'))
					city = 			String($data.user.city.text());
				if ($data.user.hasOwnProperty('country'))
					country = 		String($data.user.country.text());
				if ($data.user.hasOwnProperty('timezone'))
					timezone = 		String($data.user.timezone.text());
				if ($data.user.hasOwnProperty('photo'))
					photo = 		String($data.user.photo.text());
				if ($data.user.hasOwnProperty('photo_medium'))
					photo_medium = 	String($data.user.photo_medium.text());
				if ($data.user.hasOwnProperty('photo_big'))
					photo_big = 	String($data.user.photo_big.text());
				if ($data.user.hasOwnProperty('has_mobile'))
					has_mobile = 	String($data.user.has_mobile.text());
				if ($data.user.hasOwnProperty('rate'))
					rate = 			String($data.user.rate.text());
			}
		}
		
	}

}