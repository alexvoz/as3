package ua.olexandr.structures {
	
	/**
	 * ...
	 * @author gka
	 */
	public class Resource {
		
		private var _url:String;
		private var _content:*;
		
		public function Resource(url:String, content:*) {
			_url = url;
			_content = content;
		}
		
		public function get url():String { return _url; }
		public function get content():* { return _content; }
	
	}

}