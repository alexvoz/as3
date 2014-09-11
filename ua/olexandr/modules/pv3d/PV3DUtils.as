package ua.olexandr.modules.pv3d {
	import org.papervision3d.cameras.Camera3D;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class PV3DUtils {
		
		/**
		 * @usage 	yourobject.z = (camera.zoom  * camera.focus) - Math.abs(camera.z);
		 * @param	$camera
		 * @return
		 */
		public static function pixelPerfect($camera:Camera3D):Number {
			return ($camera.zoom  * $camera.focus) - Math.abs($camera.z);
		}
		
	}

}