package com.dasanzhone.seawind.swservice.snmp;

import com.adventnet.snmp.beans.SnmpServer;
import com.adventnet.snmp.beans.SnmpTarget;
import com.adventnet.snmp.snmp2.SnmpAPI;
import com.adventnet.snmp.snmp2.SnmpException;
import com.adventnet.snmp.snmp2.SnmpOID;
import com.adventnet.snmp.snmp2.SnmpPDU;
import com.adventnet.snmp.snmp2.SnmpSession;
import com.adventnet.snmp.snmp2.SnmpVar;
import com.adventnet.snmp.snmp2.UDPProtocolOptions;
import com.adventnet.snmp.snmp2.usm.USMUtils;

public class SnmpOperation {

	public static boolean setWithoutMib(SnmpOperationInput inputObject) throws Exception {

		// Take care of getting options
		// String usage = "snmpset_without_mib [-v version(v1,v2,v3)] [-c community] [-p port] [-t timeout] [-r retries] [-u user] [-a auth_protocol(MD5/SHA)] [-w auth_password] [-s priv_password] [-d debug] [-n contextName ] [-i contextID ] [-pp priv_protocol(DES/AES-128/AES-192/AES-256/3DES) ] host OID {INTEGER | STRING | GAUGE | TIMETICKS | OPAQUE | IPADDRESS | COUNTER | OID } value [OID type value] ...";
		// String options[] = { "-v", "-c", "-p", "-r", "-t", "-u", "-a", "-w", "-s", "-d", "-n", "-i", "-pp" };
		// String values[] = { null, null, null, null, null, null, null, null, null, "None", null, null, null };

		String authProtocol = new String("NO_AUTH");

		// ParseOptions opt = new ParseOptions(args, options, values, usage);

		// Use an SNMP target bean to perform SNMP operations
		SnmpTarget target = new SnmpTarget();

		// at least 3 arguments are needed to do anything useful
		// if (opt.remArgs.length < 3)
		// opt.usage_error();
		if (inputObject.getDebug() != null && inputObject.getDebug().equals("Set"))
			target.setDebug(true);

		target.setTargetHost(inputObject.getHost()); // set the agent hostname
		if (inputObject.getCommunity() != null) // set the community if specified
			target.setCommunity(inputObject.getCommunity());

		if (inputObject.getVersion() != null) { // if SNMP version is specified, set it
			if (inputObject.getVersion().equals("v2"))
				target.setSnmpVersion(SnmpTarget.VERSION2C);
			else if (inputObject.getVersion().equals("v1"))
				target.setSnmpVersion(SnmpTarget.VERSION1);
			else if (inputObject.getVersion().equals("v3"))
				target.setSnmpVersion(SnmpTarget.VERSION3);
			else {
				System.out.println("Invalid Version Number");
				System.exit(1);
			}
		}

		try { // set the timeout/retries/port parameters, if specified
			if (inputObject.getPort() != null)
				target.setTargetPort(Integer.parseInt(inputObject.getPort()));
			if (inputObject.getRetries() != null)
				target.setRetries(Integer.parseInt(inputObject.getRetries()));
			if (inputObject.getTimeout() != null)
				target.setTimeout(Integer.parseInt(inputObject.getTimeout()));
		} catch (NumberFormatException ex) {
			System.err.println("Invalid Integer Argument " + ex);
			// opt.usage_error();
			throw new Exception("Invalid Integer Argument " + ex);
		}

		if (target.getSnmpVersion() == SnmpTarget.VERSION3) {
			if (inputObject.getUser() != null)
				target.setPrincipal(inputObject.getUser());
			if (inputObject.getAuthProtocol() != null)
				authProtocol = inputObject.getAuthProtocol();
			if (authProtocol.equals("SHA"))
				target.setAuthProtocol(SnmpServer.SHA_AUTH);
			else if (authProtocol.equals("MD5"))
				target.setAuthProtocol(SnmpServer.MD5_AUTH);
			else
				target.setAuthProtocol(SnmpServer.NO_AUTH);
			if (inputObject.getAuthPassword() != null)
				target.setAuthPassword(inputObject.getAuthPassword());
			if (inputObject.getPrivPassword() != null) {
				target.setPrivPassword(inputObject.getPrivPassword());
				if (inputObject.getPrivProtocol() != null) {
					if (inputObject.getPrivProtocol().equals("AES-128")) {
						target.setPrivProtocol(SnmpServer.CFB_AES_128);
					} else if (inputObject.getPrivProtocol().equals("AES-192")) {
						target.setPrivProtocol(SnmpServer.CFB_AES_192);
					} else if (inputObject.getPrivProtocol().equals("AES-256")) {
						target.setPrivProtocol(SnmpServer.CFB_AES_256);
					} else if (inputObject.getPrivProtocol().equals("3DES")) {
						target.setPrivProtocol(SnmpServer.CBC_3DES);
					} else if (inputObject.getPrivProtocol().equals("DES")) {
						target.setPrivProtocol(SnmpServer.CBC_DES);
					} else {
						System.out.println(" Invalid PrivProtocol " + inputObject.getPrivProtocol());
						// opt.usage_error();
						throw new Exception("Invalid PrivProtocol " + inputObject.getPrivProtocol());
					}
				}
			}
			if (inputObject.getContextName() != null)
				target.setContextName(inputObject.getContextName());
			if (inputObject.getContextId() != null)
				target.setContextID(inputObject.getContextId());
		}

		if (target.getSnmpVersion() == SnmpTarget.VERSION3) {
			target.create_v3_tables();
		}

		// Put together OID and variable value lists from command line
		// oids and snmpvars
		String oids[] = new String[inputObject.getOids().size()];
		SnmpVar snmpvars[] = new SnmpVar[inputObject.getOids().size()];
		// int num_varbinds = 0;
		// for (int i = 1; i < opt.remArgs.length; i += 3) { // add Variable Bindings
		// if (opt.remArgs.length < i + 3) // need "{OID type value}"
		// opt.usage_error(); // unmatched arguments for name-type-value pairs
		// num_varbinds++;
		// }

		// oids = new String[num_varbinds];
		// snmpvars = new SnmpVar[num_varbinds];
		for (int i = 0; i < inputObject.getOids().size(); i++) { // add Variable Bindings
			oids[i] = inputObject.getOids().get(i).getOid();
			snmpvars[i] = inputObject.getOids().get(i).getSnmpVar();
		}

		try {
			target.setObjectIDList(oids); // set OID list on SnmpTarget
			snmpvars = target.snmpSetVariables(snmpvars);

			String result[] = null;
			if (snmpvars != null) {
				result = new String[snmpvars.length];
				for (int i = 0; i < snmpvars.length; i++) {
					if (snmpvars[i] != null) {
						result[i] = target.getMibOperations().toString(snmpvars[i], new SnmpOID(oids[i]));
					}
				}
			}

			if (result == null) {
				System.err.println("Request failed or timed out. \n" +
						target.getErrorString());

			} else { // print response

				for (int i = 0; i < oids.length; i++) {
					System.out.println(target.getObjectID(i) + ": " + result[i]);
				}
			}

			return true;

		} catch (Exception e) {
			System.err.println("Set Error: " + e.getMessage());
		}

		return false;
	}

	public static SnmpPDU setWithoutMib_Low(SnmpOperationInput inputObject) {
		// // Take care of getting options
		// String usage = "\nsnmpset [-d] [-v version(v1,v2,v3)] [-c community] \n" +
		// "[-wc writeCommunity] [-p port] [-r retries] \n" +
		// "[-t timeout] [-u user] [-a auth_protocol] \n" +
		// "[-w auth_password] [-s priv_password] \n" +
		// "[-n contextName] [-i contextID] \n" +
		// "[-DB_driver database_driver]\n" +
		// "[-DB_url database_url]\n" +
		// "[-DB_username database_username]\n" +
		// "[-DB_password database_password]\n" +
		// "[-pp privProtocol(DES/AES-128/AES-192/AES-256/3DES)]]\n" +
		// "host [OID {INTEGER | STRING | GAUGE | TIMETICKS | \n" +
		// "OPAQUE | IPADDRESS | COUNTER | OID } value] ...\n";

		// String options[] = {
		// "-d", "-c", "-wc", "-p", "-r", "-t", "-m",
		// "-v", "-u", "-a", "-w", "-s", "-n", "-i",
		// "-DB_driver", "-DB_url", "-DB_username", "-DB_password", "-pp"
		// };
		//
		// String values[] = {
		// "None", null, null, null, null, null, "None",
		// null, null, null, null, null, null, null,
		// null, null, null, null, null
		// };

		// ParseOptions opt = new ParseOptions(args, options, values, usage);
		// if (opt.remArgs.length < 1) {
		// opt.usage_error();
		// }

		// Start SNMP API
		SnmpAPI api;
		api = new SnmpAPI();
		if (inputObject.getDebug() != null && inputObject.getDebug().equals("Set"))
			api.setDebug(true);

		// Open session
		SnmpSession session = new SnmpSession(api);

		// int PORT = 3;

		SnmpPDU pdu = new SnmpPDU();
		UDPProtocolOptions ses_opt = new UDPProtocolOptions();
		ses_opt.setRemoteHost(inputObject.getHost());
		if (inputObject.getPort() != null) {
			try {
				ses_opt.setRemotePort(Integer.parseInt(inputObject.getPort()));
			} catch (Exception exp) {
				System.out.println("Invalid port: " + inputObject.getPort());
				System.exit(1);
			}
		}
		pdu.setProtocolOptions(ses_opt);

		// // set values
		// SetValues setVal = new SetValues(session, values);
		// if (setVal.usage_error) {
		// opt.usage_error();
		// }

		String driver = inputObject.getDbDriver();
		String url = inputObject.getDbUrl();
		String username = inputObject.getDbUserName();
		String password = inputObject.getDbPassword();
		if (driver != null || url != null ||
				username != null || password != null) {
			if (session.getVersion() != 3) {
				System.out.println(
						"Database option can be used only for SNMPv3.");
				System.exit(1);
			}
			if (driver == null) {
				System.out.println(
						"The Database driver name should be given.");
				System.exit(1);
			}
			if (url == null) {
				System.out.println("The Database URL should be given.");
				System.exit(1);
			}
			try {
				api.setV3DatabaseFlag(true);
				api.initJdbcParams(driver, url, username, password);
			} catch (Exception exp) {
				System.out.println("Unable to Establish Database Connection.");
				System.out.println("Please check the driverName and url.");
				System.exit(1);
			}
		}

		// Build set request PDU
		// SnmpPDU pdu = new SnmpPDU();
		pdu.setCommand(SnmpAPI.SET_REQ_MSG);

		// add Variable Bindings
		for (int i = 0; i < inputObject.getOids().size(); i++) {
			SnmpOid snmpOid = inputObject.getOids().get(i);

			// if (opt.remArgs.length < i + 3) {
			// opt.usage_error(); // need "{OID type value}"
			// }
			SnmpOID oid = new SnmpOID(snmpOid.getOid());
			if (oid.toValue() == null) {
				System.err.println("Invalid OID argument: " + snmpOid.getOid());
			} else {
				SnmpUtil.addVarBind(pdu, oid, snmpOid.getSnmpVar());
			}
		} // end of add variable bindings

		try {
			// open session
			session.open();
		} catch (SnmpException e) {
			System.err.println("Sending PDU" + e.getMessage());
		}

		if (session.getVersion() == SnmpAPI.SNMP_VERSION_3) {
			pdu.setUserName(inputObject.getUser().getBytes());
			try {
				USMUtils.init_v3_parameters(
						inputObject.getUser(),
						null,
						inputObject.getAuthProtocolInteger(),
						inputObject.getAuthPassword(),
						inputObject.getPrivPassword(),
						ses_opt,
						session,
						false,
						inputObject.getPrivProtocolInteger());
			} catch (SnmpException exp) {
				System.out.println(exp.getMessage());
				System.exit(1);
			}
			pdu.setContextName(inputObject.getContextName().getBytes());
			pdu.setContextID(inputObject.getContextId().getBytes());
		}

		SnmpPDU res_pdu = null;

		try // Send PDU receive response PDU
		{
			res_pdu = session.syncSend(pdu);
		} catch (SnmpException e) {
			System.err.println(e.getMessage());
			System.exit(1);
		}

		if (res_pdu == null) {
			// timeout
			System.out.println("Request timed out to: " + inputObject.getHost());
			System.exit(1);
		}

		String res = "Response PDU received from " + res_pdu.getProtocolOptions().getSessionId() + ".";
		if (res_pdu.getVersion() < 3) {
			res = res + " Community = " + res_pdu.getCommunity() + ".";
		}
		System.out.println(res);

		// Check for error in response
		if (res_pdu.getErrstat() != 0) {
			System.err.println(res_pdu.getError());
		} else {
			// print the response pdu varbinds
			System.out.println(res_pdu.printVarBinds());
		}

		// close session
		session.close();
		// stop api thread
		api.close();

		return res_pdu;
	}

}
