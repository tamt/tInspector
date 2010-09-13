package test {
	import asunit.framework.TestCase;

	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.parser.TileMapperParser;

	/**
	 * @author itamt[at]qq.com
	 */
	public class TileMapperParserTest extends TestCase {

		private var xml : XML;
		private var parser : TileMapperParser;

		public function TileMapperParserTest(testMethod : String = null) {
			super(testMethod);
		}

		protected override function setUp() : void {
			xml = <project name="Dedo" version="4.0" cellwidth="32" cellheight="32">
	<tiles>
		<images filename="dedo.png">
			<image index="0" />
			<image index="1" />
			<image index="2"></image>
			<image index="3" />
			<image index="4" />
			<image index="5" />
			<image index="6" />
			<image index="7" />
			<image index="8" />
			<image index="9" />
			<image index="10" />
			<image index="11" />
			<image index="12" />
			<image index="13" />
			<image index="14" />
			<image index="15" />
			<image index="16" />
			<image index="17" />
			<image index="18" />
			<image index="19" />
			<image index="20" />
			<image index="21" />
			<image index="22"></image>
			<image index="23" />
			<image index="24" />
			<image index="25" />
			<image index="26" />
			<image index="27" />
			<image index="28" />
			<image index="29" />
			<image index="30" />
			<image index="31" />
			<image index="32" />
			<image index="33" />
			<image index="34" />
			<image index="35" />
			<image index="36" />
			<image index="37" />
			<image index="38" />
			<image index="39" />
			<image index="40" />
			<image index="41" />
			<image index="42" />
			<image index="43" />
			<image index="44" />
			<image index="45" />
			<image index="46" />
			<image index="47" />
			<image index="48" />
			<image index="49" />
			<image index="50" />
			<image index="51" />
			<image index="52" />
			<image index="53" />
			<image index="54" />
			<image index="55" />
			<image index="56" />
			<image index="57" />
			<image index="58" />
			<image index="59" />
			<image index="60" />
			<image index="61" />
			<image index="62" />
			<image index="63" />
			<image index="64" />
			<image index="65" />
			<image index="66" />
			<image index="67" />
			<image index="68" />
			<image index="69" />
			<image index="70" />
			<image index="71" />
			<image index="72" />
			<image index="73" />
			<image index="74" />
			<image index="75" />
			<image index="76" />
			<image index="77" />
			<image index="78" />
			<image index="79" />
			<image index="80" />
			<image index="81" />
			<image index="82" />
			<image index="83" />
			<image index="84" />
			<image index="85" />
			<image index="86" />
			<image index="87" />
			<image index="88" />
			<image index="89" />
			<image index="90" />
			<image index="91" />
			<image index="92" />
			<image index="93" />
			<image index="94" />
			<image index="95" />
			<image index="96" />
			<image index="97" />
			<image index="98" />
			<image index="99" />
			<image index="100" />
			<image index="101" />
			<image index="102" />
			<image index="103" />
			<image index="104" />
			<image index="105" />
		</images>
		<categories>
			<category name="terrain" image="terrain.png" tilesbyrow="1">
				<image index="0" subindex="0" />
			</category>
			<category name="tree" image="tree.png" tilesbyrow="-1">
				<image index="1" subindex="0" />
				<image index="2" subindex="1" />
				<image index="3" subindex="2" />
				<image index="4" subindex="3" />
				<image index="5" subindex="4"></image>
				<image index="6" subindex="5" />
				<image index="7" subindex="6" />
				<image index="8" subindex="7" />
				<image index="9" subindex="8" />
				<image index="10" subindex="9" />
				<image index="11" subindex="10" />
				<image index="12" subindex="11" />
				<image index="13" subindex="12" />
				<image index="14" subindex="13" />
				<image index="15" subindex="14" />
				<image index="16" subindex="15" />
				<image index="91" subindex="16" />
				<image index="92" subindex="17" />
				<image index="93" subindex="18" />
				<image index="94" subindex="19" />
				<image index="95" subindex="20" />
				<image index="96" subindex="21" />
				<image index="97" subindex="22" />
				<image index="98" subindex="23" />
				<image index="99" subindex="24" />
				<image index="100" subindex="25" />
				<image index="101" subindex="26" />
				<image index="102" subindex="27" />
				<image index="103" subindex="28" />
				<image index="104" subindex="29" />
				<image index="105" subindex="30" />
			</category>
			<category name="building" image="building.png" tilesbyrow="-1">
				<image index="17" subindex="0" />
				<image index="18" subindex="1" />
				<image index="19" subindex="2" />
				<image index="20" subindex="3" />
				<image index="21" subindex="4" />
				<image index="22" subindex="5" />
				<image index="23" subindex="6" />
				<image index="24" subindex="7" />
				<image index="25" subindex="8" />
				<image index="26" subindex="9" />
				<image index="27" subindex="10" />
				<image index="28" subindex="11"></image>
				<image index="29" subindex="12" />
				<image index="30" subindex="13" />
				<image index="31" subindex="14" />
				<image index="32" subindex="15" />
				<image index="33" subindex="16" />
				<image index="34" subindex="17" />
				<image index="35" subindex="18" />
				<image index="36" subindex="19" />
				<image index="37" subindex="20" />
				<image index="38" subindex="21" />
				<image index="39" subindex="22" />
				<image index="40" subindex="23" />
				<image index="41" subindex="24" />
				<image index="42" subindex="25" />
				<image index="43" subindex="26" />
				<image index="44" subindex="27" />
				<image index="45" subindex="28" />
				<image index="46" subindex="29" />
				<image index="47" subindex="30" />
				<image index="48" subindex="31" />
				<image index="49" subindex="32" />
				<image index="50" subindex="33" />
				<image index="51" subindex="34" />
				<image index="52" subindex="35" />
				<image index="53" subindex="36" />
				<image index="54" subindex="37" />
				<image index="55" subindex="38" />
				<image index="56" subindex="39" />
				<image index="57" subindex="40" />
				<image index="58" subindex="41" />
				<image index="59" subindex="42" />
				<image index="60" subindex="43" />
				<image index="61" subindex="44" />
				<image index="62" subindex="45" />
				<image index="63" subindex="46" />
				<image index="64" subindex="47" />
				<image index="65" subindex="48" />
				<image index="66" subindex="49" />
				<image index="67" subindex="50" />
				<image index="68" subindex="51" />
				<image index="69" subindex="52" />
				<image index="70" subindex="53" />
				<image index="71" subindex="54" />
				<image index="72" subindex="55" />
				<image index="73" subindex="56" />
				<image index="74" subindex="57" />
				<image index="75" subindex="58" />
				<image index="76" subindex="59" />
				<image index="77" subindex="60" />
				<image index="78" subindex="61" />
				<image index="79" subindex="62" />
				<image index="80" subindex="63" />
				<image index="81" subindex="64" />
			</category>
			<category name="people" image="people.png" tilesbyrow="-1">
				<image index="82" subindex="0" />
				<image index="83" subindex="1" />
				<image index="84" subindex="2" />
				<image index="85" subindex="3" />
				<image index="86" subindex="4" />
				<image index="87" subindex="5" />
				<image index="88" subindex="6" />
				<image index="89" subindex="7" />
				<image index="90" subindex="8" />
			</category>
		</categories>
	</tiles>
	<brushes>
		<items>
			<item name="tree1" id="0" cellsx="4" cellsy="4">
				<cell x="0" y="0" img="1" value="10" />
				<cell x="1" y="0" img="2" value="10" />
				<cell x="2" y="0" img="3" value="10" />
				<cell x="3" y="0" img="4" value="10" />
				<cell x="0" y="1" img="5" value="10" />
				<cell x="1" y="1" img="6" value="10" />
				<cell x="2" y="1" img="7" value="10" />
				<cell x="3" y="1" img="8" value="10" />
				<cell x="0" y="2" img="9" value="10" />
				<cell x="1" y="2" img="10" value="10" />
				<cell x="2" y="2" img="11" value="10" />
				<cell x="3" y="2" img="12" value="10" />
				<cell x="0" y="3" img="13" value="10" />
				<cell x="1" y="3" img="14" value="10" />
				<cell x="2" y="3" img="15" value="10" />
				<cell x="3" y="3" img="16" value="10" />
			</item>
			<item name="building1" id="1" cellsx="10" cellsy="8">
				<cell x="0" y="0" value="0" />
				<cell x="1" y="0" value="0" />
				<cell x="2" y="0" value="0" />
				<cell x="3" y="0" img="17" value="20" />
				<cell x="4" y="0" img="18" value="20" />
				<cell x="5" y="0" img="19" value="20" />
				<cell x="6" y="0" img="20" value="20" />
				<cell x="7" y="0" img="21" value="20" />
				<cell x="8" y="0" value="0" />
				<cell x="9" y="0" value="0" />
				<cell x="0" y="1" value="0" />
				<cell x="1" y="1" value="0" />
				<cell x="2" y="1" value="0" />
				<cell x="3" y="1" img="22" value="20" />
				<cell x="4" y="1" img="23" value="20" />
				<cell x="5" y="1" img="24" value="20" />
				<cell x="6" y="1" img="25" value="20" />
				<cell x="7" y="1" img="26" value="20" />
				<cell x="8" y="1" img="27" value="20" />
				<cell x="9" y="1" img="28" value="20" />
				<cell x="0" y="2" value="0" />
				<cell x="1" y="2" img="29" value="20" />
				<cell x="2" y="2" img="30" value="20" />
				<cell x="3" y="2" img="31" value="20" />
				<cell x="4" y="2" img="32" value="20" />
				<cell x="5" y="2" img="33" value="20" />
				<cell x="6" y="2" img="34" value="20" />
				<cell x="7" y="2" img="35" value="20" />
				<cell x="8" y="2" img="36" value="20" />
				<cell x="9" y="2" img="37" value="20" />
				<cell x="0" y="3" img="38" value="20" />
				<cell x="1" y="3" img="39" value="20" />
				<cell x="2" y="3" img="40" value="20" />
				<cell x="3" y="3" img="41" value="20" />
				<cell x="4" y="3" img="42" value="20" />
				<cell x="5" y="3" img="43" value="20" />
				<cell x="6" y="3" img="44" value="20" />
				<cell x="7" y="3" img="45" value="20" />
				<cell x="8" y="3" img="46" value="20" />
				<cell x="9" y="3" img="47" value="20" />
				<cell x="0" y="4" img="48" value="20" />
				<cell x="1" y="4" img="49" value="20" />
				<cell x="2" y="4" img="50" value="20" />
				<cell x="3" y="4" img="51" value="20" />
				<cell x="4" y="4" img="52" value="20" />
				<cell x="5" y="4" img="53" value="20" />
				<cell x="6" y="4" img="54" value="20" />
				<cell x="7" y="4" img="55" value="20" />
				<cell x="8" y="4" img="56" value="20" />
				<cell x="9" y="4" img="57" value="20" />
				<cell x="0" y="5" img="58" value="20" />
				<cell x="1" y="5" img="59" value="20" />
				<cell x="2" y="5" img="60" value="20" />
				<cell x="3" y="5" img="61" value="20" />
				<cell x="4" y="5" img="62" value="20" />
				<cell x="5" y="5" img="63" value="20" />
				<cell x="6" y="5" img="64" value="20" />
				<cell x="7" y="5" img="65" value="20" />
				<cell x="8" y="5" img="66" value="20" />
				<cell x="9" y="5" img="67" value="20" />
				<cell x="0" y="6" value="0" />
				<cell x="1" y="6" img="68" value="20" />
				<cell x="2" y="6" img="69" value="20" />
				<cell x="3" y="6" img="70" value="20" />
				<cell x="4" y="6" img="71" value="20" />
				<cell x="5" y="6" img="72" value="20" />
				<cell x="6" y="6" img="73" value="20" />
				<cell x="7" y="6" img="74" value="20" />
				<cell x="8" y="6" img="75" value="20" />
				<cell x="9" y="6" img="76" value="20" />
				<cell x="0" y="7" value="0" />
				<cell x="1" y="7" value="0" />
				<cell x="2" y="7" value="0" />
				<cell x="3" y="7" img="77" value="20" />
				<cell x="4" y="7" img="78" value="20" />
				<cell x="5" y="7" img="79" value="20" />
				<cell x="6" y="7" img="80" value="20" />
				<cell x="7" y="7" img="81" value="20" />
				<cell x="8" y="7" value="0" />
				<cell x="9" y="7" value="0" />
			</item>
			<item name="horseman1" id="2" cellsx="3" cellsy="3">
				<cell x="0" y="0" img="82" value="20" />
				<cell x="1" y="0" img="83" value="20" />
				<cell x="2" y="0" img="84" value="20" />
				<cell x="0" y="1" img="85" value="20" />
				<cell x="1" y="1" img="86" value="20" />
				<cell x="2" y="1" img="87" value="20" />
				<cell x="0" y="2" img="88" value="20" />
				<cell x="1" y="2" img="89" value="20" />
				<cell x="2" y="2" img="90" value="20" />
			</item>
			<item name="tree2" id="3" cellsx="3" cellsy="5">
				<cell x="0" y="0" img="91" value="10" />
				<cell x="1" y="0" img="92" value="10" />
				<cell x="2" y="0" img="93" value="10" />
				<cell x="0" y="1" img="94" value="10" />
				<cell x="1" y="1" img="95" value="10" />
				<cell x="2" y="1" img="96" value="10" />
				<cell x="0" y="2" img="97" value="10" />
				<cell x="1" y="2" img="98" value="10" />
				<cell x="2" y="2" img="99" value="10" />
				<cell x="0" y="3" img="100" value="10" />
				<cell x="1" y="3" img="101" value="10" />
				<cell x="2" y="3" img="102" value="10" />
				<cell x="0" y="4" img="103" value="10" />
				<cell x="1" y="4" img="104" value="10" />
				<cell x="2" y="4" img="105" value="10" />
			</item>
		</items>
		<categories>
			<category name="tree">
				<brush name="tree1" index="0" />
				<brush name="tree2" index="3" />
			</category>
			<category name="building">
				<brush name="building1" index="1" />
			</category>
			<category name="people">
				<brush name="horseman1" index="2" />
			</category>
		</categories>
	</brushes>
	<animations>
		<items>
		</items>
		<categories>
		</categories>
	</animations>
	<maps>
		<map index="0" name="Dedo" cellsx="20" cellsy="20" cellwidth="32"
			cellheight="32">
			<layers>
				<layer index="0" name="tree2" visible="1">
					<cell x="16" y="14" img="91" value="10" />
					<cell x="17" y="14" img="92" value="10" />
					<cell x="18" y="14" img="93" value="10" />
					<cell x="16" y="15" img="94" value="10" />
					<cell x="17" y="15" img="95" value="10" />
					<cell x="18" y="15" img="96" value="10" />
					<cell x="16" y="16" img="97" value="10" />
					<cell x="17" y="16" img="98" value="10" />
					<cell x="18" y="16" img="99" value="10"></cell>
					<cell x="16" y="17" img="100" value="10" />
					<cell x="17" y="17" img="101" value="10" />
					<cell x="18" y="17" img="102" value="10" />
					<cell x="16" y="18" img="103" value="10"></cell>
					<cell x="17" y="18" img="104" value="10" />
					<cell x="18" y="18" img="105" value="10" />
				</layer>
				<layer index="1" name="people" visible="1">
					<cell x="1" y="7" img="82" value="20" />
					<cell x="2" y="7" img="83" value="20" />
					<cell x="3" y="7" img="84" value="20" />
					<cell x="1" y="8" img="85" value="20" />
					<cell x="2" y="8" img="86" value="20" />
					<cell x="3" y="8" img="87" value="20" />
					<cell x="1" y="9" img="88" value="20" />
					<cell x="2" y="9" img="89" value="20" />
					<cell x="3" y="9" img="90" value="20" />
					<cell x="8" y="11" img="82" value="20" />
					<cell x="9" y="11" img="83" value="20" />
					<cell x="10" y="11" img="84" value="20" />
					<cell x="8" y="12" img="85" value="20" />
					<cell x="9" y="12" img="86" value="20" />
					<cell x="10" y="12" img="87" value="20" />
					<cell x="8" y="13" img="88" value="20" />
					<cell x="9" y="13" img="89" value="20" />
					<cell x="10" y="13" img="90" value="20" />
					<cell x="15" y="14" img="82" value="20" />
					<cell x="16" y="14" img="83" value="20" />
					<cell x="17" y="14" img="84" value="20" />
					<cell x="15" y="15" img="85" value="20" />
					<cell x="16" y="15" img="86" value="20" />
					<cell x="17" y="15" img="87" value="20" />
					<cell x="15" y="16" img="88" value="20" />
					<cell x="16" y="16" img="89" value="20" />
					<cell x="17" y="16" img="90" value="20" />
				</layer>
				<layer index="2" name="building" visible="1">
					<cell x="5" y="1" img="17" value="20" />
					<cell x="6" y="1" img="18" value="20" />
					<cell x="7" y="1" img="19" value="20" />
					<cell x="8" y="1" img="20" value="20" />
					<cell x="9" y="1" img="21" value="20" />
					<cell x="5" y="2" img="22" value="20" />
					<cell x="6" y="2" img="23" value="20" />
					<cell x="7" y="2" img="24" value="20" />
					<cell x="8" y="2" img="25" value="20" />
					<cell x="9" y="2" img="26" value="20" />
					<cell x="10" y="2" img="27" value="20" />
					<cell x="11" y="2" img="28" value="20" />
					<cell x="3" y="3" img="29" value="20" />
					<cell x="4" y="3" img="30" value="20" />
					<cell x="5" y="3" img="31" value="20" />
					<cell x="6" y="3" img="32" value="20" />
					<cell x="7" y="3" img="33" value="20" />
					<cell x="8" y="3" img="34" value="20" />
					<cell x="9" y="3" img="35" value="20" />
					<cell x="10" y="3" img="36" value="20" />
					<cell x="11" y="3" img="37" value="20" />
					<cell x="2" y="4" img="38" value="20" />
					<cell x="3" y="4" img="39" value="20" />
					<cell x="4" y="4" img="40" value="20" />
					<cell x="5" y="4" img="41" value="20" />
					<cell x="6" y="4" img="42" value="20" />
					<cell x="7" y="4" img="43" value="20" />
					<cell x="8" y="4" img="44" value="20" />
					<cell x="9" y="4" img="45" value="20" />
					<cell x="10" y="4" img="46" value="20" />
					<cell x="11" y="4" img="47" value="20" />
					<cell x="2" y="5" img="48" value="20" />
					<cell x="3" y="5" img="49" value="20" />
					<cell x="4" y="5" img="50" value="20" />
					<cell x="5" y="5" img="51" value="20" />
					<cell x="6" y="5" img="52" value="20" />
					<cell x="7" y="5" img="53" value="20" />
					<cell x="8" y="5" img="54" value="20" />
					<cell x="9" y="5" img="55" value="20" />
					<cell x="10" y="5" img="56" value="20" />
					<cell x="11" y="5" img="57" value="20" />
					<cell x="2" y="6" img="58" value="20" />
					<cell x="3" y="6" img="59" value="20" />
					<cell x="4" y="6" img="60" value="20" />
					<cell x="5" y="6" img="61" value="20" />
					<cell x="6" y="6" img="62" value="20" />
					<cell x="7" y="6" img="63" value="20" />
					<cell x="8" y="6" img="64" value="20" />
					<cell x="9" y="6" img="65" value="20" />
					<cell x="10" y="6" img="66" value="20" />
					<cell x="11" y="6" img="67" value="20" />
					<cell x="3" y="7" img="68" value="20" />
					<cell x="4" y="7" img="69" value="20" />
					<cell x="5" y="7" img="70" value="20" />
					<cell x="6" y="7" img="71" value="20" />
					<cell x="7" y="7" img="72" value="20" />
					<cell x="8" y="7" img="73" value="20" />
					<cell x="9" y="7" img="74" value="20" />
					<cell x="10" y="7" img="75" value="20" />
					<cell x="11" y="7" img="76" value="20" />
					<cell x="5" y="8" img="77" value="20" />
					<cell x="6" y="8" img="78" value="20" />
					<cell x="7" y="8" img="79" value="20" />
					<cell x="8" y="8" img="80" value="20" />
					<cell x="9" y="8" img="81" value="20" />
				</layer>
				<layer index="3" name="tree" visible="1">
					<cell x="1" y="1" img="1" value="10" />
					<cell x="2" y="1" img="2" value="10" />
					<cell x="3" y="1" img="3" value="10" />
					<cell x="4" y="1" img="4" value="10" />
					<cell x="1" y="2" img="5" value="10" />
					<cell x="2" y="2" img="6" value="10" />
					<cell x="3" y="2" img="7" value="10" />
					<cell x="4" y="2" img="8" value="10" />
					<cell x="1" y="3" img="9" value="10" />
					<cell x="2" y="3" img="10" value="10" />
					<cell x="3" y="3" img="11" value="10" />
					<cell x="4" y="3" img="12" value="10" />
					<cell x="1" y="4" img="13" value="10" />
					<cell x="2" y="4" img="14" value="10" />
					<cell x="3" y="4" img="15" value="10" />
					<cell x="4" y="4" img="16" value="10" />
					<cell x="2" y="12" img="1" value="10" />
					<cell x="3" y="12" img="2" value="10" />
					<cell x="4" y="12" img="3" value="10" />
					<cell x="5" y="12" img="4" value="10" />
					<cell x="2" y="13" img="5" value="10" />
					<cell x="3" y="13" img="6" value="10" />
					<cell x="4" y="13" img="7" value="10" />
					<cell x="5" y="13" img="8" value="10" />
					<cell x="2" y="14" img="9" value="10" />
					<cell x="3" y="14" img="10" value="10" />
					<cell x="4" y="14" img="11" value="10" />
					<cell x="5" y="14" img="12" value="10" />
					<cell x="2" y="15" img="13" value="10" />
					<cell x="3" y="15" img="14" value="10" />
					<cell x="4" y="15" img="15" value="10" />
					<cell x="5" y="15" img="16" value="10" />
				</layer>
				<layer index="4" name="Main" visible="1">
					<cell x="0" y="0" img="0" />
					<cell x="1" y="0" img="0" />
					<cell x="2" y="0" img="0" />
					<cell x="3" y="0" img="0" />
					<cell x="4" y="0" img="0" />
					<cell x="5" y="0" img="0" />
					<cell x="6" y="0" img="0" />
					<cell x="7" y="0" img="0" />
					<cell x="8" y="0" img="0" />
					<cell x="9" y="0" img="0" />
					<cell x="10" y="0" img="0" />
					<cell x="11" y="0" img="0" />
					<cell x="12" y="0" img="0" />
					<cell x="13" y="0" img="0" />
					<cell x="14" y="0" img="0" />
					<cell x="15" y="0" img="0" />
					<cell x="16" y="0" img="0" />
					<cell x="17" y="0" img="0" />
					<cell x="18" y="0" img="0" />
					<cell x="19" y="0" img="0" />
					<cell x="0" y="1" img="0" />
					<cell x="1" y="1" img="0" />
					<cell x="2" y="1" img="0" />
					<cell x="3" y="1" img="0" />
					<cell x="4" y="1" img="0" />
					<cell x="5" y="1" img="0" />
					<cell x="6" y="1" img="0" />
					<cell x="7" y="1" img="0" />
					<cell x="8" y="1" img="0" />
					<cell x="9" y="1" img="0" />
					<cell x="10" y="1" img="0" />
					<cell x="11" y="1" img="0" />
					<cell x="12" y="1" img="0" />
					<cell x="13" y="1" img="0" />
					<cell x="14" y="1" img="0" />
					<cell x="15" y="1" img="0" />
					<cell x="16" y="1" img="0" />
					<cell x="17" y="1" img="0" />
					<cell x="18" y="1" img="0" />
					<cell x="19" y="1" img="0" />
					<cell x="0" y="2" img="0" />
					<cell x="1" y="2" img="0" />
					<cell x="2" y="2" img="0" />
					<cell x="3" y="2" img="0" />
					<cell x="4" y="2" img="0" />
					<cell x="5" y="2" img="0" />
					<cell x="6" y="2" img="0" />
					<cell x="7" y="2" img="0" />
					<cell x="8" y="2" img="0" />
					<cell x="9" y="2" img="0" />
					<cell x="10" y="2" img="0" />
					<cell x="11" y="2" img="0" />
					<cell x="12" y="2" img="0" />
					<cell x="13" y="2" img="0" />
					<cell x="14" y="2" img="0" />
					<cell x="15" y="2" img="0" />
					<cell x="16" y="2" img="0" />
					<cell x="17" y="2" img="0" />
					<cell x="18" y="2" img="0" />
					<cell x="19" y="2" img="0" />
					<cell x="0" y="3" img="0" />
					<cell x="1" y="3" img="0" />
					<cell x="2" y="3" img="0" />
					<cell x="3" y="3" img="0" />
					<cell x="4" y="3" img="0" />
					<cell x="5" y="3" img="0" />
					<cell x="6" y="3" img="0" />
					<cell x="7" y="3" img="0" />
					<cell x="8" y="3" img="0" />
					<cell x="9" y="3" img="0" />
					<cell x="10" y="3" img="0" />
					<cell x="11" y="3" img="0" />
					<cell x="12" y="3" img="0" />
					<cell x="13" y="3" img="0" />
					<cell x="14" y="3" img="0" />
					<cell x="15" y="3" img="0" />
					<cell x="16" y="3" img="0" />
					<cell x="17" y="3" img="0" />
					<cell x="18" y="3" img="0" />
					<cell x="19" y="3" img="0" />
					<cell x="0" y="4" img="0" />
					<cell x="1" y="4" img="0" />
					<cell x="2" y="4" img="0" />
					<cell x="3" y="4" img="0" />
					<cell x="4" y="4" img="0" />
					<cell x="5" y="4" img="0" />
					<cell x="6" y="4" img="0" />
					<cell x="7" y="4" img="0" />
					<cell x="8" y="4" img="0" />
					<cell x="9" y="4" img="0" />
					<cell x="10" y="4" img="0" />
					<cell x="11" y="4" img="0" />
					<cell x="12" y="4" img="0" />
					<cell x="13" y="4" img="0" />
					<cell x="14" y="4" img="0" />
					<cell x="15" y="4" img="0" />
					<cell x="16" y="4" img="0" />
					<cell x="17" y="4" img="0" />
					<cell x="18" y="4" img="0" />
					<cell x="19" y="4" img="0" />
					<cell x="0" y="5" img="0" />
					<cell x="1" y="5" img="0" />
					<cell x="2" y="5" img="0" />
					<cell x="3" y="5" img="0" />
					<cell x="4" y="5" img="0" />
					<cell x="5" y="5" img="0" />
					<cell x="6" y="5" img="0" />
					<cell x="7" y="5" img="0" />
					<cell x="8" y="5" img="0" />
					<cell x="9" y="5" img="0" />
					<cell x="10" y="5" img="0" />
					<cell x="11" y="5" img="0" />
					<cell x="12" y="5" img="0" />
					<cell x="13" y="5" img="0" />
					<cell x="14" y="5" img="0" />
					<cell x="15" y="5" img="0" />
					<cell x="16" y="5" img="0" />
					<cell x="17" y="5" img="0" />
					<cell x="18" y="5" img="0" />
					<cell x="19" y="5" img="0" />
					<cell x="0" y="6" img="0" />
					<cell x="1" y="6" img="0" />
					<cell x="2" y="6" img="0" />
					<cell x="3" y="6" img="0" />
					<cell x="4" y="6" img="0" />
					<cell x="5" y="6" img="0" />
					<cell x="6" y="6" img="0" />
					<cell x="7" y="6" img="0" />
					<cell x="8" y="6" img="0" />
					<cell x="9" y="6" img="0" />
					<cell x="10" y="6" img="0" />
					<cell x="11" y="6" img="0" />
					<cell x="12" y="6" img="0" />
					<cell x="13" y="6" img="0" />
					<cell x="14" y="6" img="0" />
					<cell x="15" y="6" img="0" />
					<cell x="16" y="6" img="0" />
					<cell x="17" y="6" img="0" />
					<cell x="18" y="6" img="0" />
					<cell x="19" y="6" img="0" />
					<cell x="0" y="7" img="0" />
					<cell x="1" y="7" img="0" />
					<cell x="2" y="7" img="0" />
					<cell x="3" y="7" img="0" />
					<cell x="4" y="7" img="0" />
					<cell x="5" y="7" img="0" />
					<cell x="6" y="7" img="0" />
					<cell x="7" y="7" img="0" />
					<cell x="8" y="7" img="0" />
					<cell x="9" y="7" img="0" />
					<cell x="10" y="7" img="0" />
					<cell x="11" y="7" img="0" />
					<cell x="12" y="7" img="0" />
					<cell x="13" y="7" img="0" />
					<cell x="14" y="7" img="0" />
					<cell x="15" y="7" img="0" />
					<cell x="16" y="7" img="0" />
					<cell x="17" y="7" img="0" />
					<cell x="18" y="7" img="0" />
					<cell x="19" y="7" img="0" />
					<cell x="0" y="8" img="0" />
					<cell x="1" y="8" img="0" />
					<cell x="2" y="8" img="0" />
					<cell x="3" y="8" img="0" />
					<cell x="4" y="8" img="0" />
					<cell x="5" y="8" img="0" />
					<cell x="6" y="8" img="0" />
					<cell x="7" y="8" img="0" />
					<cell x="8" y="8" img="0" />
					<cell x="9" y="8" img="0" />
					<cell x="10" y="8" img="0" />
					<cell x="11" y="8" img="0" />
					<cell x="12" y="8" img="0" />
					<cell x="13" y="8" img="0" />
					<cell x="14" y="8" img="0" />
					<cell x="15" y="8" img="0" />
					<cell x="16" y="8" img="0" />
					<cell x="17" y="8" img="0" />
					<cell x="18" y="8" img="0" />
					<cell x="19" y="8" img="0" />
					<cell x="0" y="9" img="0" />
					<cell x="1" y="9" img="0" />
					<cell x="2" y="9" img="0" />
					<cell x="3" y="9" img="0" />
					<cell x="4" y="9" img="0" />
					<cell x="5" y="9" img="0" />
					<cell x="6" y="9" img="0" />
					<cell x="7" y="9" img="0" />
					<cell x="8" y="9" img="0" />
					<cell x="9" y="9" img="0" />
					<cell x="10" y="9" img="0" />
					<cell x="11" y="9" img="0" />
					<cell x="12" y="9" img="0" />
					<cell x="13" y="9" img="0" />
					<cell x="14" y="9" img="0" />
					<cell x="15" y="9" img="0" />
					<cell x="16" y="9" img="0" />
					<cell x="17" y="9" img="0" />
					<cell x="18" y="9" img="0" />
					<cell x="19" y="9" img="0" />
					<cell x="0" y="10" img="0" />
					<cell x="1" y="10" img="0" />
					<cell x="2" y="10" img="0" />
					<cell x="3" y="10" img="0" />
					<cell x="4" y="10" img="0" />
					<cell x="5" y="10" img="0" />
					<cell x="6" y="10" img="0" />
					<cell x="7" y="10" img="0" />
					<cell x="8" y="10" img="0" />
					<cell x="9" y="10" img="0" />
					<cell x="10" y="10" img="0" />
					<cell x="11" y="10" img="0" />
					<cell x="12" y="10" img="0" />
					<cell x="13" y="10" img="0" />
					<cell x="14" y="10" img="0" />
					<cell x="15" y="10" img="0" />
					<cell x="16" y="10" img="0" />
					<cell x="17" y="10" img="0" />
					<cell x="18" y="10" img="0" />
					<cell x="19" y="10" img="0" />
					<cell x="0" y="11" img="0" />
					<cell x="1" y="11" img="0" />
					<cell x="2" y="11" img="0" />
					<cell x="3" y="11" img="0" />
					<cell x="4" y="11" img="0" />
					<cell x="5" y="11" img="0" />
					<cell x="6" y="11" img="0" />
					<cell x="7" y="11" img="0" />
					<cell x="8" y="11" img="0" />
					<cell x="9" y="11" img="0" />
					<cell x="10" y="11" img="0" />
					<cell x="11" y="11" img="0" />
					<cell x="12" y="11" img="0" />
					<cell x="13" y="11" img="0" />
					<cell x="14" y="11" img="0" />
					<cell x="15" y="11" img="0" />
					<cell x="16" y="11" img="0" />
					<cell x="17" y="11" img="0" />
					<cell x="18" y="11" img="0" />
					<cell x="19" y="11" img="0" />
					<cell x="0" y="12" img="0" />
					<cell x="1" y="12" img="0" />
					<cell x="2" y="12" img="0" />
					<cell x="3" y="12" img="0" />
					<cell x="4" y="12" img="0" />
					<cell x="5" y="12" img="0" />
					<cell x="6" y="12" img="0" />
					<cell x="7" y="12" img="0" />
					<cell x="8" y="12" img="0" />
					<cell x="9" y="12" img="0" />
					<cell x="10" y="12" img="0" />
					<cell x="11" y="12" img="0" />
					<cell x="12" y="12" img="0" />
					<cell x="13" y="12" img="0" />
					<cell x="14" y="12" img="0" />
					<cell x="15" y="12" img="0" />
					<cell x="16" y="12" img="0" />
					<cell x="17" y="12" img="0" />
					<cell x="18" y="12" img="0" />
					<cell x="19" y="12" img="0" />
					<cell x="0" y="13" img="0" />
					<cell x="1" y="13" img="0" />
					<cell x="2" y="13" img="0" />
					<cell x="3" y="13" img="0" />
					<cell x="4" y="13" img="0" />
					<cell x="5" y="13" img="0" />
					<cell x="6" y="13" img="0" />
					<cell x="7" y="13" img="0" />
					<cell x="8" y="13" img="0" />
					<cell x="9" y="13" img="0" />
					<cell x="10" y="13" img="0" />
					<cell x="11" y="13" img="0" />
					<cell x="12" y="13" img="0" />
					<cell x="13" y="13" img="0" />
					<cell x="14" y="13" img="0" />
					<cell x="15" y="13" img="0" />
					<cell x="16" y="13" img="0" />
					<cell x="17" y="13" img="0" />
					<cell x="18" y="13" img="0" />
					<cell x="19" y="13" img="0" />
					<cell x="0" y="14" img="0" />
					<cell x="1" y="14" img="0" />
					<cell x="2" y="14" img="0" />
					<cell x="3" y="14" img="0" />
					<cell x="4" y="14" img="0" />
					<cell x="5" y="14" img="0" />
					<cell x="6" y="14" img="0" />
					<cell x="7" y="14" img="0" />
					<cell x="8" y="14" img="0" />
					<cell x="9" y="14" img="0" />
					<cell x="10" y="14" img="0" />
					<cell x="11" y="14" img="0" />
					<cell x="12" y="14" img="0" />
					<cell x="13" y="14" img="0" />
					<cell x="14" y="14" img="0" />
					<cell x="15" y="14" img="0" />
					<cell x="16" y="14" img="0" />
					<cell x="17" y="14" img="0" />
					<cell x="18" y="14" img="0" />
					<cell x="19" y="14" img="0" />
					<cell x="0" y="15" img="0" />
					<cell x="1" y="15" img="0" />
					<cell x="2" y="15" img="0" />
					<cell x="3" y="15" img="0" />
					<cell x="4" y="15" img="0" />
					<cell x="5" y="15" img="0" />
					<cell x="6" y="15" img="0" />
					<cell x="7" y="15" img="0" />
					<cell x="8" y="15" img="0" />
					<cell x="9" y="15" img="0" />
					<cell x="10" y="15" img="0" />
					<cell x="11" y="15" img="0" />
					<cell x="12" y="15" img="0" />
					<cell x="13" y="15" img="0" />
					<cell x="14" y="15" img="0" />
					<cell x="15" y="15" img="0" />
					<cell x="16" y="15" img="0" />
					<cell x="17" y="15" img="0" />
					<cell x="18" y="15" img="0" />
					<cell x="19" y="15" img="0" />
					<cell x="0" y="16" img="0" />
					<cell x="1" y="16" img="0" />
					<cell x="2" y="16" img="0" />
					<cell x="3" y="16" img="0" />
					<cell x="4" y="16" img="0" />
					<cell x="5" y="16" img="0" />
					<cell x="6" y="16" img="0" />
					<cell x="7" y="16" img="0" />
					<cell x="8" y="16" img="0" />
					<cell x="9" y="16" img="0" />
					<cell x="10" y="16" img="0" />
					<cell x="11" y="16" img="0" />
					<cell x="12" y="16" img="0" />
					<cell x="13" y="16" img="0" />
					<cell x="14" y="16" img="0" />
					<cell x="15" y="16" img="0" />
					<cell x="16" y="16" img="0" />
					<cell x="17" y="16" img="0" />
					<cell x="18" y="16" img="0" />
					<cell x="19" y="16" img="0" />
					<cell x="0" y="17" img="0" />
					<cell x="1" y="17" img="0" />
					<cell x="2" y="17" img="0" />
					<cell x="3" y="17" img="0" />
					<cell x="4" y="17" img="0" />
					<cell x="5" y="17" img="0" />
					<cell x="6" y="17" img="0" />
					<cell x="7" y="17" img="0" />
					<cell x="8" y="17" img="0" />
					<cell x="9" y="17" img="0" />
					<cell x="10" y="17" img="0" />
					<cell x="11" y="17" img="0" />
					<cell x="12" y="17" img="0" />
					<cell x="13" y="17" img="0" />
					<cell x="14" y="17" img="0" />
					<cell x="15" y="17" img="0" />
					<cell x="16" y="17" img="0" />
					<cell x="17" y="17" img="0" />
					<cell x="18" y="17" img="0" />
					<cell x="19" y="17" img="0" />
					<cell x="0" y="18" img="0" />
					<cell x="1" y="18" img="0" />
					<cell x="2" y="18" img="0" />
					<cell x="3" y="18" img="0" />
					<cell x="4" y="18" img="0" />
					<cell x="5" y="18" img="0" />
					<cell x="6" y="18" img="0" />
					<cell x="7" y="18" img="0" />
					<cell x="8" y="18" img="0" />
					<cell x="9" y="18" img="0" />
					<cell x="10" y="18" img="0" />
					<cell x="11" y="18" img="0" />
					<cell x="12" y="18" img="0" />
					<cell x="13" y="18" img="0" />
					<cell x="14" y="18" img="0" />
					<cell x="15" y="18" img="0" />
					<cell x="16" y="18" img="0" />
					<cell x="17" y="18" img="0" />
					<cell x="18" y="18" img="0" />
					<cell x="19" y="18" img="0" />
					<cell x="0" y="19" img="0" />
					<cell x="1" y="19" img="0" />
					<cell x="2" y="19" img="0" />
					<cell x="3" y="19" img="0" />
					<cell x="4" y="19" img="0" />
					<cell x="5" y="19" img="0" />
					<cell x="6" y="19" img="0" />
					<cell x="7" y="19" img="0" />
					<cell x="8" y="19" img="0" />
					<cell x="9" y="19" img="0" />
					<cell x="10" y="19" img="0" />
					<cell x="11" y="19" img="0" />
					<cell x="12" y="19" img="0" />
					<cell x="13" y="19" img="0" />
					<cell x="14" y="19" img="0" />
					<cell x="15" y="19" img="0" />
					<cell x="16" y="19" img="0" />
					<cell x="17" y="19" img="0" />
					<cell x="18" y="19" img="0" />
					<cell x="19" y="19" img="0" />
				</layer>
			</layers>
			<jumps>
			</jumps>
		</map>
	</maps>
</project>;

			parser = new TileMapperParser();
			parser.parse(xml);
		}

		protected override function tearDown() : void {
			this.xml = null;
		}

		public function testParseNameWithSampleXML() : void {
			assertEqualsArrays(["Dedo", "4.0", 32, 32], [parser.getProjectName(), parser.getProjectVersion(), parser.getProjectCellWidth(), parser.getProjectCellHeight()]);
		}

		public function testTilesWithSampleXML() : void {
			assertEqualsArrays(["dedo.png", 9], [parser.getTiles().fileName, parser.getTiles().getValue(9)]);
		}

		public function testMapsWithSampleXML() : void {
			var map : DMap = parser.getMaps().getMap(0);
			assertEqualsArrays([0, "Dedo", 20, 20, 32, 32], [map.index, map.name, map.cellsx, map.cellsy, map.cellwidth, map.cellheight]);
		}
	}
}