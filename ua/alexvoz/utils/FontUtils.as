package ua.alexvoz.utils {
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	public class FontUtils {
		public static const NUMBER_CHARS:String = "U+0030-U+0039"; // 0-9
		public static const MATH_CHARS:String = "U+0030-U+0039, U+0025, U+002A-U+002E, U+003D"; // 0-9 + %*+,-./=
		public static const LATIN_A_TO_Z:String = "U+0041-U+005A"; // A-Z
		public static const LATIN_a_TO_z:String = "U+0061-U+007A"; // a-z
		public static const LATIN:String = LATIN_A_TO_Z + ", " + LATIN_a_TO_z; //A-Z + a-z
		public static const PUNCTUATION:String = "U+0021-U+007E, U+2116, U+2014"; // !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~№—
		public static const CYRILLIC_A_TO_YA:String = "U+0410-U+042F, U+0401, U+0406, U+0407 U+0404"; // А-Я, ЁІЇЄ
		public static const CYRILLIC_a_TO_ya:String = "U+0430-U+044F, U+0451, U+0456, U+0457, U+0454"; // а-я, ёіїє
		public static const CYRILLIC:String = CYRILLIC_A_TO_YA + ", " + CYRILLIC_a_TO_ya; // А-Я + а-я
	}



}