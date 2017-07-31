package com.dasanzhone.seawind.swservice.snmp;

import com.adventnet.snmp.snmp2.SnmpVar;

public class SnmpOid {

	private String oid;
	private SnmpVar snmpVar;

	public SnmpOid(String oid, SnmpVar snmpVar) {
		this.oid = oid;
		this.snmpVar = snmpVar;
	}
	
	public String getOid() {
		return oid;
	}

	public void setOid(String oid) {
		this.oid = oid;
	}

	public SnmpVar getSnmpVar() {
		return snmpVar;
	}

	public void setSnmpVar(SnmpVar snmpVar) {
		this.snmpVar = snmpVar;
	}

}
