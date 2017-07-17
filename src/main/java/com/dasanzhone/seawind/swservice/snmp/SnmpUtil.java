package com.dasanzhone.seawind.swservice.snmp;

import com.adventnet.snmp.snmp2.SnmpAPI;
import com.adventnet.snmp.snmp2.SnmpException;
import com.adventnet.snmp.snmp2.SnmpOID;
import com.adventnet.snmp.snmp2.SnmpPDU;
import com.adventnet.snmp.snmp2.SnmpVar;
import com.adventnet.snmp.snmp2.SnmpVarBind;

public class SnmpUtil {

	public static SnmpVar getSnmpVar(String type, String value) {
		
		byte dataType;
		if (type.equals("INTEGER")) {
			dataType = SnmpAPI.INTEGER;
		} else if (type.equals("STRING")) {
			dataType = SnmpAPI.STRING;
		} else if (type.equals("GAUGE")) {
			dataType = SnmpAPI.GAUGE;
		} else if (type.equals("TIMETICKS")) {
			dataType = SnmpAPI.TIMETICKS;
		} else if (type.equals("OPAQUE")) {
			dataType = SnmpAPI.OPAQUE;
		} else if (type.equals("IPADDRESS")) {
			dataType = SnmpAPI.IPADDRESS;
		} else if (type.equals("COUNTER")) {
			dataType = SnmpAPI.COUNTER;
		} else if (type.equals("OID")) {
			dataType = SnmpAPI.OBJID;
		} else if (type.equals("BITS")) {
			dataType = SnmpAPI.STRING;
		} else {
			System.err.println("Invalid variable type: " + type);
			return null;
		}

		SnmpVar var = null;
		try {
			// create SnmpVar instance for the value and the type
			var = SnmpVar.createVariable(value, dataType);
		} catch (SnmpException e) {
			System.err.println("Cannot create variable for: " + value);
			return null;
		}
		return var;
	}

	/** adds the varbind with specified oid, type and value to the pdu */
	public static void addVarBind(SnmpPDU pdu, SnmpOID oid, SnmpVar var) {
		
		// create varbind
		SnmpVarBind varbind = new SnmpVarBind(oid, var);
		
		// add variable binding
		pdu.addVariableBinding(varbind);
	}

}
