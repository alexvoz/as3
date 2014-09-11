package silin.audio.equalizers 
{
	import silin.audio.equalizers.Equalizer;
	
	/**
	 * ...
	 * @author silin
	 */
	public class ShapeEqualizer extends Equalizer 
	{
		/**
		 * цвет заливки 
		 */
		public var color:int = 0x808080;
		/**
		 * минмиамльный размер
		 */
		public var minSize:Number = 1;
		/**
		 * максимальный размер
		 */
		public var maxSize:Number = 80;
		
		
		public function ShapeEqualizer(bands:uint=8) 
		{
			super(bands);
		}
		
	}

}