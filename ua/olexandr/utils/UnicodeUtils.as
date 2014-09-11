package ua.olexandr.utils {
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class UnicodeUtils {
		
		//public static const GRAVE_ACCENT:int = 0x0300;
		/**
		 * Ударение
		 */
		public static const ACUTE_ACCENT:int = 0x0301;
		/**
		 * Циркумфлекс
		 */
		public static const CIRCUMFLEX_ACCENT:int = 0x0302;
		/**
		 * Тильда
		 */
		public static const TILDE:int = 0x0303;
		//public static const MACRON:int = 0x0304;
		//public static const OVERLINE:int = 0x0305;
		//public static const BREVE:int = 0x0306;
		//public static const DOT_ABOVE:int = 0x0307;
		//public static const DIAERESIS:int = 0x0308;
		//public static const HOOK_ABOVE:int = 0x0309;
		//public static const RING_ABOVE:int = 0x030A;
		//public static const DOUBLE_ACUTE_ACCENT:int = 0x030B;
		//public static const CARON:int = 0x030C;
		//public static const VERTICAL_LINE_ABOVE:int = 0x030D;
		//public static const DOUBLE_VERTICAL_LINE_ABOVE:int = 0x030E;
		//public static const DOUBLE_GRAVE_ACCENT:int = 0x030F;
		//public static const CANDRABINDU:int = 0x0310;
		//public static const INVERTED_BREVE:int = 0x0311;
		//public static const TURNED_COMMA_ABOVE:int = 0x0312;
		//public static const COMMA_ABOVE:int = 0x0313;
		//public static const REVERSED_COMMA_ABOVE:int = 0x0314;
		//public static const COMMA_ABOVE_RIGHT:int = 0x0315;
		//public static const GRAVE_ACCENT_BELOW:int = 0x0316;
		//public static const ACUTE_ACCENT_BELOW:int = 0x0317;
		//public static const LEFT_TACK_BELOW:int = 0x0318;
		//public static const RIGHT_TACK_BELOW:int = 0x0319;
		//public static const LEFT_ANGLE_ABOVE:int = 0x031A;
		//public static const HORN:int = 0x031B;
		//public static const LEFT_HALF_RING_BELOW:int = 0x031C;
		//public static const UP_TACK_BELOW:int = 0x031D;
		//public static const DOWN_TACK_BELOW:int = 0x031E;
		//public static const PLUS_SIGN_BELOW:int = 0x031F;
		//public static const MINUS_SIGN_BELOW:int = 0x0320;
		//public static const PALATALIZED_HOOK_BELOW:int = 0x0321;
		//public static const RETROFLEX_HOOK_BELOW:int = 0x0322;
		//public static const DOT_BELOW:int = 0x0323;
		//public static const DIAERESIS_BELOW:int = 0x0324;
		//public static const RING_BELOW:int = 0x0325;
		//public static const COMMA_BELOW:int = 0x0326;
		//public static const CEDILLA:int = 0x0327;
		//public static const OGONEK:int = 0x0328;
		//public static const VERTICAL_LINE_BELOW:int = 0x0329;
		//public static const BRIDGE_BELOW:int = 0x032A;
		//public static const INVERTED_DOUBLE_ARCH_BELOW:int = 0x032B;
		//public static const CARON_BELOW:int = 0x032C;
		//public static const CIRCUMFLEX_ACCENT_BELOW:int = 0x032D;
		//public static const BREVE_BELOW:int = 0x032E;
		//public static const INVERTED_BREVE_BELOW:int = 0x032F;
		//public static const TILDE_BELOW:int = 0x0330;
		//public static const MACRON_BELOW:int = 0x0331;
		/**
		 * Низкая линия, подчеркивание
		 */
		public static const LOW_LINE:int = 0x0332;
		//public static const DOUBLE_LOW_LINE:int = 0x0333;
		//public static const TILDE_OVERLAY:int = 0x0334;
		//public static const SHORT_STROKE_OVERLAY:int = 0x0335;
		/**
		 * Длинная черта перекрытая, зачеркивание
		 */
		public static const LONG_STROKE_OVERLAY:int = 0x0336;
		//public static const SHORT_SOLIDUS_OVERLAY:int = 0x0337;
		//public static const LONG_SOLIDUS_OVERLAY:int = 0x0338;
		//public static const RIGHT_HALF_RING_BELOW:int = 0x0339;
		//public static const INVERTED_BRIDGE_BELOW:int = 0x033A;
		//public static const SQUARE_BELOW:int = 0x033B;
		//public static const SEAGULL_BELOW:int = 0x033C;
		//public static const X_ABOVE:int = 0x033D;
		//public static const VERTICAL_TILDE:int = 0x033E;
		//public static const DOUBLE_OVERLINE:int = 0x033F;
		//public static const GRAVE_TONE_MARK:int = 0x0340;
		//public static const ACUTE_TONE_MARK:int = 0x0341;
		//public static const GREEK_PERISPOMENI:int = 0x0342;
		//public static const GREEK_KORONIS:int = 0x0343;
		//public static const GREEK_DIALYTIKA_TONOS:int = 0x0344;
		//public static const GREEK_YPOGEGRAMMENI:int = 0x0345;
		//public static const BRIDGE_ABOVE:int = 0x0346;
		//public static const EQUALS_SIGN_BELOW:int = 0x0347;
		//public static const DOUBLE_VERTICAL_LINE_BELOW:int = 0x0348;
		//public static const LEFT_ANGLE_BELOW:int = 0x0349;
		//public static const NOT_TILDE_ABOVE:int = 0x034A;
		//public static const HOMOTHETIC_ABOVE:int = 0x034B;
		//public static const ALMOST_EQUAL_TO_ABOVE:int = 0x034C;
		//public static const LEFT_RIGHT_ARROW_BELOW:int = 0x034D;
		//public static const UPWARDS_ARROW_BELOW:int = 0x034E;
		//public static const GRAPHEME_JOINER:int = 0x034F;
		//public static const RIGHT_ARROWHEAD_ABOVE:int = 0x0350;
		//public static const LEFT_HALF_RING_ABOVE:int = 0x0351;
		//public static const FERMATA:int = 0x0352;
		//public static const X_BELOW:int = 0x0353;
		//public static const LEFT_ARROWHEAD_BELOW:int = 0x0354;
		//public static const RIGHT_ARROWHEAD_BELOW:int = 0x0355;
		//public static const RIGHT_ARROWHEAD_AND_UP_ARROWHEAD_BELOW:int = 0x0356;
		//public static const RIGHT_HALF_RING_ABOVE:int = 0x0357;
		//public static const DOT_ABOVE_RIGHT:int = 0x0358;
		//public static const ASTERISK_BELOW:int = 0x0359;
		//public static const DOUBLE_RING_BELOW:int = 0x035A;
		//public static const ZIGZAG_ABOVE:int = 0x035B;
		//public static const DOUBLE_BREVE_BELOW:int = 0x035C;
		//public static const DOUBLE_BREVE:int = 0x035D;
		//public static const DOUBLE_MACRON:int = 0x035E;
		//public static const DOUBLE_MACRON_BELOW:int = 0x035F;
		//public static const DOUBLE_TILDE:int = 0x0360;
		//public static const DOUBLE_INVERTED_BREVE:int = 0x0361;
		//public static const DOUBLE_RIGHTWARDS_ARROW_BELOW:int = 0x0362;
		//public static const LATIN_SMALL_LETTER_A:int = 0x0363;
		//public static const LATIN_SMALL_LETTER_E:int = 0x0364;
		//public static const LATIN_SMALL_LETTER_I:int = 0x0365;
		//public static const LATIN_SMALL_LETTER_O:int = 0x0366;
		//public static const LATIN_SMALL_LETTER_U:int = 0x0367;
		//public static const LATIN_SMALL_LETTER_C:int = 0x0368;
		//public static const LATIN_SMALL_LETTER_D:int = 0x0369;
		//public static const LATIN_SMALL_LETTER_H:int = 0x036A;
		//public static const LATIN_SMALL_LETTER_M:int = 0x036B;
		//public static const LATIN_SMALL_LETTER_R:int = 0x036C;
		//public static const LATIN_SMALL_LETTER_T:int = 0x036D;
		//public static const LATIN_SMALL_LETTER_V:int = 0x036E;
		//public static const LATIN_SMALL_LETTER_X:int = 0x036F;
		
		/**
		 * 
		 * @param	str
		 * @param	code
		 * @param	start
		 * @param	len
		 * @return
		 * @see 	http://unicode-table.com/ru/#combining-diacritical-marks
		 */
		public static function addCombiningChar(str:String, code:uint, start:int = 0, len:int = int.MAX_VALUE):String {
			if (code >= 0x0300 && code <= 0x036F) {
				return str.split("").map(function(element:*, index:int, arr:Array):* {
					if (element is String && index >= start && index < start + len)
						return (element as String) + String.fromCharCode(code);
					return element;
				}).join("");
			}
			
			return str;
		}
		
	}

}