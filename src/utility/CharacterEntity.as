package utility{
	/**
	 * @author Rob Ruchte <a href="rob@thirdpartylabs.com">rob@thirdpartylabs.com</a>
	 *
	 * A static class for encoding and decoding XML and HTML character entities.
	 * Based on an AS2 class from Jim Cheng <a href="jim.cheng@effectiveui.com">jim.cheng@effectiveui.com</a>
	 *
	 */
	public class CharacterEntity {
		private static var instance : CharacterEntity;

		private static var allowInstantiation : Boolean = false;
		private static var initialized : Boolean = false;

		private static var entityMap : Object = new Object();

		private static var xmlEntities : Object = new Object();
		private static var xhtmlEntities : Object = new Object();
		private static var entities : Object = new Object();

		private static var _temp = initialize();

		/**
		 * Constructor
		 * Only valid if called from getInstance()
		 */
		public function CharacterEntity() : void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use CharacterEntity.getInstance() instead of new.");
			}
		}

		/**
		 * Returns an instance of this class, creating it if necessary,
		 * provides Singleton behavior
		 */
		public static function getInstance() : CharacterEntity {
			if (instance == null) {
				allowInstantiation = true;
				instance = new CharacterEntity();
				allowInstantiation = false;
			}

			return instance;
		}

		/**
		 * Decodes character entities in a given string to UTF-8 Unicode equivalents.
		 *
		 * @param	The character entities encoded text to decode.
		 * @param	Whether to only use the XML character entity set or
		 *           the full 252 character HTML entity set.
		 *
		 * @usage    decode('M&yacute; string', true);
		 */
		public static function decode(text : String, xmlOnly : Boolean = false) : String {
			if (xmlOnly)
			{
				return decodeEntityWithTable(text, xmlEntities)
			}
			else
			{
			    return decodeEntityWithTable(text, entities)
			}
		}

		/**
		 * Encodes a Unicode string, transforming characters with character entity
		 * equivalents from their Unicode bytecode to the character entity representation.
		 *
		 * @param	The Unicode text (e.g. Actionscript string) to encode.
		 * @param	Whether to only use the XML character entity set or
		 *           the full 252 character HTML entity set.
		 *
		 * @usage    encode('Â Unicode string', true);
		 */
		public static function encode(text : String, xmlOnly : Boolean = false) : String {
			if (xmlOnly)
			{
				return encodeEntityWithTable(text, xmlEntities);
			}
			else
			{
			    return encodeEntityWithTable(text, entities);
			}
		}

		public static function decodeXHTML(text : String, decodeAmpersands:Boolean=false) : String {
			if (typeof text != 'string') {
				return text;
			}

			//undo flash's ampersand RE-encoding?
			if (decodeAmpersands)
			{
			  text = text.replace(new RegExp("&amp;", "\g"), "&");
			}

			return decodeEntityWithTable(text, xhtmlEntities)
		}

		public static function encodeXHTML(text : String) : String {
			return encodeEntityWithTable(text, xhtmlEntities)
		}



		public static function decodeEntityWithTable(text:String, translationTable:Object):String
		{
			if (typeof text != 'string') {
				return text;
			}
			var i : String;
			text = text.replace(new RegExp("&amp;", "\g"), "&");
			for (i in translationTable) {
				text = text.replace(new RegExp(i, "\g"), translationTable[i]);
			}

			text = decodeNumericReferences(text);

			return text;
		}


		public static function encodeEntityWithTable(text:String, translationTable:Object):String
		{
			if (typeof text != 'string') {
				return text;
			}
			var i : String;
			text = text.replace(new RegExp("&", "\g"), "&amp;");
			for (i in translationTable) {
				text = text.replace(new RegExp(translationTable[i], "\g"), i);
			}
			return text;
		}




		/**
		 * Decodes numeric entity references in a given string to UTF-8 Unicode equivalents.
		 *
		 * @param	The string to decode.
		 *
		 * @usage	decodeNumericReferences('&#0221');
		 */
		public static function decodeNumericReferences(text : String) : String {
			if (typeof text != 'string') {
				return text;
			}

			var output : String = '';
			var lastPosition : Number = 0;
			var cursor : Number = 0;
			var semi : Number;
			var code : String;

			cursor = text.indexOf('&#', 0);

			while (cursor != -1) {
				semi = text.indexOf(';', cursor);
				code = text.substring(cursor + 2, semi);

				output += text.substring(lastPosition, cursor);

				if (code.charAt(0) == 'x') {
					output += String.fromCharCode(parseInt('0' + code, 16));
				} else {
					output += String.fromCharCode(parseInt(code, 10));
				}
				lastPosition = semi + 1;
				cursor = text.indexOf('&#', lastPosition);
			}

			output += text.substr(lastPosition);

			return output;
		}

		/**
		 * Initialization method -- do not call, it is invoked on class initialzation.
		 */
		private static function initialize() {
			if (initialized) return;
			var myInstance : CharacterEntity = getInstance();

			// Specified by XML 1.0
			entityMap['quot'] = 0x0022;	// " quotation mark
			entityMap['apos'] = 0x0027;	// ' apostrophe
			entityMap['lt'] = 0x003C;	// < less-than sign
			entityMap['gt'] = 0x003E;	// > greater-than sign

			// Specified by HTML and XHTML DTDs
			entityMap['nbsp'] = 0x00A0;	//   no-break space
			entityMap['iexcl'] = 0x00A1;	// ¡ inverted exclamation mark
			entityMap['cent'] = 0x00A2;	// ¢ cent sign
			entityMap['pound'] = 0x00A3;	// £ pound sign
			entityMap['curren'] = 0x00A4;	// ¤ currency sign
			entityMap['yen'] = 0x00A5;	// ¥ yen sign
			entityMap['brvbar'] = 0x00A6;	// ¦ broken bar
			entityMap['sect'] = 0x00A7;	// § section sign
			entityMap['uml'] = 0x00A8;	// ¨ diaeresis
			entityMap['copy'] = 0x00A9;	// © copyright sign
			entityMap['ordf'] = 0x00AA;	// ª feminine ordinal indicator
			entityMap['laquo'] = 0x00AB;	// « left-pointing double angle quotation mark
			entityMap['not'] = 0x00AC;	// ¬ not sign
			entityMap['shy'] = 0x00AD;	// ­ soft hyphen
			entityMap['reg'] = 0x00AE;	// ® registered sign
			entityMap['macr'] = 0x00AF;	// ¯ macron
			entityMap['deg'] = 0x00B0;	// ° degree sign
			entityMap['plusmn'] = 0x00B1;	// ± plus-minus sign
			entityMap['sup2'] = 0x00B2;	// ² superscript two
			entityMap['sup3'] = 0x00B3;	// ³ superscript three
			entityMap['acute'] = 0x00B4;	// ´ acute accent
			entityMap['micro'] = 0x00B5;	// µ micro sign
			entityMap['para'] = 0x00B6;	// ¶ pilcrow sign
			entityMap['middot'] = 0x00B7;	// · middle dot
			entityMap['cedil'] = 0x00B8;	// ¸ cedilla
			entityMap['sup1'] = 0x00B9;	// ¹ superscript one
			entityMap['ordm'] = 0x00BA;	// º masculine ordinal indicator
			entityMap['raquo'] = 0x00BB;	// » right-pointing double angle quotation mark
			entityMap['frac14'] = 0x00BC;	// ¼ vulgar fraction one quarter
			entityMap['frac12'] = 0x00BD;	// ½ vulgar fraction one half
			entityMap['frac34'] = 0x00BE;	// ¾ vulgar fraction three quarters
			entityMap['iquest'] = 0x00BF;	// ¿ inverted question mark

			entityMap['Agrave'] = 0x00C0;	// À latin capital letter a with grave
			entityMap['Aacute'] = 0x00C1;	// Á latin capital letter a with acute
			entityMap['Acirc'] = 0x00C2;	// Â latin capital letter a with circumflex
			entityMap['Atilde'] = 0x00C3;	// Ã latin capital letter a with tilde
			entityMap['Auml'] = 0x00C4;	// Ä latin capital letter a with diaeresis
			entityMap['Aring'] = 0x00C5;	// Å latin capital letter a with ring above
			entityMap['AElig'] = 0x00C6;	// Æ latin capital letter ae
			entityMap['Ccedil'] = 0x00C7;	// Ç latin capital letter c with cedilla
			entityMap['Egrave'] = 0x00C8;	// È latin capital letter e with grave
			entityMap['Eacute'] = 0x00C9;	// É latin capital letter e with acute
			entityMap['Ecirc'] = 0x00CA;	// Ê latin capital letter e with circumflex
			entityMap['Euml'] = 0x00CB;	// Ë latin capital letter e with diaeresis
			entityMap['Igrave'] = 0x00CC;	// Ì latin capital letter i with grave
			entityMap['Iacute'] = 0x00CD;	// Í latin capital letter i with acute
			entityMap['Icirc'] = 0x00CE;	// Î latin capital letter i with circumflex
			entityMap['Iuml'] = 0x00CF;	// Ï latin capital letter i with diaeresis
			entityMap['ETH'] = 0x00D0;	// Ð latin capital letter eth
			entityMap['Ntilde'] = 0x00D1;	// Ñ latin capital letter n with tilde
			entityMap['Ograve'] = 0x00D2;	// Ò latin capital letter o with grave
			entityMap['Oacute'] = 0x00D3;	// Ó latin capital letter o with acute
			entityMap['Ocirc'] = 0x00D4;	// Ô latin capital letter o with circumflex
			entityMap['Otilde'] = 0x00D5;	// Õ latin capital letter o with tilde
			entityMap['Ouml'] = 0x00D6;	// Ö latin capital letter o with diaeresis
			entityMap['times'] = 0x00D7;	// × multiplication sign
			entityMap['Oslash'] = 0x00D8;	// Ø latin capital letter o with stroke
			entityMap['Ugrave'] = 0x00D9;	// Ù latin capital letter u with grave
			entityMap['Uacute'] = 0x00DA;	// Ú latin capital letter u with acute
			entityMap['Ucirc'] = 0x00DB;	// Û latin capital letter u with circumflex
			entityMap['Uuml'] = 0x00DC;	// Ü latin capital letter u with diaeresis
			entityMap['Yacute'] = 0x00DD;	// Ý latin capital letter y with acute
			entityMap['THORN'] = 0x00DE;	// Þ latin capital letter thorn
			entityMap['szlig'] = 0x00DF;	// ß latin capital letter sharp s

			entityMap['agrave'] = 0x00E0;	// à latin small letter a with grave
			entityMap['aacute'] = 0x00E1;	// á latin small letter a with acute
			entityMap['acirc'] = 0x00E2;	// â latin small letter a with circumflex
			entityMap['atilde'] = 0x00E3;	// ã latin small letter a with tilde
			entityMap['auml'] = 0x00E4;	// ä latin small letter a with diaeresis
			entityMap['aring'] = 0x00E5;	// å latin small letter a with ring
			entityMap['aelig'] = 0x00E6;	// æ latin small letter ae
			entityMap['ccedil'] = 0x00E7;	// ç latin small letter c with cedilla
			entityMap['egrave'] = 0x00E8;	// è latin small letter e with grave
			entityMap['eacute'] = 0x00E9;	// é latin small letter e with acute
			entityMap['ecirc'] = 0x00EA;	// ê latin small letter e with circumflex
			entityMap['euml'] = 0x00EB;	// ë latin small letter e with diaeresis
			entityMap['igrave'] = 0x00EC;	// ì latin small letter i with grave
			entityMap['iacute'] = 0x00ED;	// í latin small letter i with acute
			entityMap['icirc'] = 0x00EE;	// î latin small letter i with circumflex
			entityMap['iuml'] = 0x00EF;	// ï latin small letter i with diaeresis
			entityMap['eth'] = 0x00F0;	// ð latin small letter eth
			entityMap['ntilde'] = 0x00F1;	// ñ latin small letter n with tilde
			entityMap['ograve'] = 0x00F2;	// ò latin small letter o with grave
			entityMap['oacute'] = 0x00F3;	// ó latin small letter o with acute
			entityMap['ocirc'] = 0x00F4;	// ô latin small letter o with circumflex
			entityMap['otilde'] = 0x00F5;	// õ latin small letter o with tilde
			entityMap['ouml'] = 0x00F6;	// ö latin small letter o with diaeresis
			entityMap['divide'] = 0x00F7;	// ÷ division sign
			entityMap['oslash'] = 0x00F8;	// ø latin small letter o with stroke
			entityMap['ugrave'] = 0x00F9;	// ù latin small letter u with grave
			entityMap['uacute'] = 0x00FA;	// ú latin small letter u with acute
			entityMap['ucirc'] = 0x00FB;	// û latin small letter u with circumflex
			entityMap['uuml'] = 0x00FC;	// ü latin small letter u with diaeresis
			entityMap['yacute'] = 0x00FD;	// ý latin small letter y with acute
			entityMap['thorn'] = 0x00FE;	// þ latin small letter thorn
			entityMap['yuml'] = 0x00FF;	// ÿ latin small letter y with diaeresis
			entityMap['OElig'] = 0x0152;	// Œ latin capital ligature oe
			entityMap['oelig'] = 0x0153;	// œ latin small ligature oe
			entityMap['Scaron'] = 0x0160;	// Š latin capital letter s with caron
			entityMap['scaron'] = 0x0161;	// š latin small letter s with caron
			entityMap['Yuml'] = 0x0178;	// Ÿ latin cpital letter y with diaeresis
			entityMap['fnof'] = 0x0192;	// ƒ latin small letter f with hook
			entityMap['circ'] = 0x02C6;	// ˆ modifier letter circumflex accent
			entityMap['tilde'] = 0x02DC;	// ˜ small tilde

			entityMap['Alpha'] = 0x0391;	// Α greek capital letter alpha
			entityMap['Beta'] = 0x0392;	// Β greek capital letter beta
			entityMap['Gamma'] = 0x0393;	// Γ greek capital letter gamma
			entityMap['Delta'] = 0x0394;	// Δ greek capital letter delta
			entityMap['Epsilon'] = 0x0395;	// Ε greek capital letter epsilon
			entityMap['Zeta'] = 0x0396;	// Ζ greek capital letter zeta
			entityMap['Eta'] = 0x0397;	// Η greek capital letter eta
			entityMap['Theta'] = 0x0398;	// Θ greek capital letter theta
			entityMap['Iota'] = 0x0399;	// Ι greek capital letter iota
			entityMap['Kappa'] = 0x039A;	// Κ greek capital letter kappa
			entityMap['Lambda'] = 0x039B;	// Λ greek capital letter lambda
			entityMap['Mu'] = 0x039C;	// Μ greek capital letter mu
			entityMap['Nu'] = 0x039D;	// Ν greek capital letter nu
			entityMap['Xi'] = 0x039E;	// Ξ greek capital letter xi
			entityMap['Omicron'] = 0x039F;	// Ο greek capital letter omicron
			entityMap['Pi'] = 0x03A0;	// Π greek capital letter pi
			entityMap['Rho'] = 0x03A1;	// Ρ greek capital letter rho
			entityMap['Sigma'] = 0x03A3;	// Σ greek capital letter sigma
			entityMap['Tau'] = 0x03A4;	// Τ greek capital letter tau
			entityMap['Upsilon'] = 0x03A5;	// Υ greek capital letter upsilon
			entityMap['Phi'] = 0x03A6;	// Φ greek capital letter phi
			entityMap['Chi'] = 0x03A7;	// Χ greek capital letter chi
			entityMap['Psi'] = 0x03A8;	// Ψ greek capital letter psi
			entityMap['Omega'] = 0x03A9;	// Ω greek capital letter omega

			entityMap['alpha'] = 0x03B1;	// α greek small letter alpha
			entityMap['beta'] = 0x03B2;	// β greek small letter beta
			entityMap['gamma'] = 0x03B3;	// γ greek small letter gamma
			entityMap['delta'] = 0x03B4;	// δ greek small letter delta
			entityMap['epsilon'] = 0x03B5;	// ε greek small letter epsilon
			entityMap['zeta'] = 0x03B6;	// ζ greek small letter zeta
			entityMap['eta'] = 0x03B7;	// η greek small letter eta
			entityMap['theta'] = 0x03B8;	// θ greek small letter theta
			entityMap['iota'] = 0x03B9;	// ι greek small letter iota
			entityMap['kappa'] = 0x03BA;	// κ greek small letter kappa
			entityMap['lambda'] = 0x03BB;	// λ greek small letter lambda
			entityMap['mu'] = 0x03BC;	// μ greek small letter mu
			entityMap['nu'] = 0x03BD;	// ν greek small letter nu
			entityMap['xi'] = 0x03BE;	// ξ greek small letter xi
			entityMap['omicron'] = 0x03BF;	// ο greek small letter omicron
			entityMap['pi'] = 0x03C0;	// π greek small letter pi
			entityMap['rho'] = 0x03C1;	// ρ greek small letter rho
			entityMap['sigmaf'] = 0x03C2;	// ς greek small letter final sigma
			entityMap['sigma'] = 0x03C3;	// σ greek small letter sigma
			entityMap['tau'] = 0x03C4;	// τ greek small letter tau
			entityMap['upsilon'] = 0x03C5;	// υ greek small letter upsilon
			entityMap['phi'] = 0x03C6;	// φ greek small letter phi
			entityMap['chi'] = 0x03C7;	// χ greek small letter chi
			entityMap['psi'] = 0x03C8;	// ψ greek small letter psi
			entityMap['omega'] = 0x03C9;	// ω greek small symbol omega
			entityMap['thetasym'] = 0x03D1;	// ϑ greek theta symbol
			entityMap['upsih'] = 0x03D2;	// ϒ greek upsilon with hook symbol
			entityMap['piv'] = 0x03D6;	// ϖ greek pi symbol

			entityMap['ensp'] = 0x2002;	//   en space
			entityMap['emsp'] = 0x2003;	//   em space
			entityMap['thinsp'] = 0x2009;	//   thin space
			entityMap['zwnj'] = 0x200C;	//   zero width non-joiner
			entityMap['zwj'] = 0x200D;	//   zero width joiner
			entityMap['lrm'] = 0x200E;	//   left-to-right mark
			entityMap['rlm'] = 0x200F;	//   right-to-left mark
			entityMap['ndash'] = 0x2013;	// – en dash
			entityMap['mdash'] = 0x2014;	// — em dash
			entityMap['lsquo'] = 0x2018;	// ‘ left single quotation mark
			entityMap['rsquo'] = 0x2019;	// ’ right single quotation mark
			entityMap['sbquo'] = 0x201A;	// ‚ single low-9 quotation mark
			entityMap['ldquo'] = 0x201C;	// “ left double quotation mark
			entityMap['rdquo'] = 0x201D;	// ” right double quotation mark
			entityMap['bdquo'] = 0x201E;	// „ double low-9 quotation mark
			entityMap['dagger'] = 0x2020;	// † dagger
			entityMap['Dagger'] = 0x2021;	// ‡ double dagger
			entityMap['bull'] = 0x2022;	// • bullet
			entityMap['hellip'] = 0x2026;	// … horizontal ellipsis
			entityMap['permil'] = 0x2030;	// ‰ per mille sign
			entityMap['prime'] = 0x2032;	// ′ prime
			entityMap['Prime'] = 0x2033;	// ″ double prime
			entityMap['lsaquo'] = 0x2039;	// ‹ single left-pointing angle quotation mark
			entityMap['rsaquo'] = 0x203A;	// › single right-pointing angle quotation mark
			entityMap['oline'] = 0x203E;	// ‾ overline
			entityMap['frasl'] = 0x2044;	// ⁄ fraction slash
			entityMap['euro'] = 0x20AC;	// € euro sign
			entityMap['image'] = 0x2111;	// ℑ black-letter capital i
			entityMap['weierp'] = 0x2118;	// ℘ script capital p
			entityMap['real'] = 0x211C;	// ℜ black-letter capital r
			entityMap['trade'] = 0x2122;	// ™ trade mark sign
			entityMap['alefsym'] = 0x2135;	// ℵ alef symbol

			entityMap['larr'] = 0x2190;	// ← leftwards arrow
			entityMap['uarr'] = 0x2191;	// ↑ upwards arrow
			entityMap['rarr'] = 0x2192;	// → rightwards arrow
			entityMap['darr'] = 0x2193;	// ↓ downwards arrow
			entityMap['harr'] = 0x2194;	// ↔ left right arrow
			entityMap['crarr'] = 0x21B5;	// ↵ downwards arrow with corner leftwards
			entityMap['lArr'] = 0x21D0;	// ⇐ leftwards double arrow
			entityMap['uArr'] = 0x21D1;	// ⇑ upwards double arrow
			entityMap['rArr'] = 0x21D2;	// 	⇒ rightwards double arrow
			entityMap['dArr'] = 0x21D3;	// ⇓ downwards double arrow
			entityMap['hArr'] = 0x21D4;	// ⇔⇔  left right double arrow
			entityMap['forall'] = 0x2200;	// ∀  for all
			entityMap['part'] = 0x2202;	// ∂ partial differential
			entityMap['exist'] = 0x2203;	// ∃  there exists
			entityMap['empty'] = 0x2205;	// ∅ empty set
			entityMap['nabla'] = 0x2207;	// ∇  nabla
			entityMap['isin'] = 0x2208;	// 	∈ element of
			entityMap['notin'] = 0x2209;	// ∉ not an element of
			entityMap['ni'] = 0x220B;	// 	∋ contains as member
			entityMap['prod'] = 0x220F;	// ∏ n-ary product
			entityMap['sum'] = 0x2211;	// ∑ n-ary summation
			entityMap['minus'] = 0x2212;	// − minus sign
			entityMap['lowast'] = 0x2217;	// ∗ asterisk operator
			entityMap['radic'] = 0x221A;	// √ square root
			entityMap['prop'] = 0x221D;	// ∝  proportional to
			entityMap['infin'] = 0x221E;	// ∞ infinity
			entityMap['ang'] = 0x2220;	// ∠  angle
			entityMap['and'] = 0x2227;	// ∧  logical and
			entityMap['or'] = 0x2228;	// 	∨ logical or
			entityMap['cap'] = 0x2229;	// ∩ intersection
			entityMap['cup'] = 0x222A;	// ∪  union
			entityMap['int'] = 0x222B;	// ∫ integral
			entityMap['there4'] = 0x2234;	// ∴  therefore
			entityMap['sim'] = 0x223C;	// ∼  tilde operator
			entityMap['cong'] = 0x2245;	// ≅ congruent to
			entityMap['asymp'] = 0x2248;	// ≈ almost equal to
			entityMap['ne'] = 0x2260;	// ≠ not equal to
			entityMap['equiv'] = 0x2261;	// ≡ identical to
			entityMap['le'] = 0x2264;	// ≤ less-than or equal to
			entityMap['ge'] = 0x2265;	// ≥ greater-than or equal to
			entityMap['sub'] = 0x2282;	// 	⊂ subset of
			entityMap['sup'] = 0x2283;	// ⊃  superset of
			entityMap['nsub'] = 0x2284;	// ⊄ not a subset of
			entityMap['sube'] = 0x2286;	// ⊆  subset of or equal to
			entityMap['supe'] = 0x2287;	// ⊇  superset of or equal to
			entityMap['oplus'] = 0x2295;	// ⊕  circled plus
			entityMap['otimes'] = 0x2297;	// ⊗ circled times
			entityMap['perp'] = 0x22A5;	// ⊥  up tack
			entityMap['sdot'] = 0x22C5;	// ⋅ dot operator
			entityMap['lceil'] = 0x2308;	// 	⌈ left ceiling
			entityMap['rceil'] = 0x2309;	// 	⌉ right ceiling
			entityMap['lfloor'] = 0x230A;	// ⌊  left floor
			entityMap['rfloor'] = 0x230B;	// 	⌋ right floor
			entityMap['lang'] = 0x2329;	// 	⌋ left-pointing angle bracket
			entityMap['rang'] = 0x232A;	// 	〉⌋ right-pointing angle bracket
			entityMap['loz'] = 0x25CA;	// ◊ lozenge
			entityMap['spades'] = 0x2660;	// ♠ black spade suit
			entityMap['clubs'] = 0x2663;	// ♣ black club suit
			entityMap['hearts'] = 0x2665;	// ♥ black heart suit
			entityMap['diams'] = 0x2666;	// ♦ black diamond suit

			entityMap['not'] = 0x00AC;	// ¬ not sign
			entityMap['and'] = 0x2227;	// ∧  logical and
			entityMap['or'] = 0x2228;	// 	∨ logical or
			entityMap['ne'] = 0x2260;	// ≠ not equal to
			entityMap['le'] = 0x2264;	// ≤ less-than or equal to
			entityMap['ge'] = 0x2265;	// ≥ greater-than or equal to
			
			var i : String;
			var str : String;
		
			for (i in entityMap) {
				str = '&' + i + ';';
				entities[str] = String.fromCharCode(entityMap[i]);
			}
			
			initialized = true;
		}
	}
}