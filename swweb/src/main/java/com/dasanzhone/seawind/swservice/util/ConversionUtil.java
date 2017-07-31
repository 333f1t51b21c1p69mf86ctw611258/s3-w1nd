package com.dasanzhone.seawind.swservice.util;

import com.google.common.base.CaseFormat;

public class ConversionUtil {

	public static int convertAddressToOntId(String cli_node) {
		String[] nodes = cli_node.split("/");

		int LT_ID = Integer.parseInt(nodes[2]);
		int PON_ID = Integer.parseInt(nodes[3]);
		int ONT_ID = Integer.parseInt(nodes[4]);

		// System.out.println("Input: 1/1/" + LT_ID + "/" + PON_ID + "/" + ONT_ID);

		int segment1 = (ONT_ID - 1) << 10;
		int segment2 = (PON_ID - 1) << 17;
		int segment3 = 0b111 << 22;
		int segment4 = (LT_ID + 1) << 25;

		int MIB_LEAF_NODE = segment1 | segment2 | segment3 | segment4;

		// System.out.println("Output: " + MIB_LEAF_NODE);

		return MIB_LEAF_NODE;
	}

	public static int convertAddressToOntCardSlot(String cli_node) {
		String[] nodes = cli_node.split("/");

		int SLOT_ID = Integer.parseInt(nodes[5]);

		int segment5 = SLOT_ID << 22;
		int segment6 = 0b1000 << 26;

		int ONT_CARD_SLOT = segment5 | segment6;

		return ONT_CARD_SLOT;
	}

	public static int convertAddressToOntPort(String cli_node) {
		String[] nodes = cli_node.split("/");

		int LT_ID = Integer.parseInt(nodes[2]);
		int PON_ID = Integer.parseInt(nodes[3]);
		int ONT_ID = Integer.parseInt(nodes[4]);
		int SLOT_ID = Integer.parseInt(nodes[5]);
		int PORT_ID = Integer.parseInt(nodes[6]);

		int segment1 = (ONT_ID - 1) << 10;
		int segment2 = (PON_ID - 1) << 17;
		int segment4 = (LT_ID + 1) << 25;

		int segment7 = (PORT_ID - 1);
		int segment8 = SLOT_ID << 6;

		int MIB_LEAF_NODE = segment7 | segment8 | segment1 | segment2 | segment4;

		return MIB_LEAF_NODE;
	}
	
	public static String convertSerialNumberHexStringToSerialNumberByteArrayString(String hexString) {
		
		String[] splited = hexString.split(":");
		
		String segment0_original = splited[0];
		String segment1_original = splited[1];
		
		String segment1_final = convertHexStringToByteArrayString(segment1_original);
		
		return String.format("%s%s", segment0_original, segment1_final);
		
	}

	public static String convertHexStringToByteArrayString(String s) {
		
		
		int len = s.length();
		
		byte[] data = new byte[len / 2];
		
		for (int i = 0; i < len; i += 2) {
			data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
					+ Character.digit(s.charAt(i + 1), 16));
		}
		
		return new String(data);
	}
	
	public static String convertConstantCaseToCamelCase(String constantCase) {
		
		return CaseFormat.UPPER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, constantCase);
	}

}
