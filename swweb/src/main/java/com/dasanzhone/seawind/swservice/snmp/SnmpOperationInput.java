package com.dasanzhone.seawind.swservice.snmp;

import java.util.ArrayList;
import java.util.List;

import org.apache.cxf.common.util.StringUtils;

import com.adventnet.snmp.beans.SnmpTarget;

public class SnmpOperationInput {

	private String version;
	private String mibs;
	private String community;
	private String port;
	private String timeout;
	private String retries;
	private String user;

	private String dbDriver;
	private String dbUrl;
	private String dbUserName;
	private String dbPassword;

	private String authProtocol;
	private String authPassword;
	private String privProtocol;
	private String privPassword;
	private String contextName;
	private String contextId;
	private String debug;
	private String host;
	private List<SnmpOid> oids = new ArrayList<SnmpOid>();

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getMibs() {
		return mibs;
	}

	public void setMibs(String mibs) {
		this.mibs = mibs;
	}

	public String getCommunity() {
		return community;
	}

	public void setCommunity(String community) {
		this.community = community;
	}

	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}

	public String getTimeout() {
		return timeout;
	}

	public void setTimeout(String timeout) {
		this.timeout = timeout;
	}

	public String getRetries() {
		return retries;
	}

	public void setRetries(String retries) {
		this.retries = retries;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getDbDriver() {
		return dbDriver;
	}

	public void setDbDriver(String dbDriver) {
		this.dbDriver = dbDriver;
	}

	public String getDbUrl() {
		return dbUrl;
	}

	public void setDbUrl(String dbUrl) {
		this.dbUrl = dbUrl;
	}

	public String getDbUserName() {
		return dbUserName;
	}

	public void setDbUserName(String dbUserName) {
		this.dbUserName = dbUserName;
	}

	public String getDbPassword() {
		return dbPassword;
	}

	public void setDbPassword(String dbPassword) {
		this.dbPassword = dbPassword;
	}

	public String getAuthProtocol() {
		return authProtocol;
	}

	public void setAuthProtocol(String authProtocol) {
		this.authProtocol = authProtocol;
	}

	public String getAuthPassword() {
		return authPassword;
	}

	public void setAuthPassword(String authPassword) {
		this.authPassword = authPassword;
	}

	public String getPrivProtocol() {
		return privProtocol;
	}

	public void setPrivProtocol(String privProtocol) {
		this.privProtocol = privProtocol;
	}

	public String getPrivPassword() {
		return privPassword;
	}

	public void setPrivPassword(String privPassword) {
		this.privPassword = privPassword;
	}

	public String getContextName() {
		return contextName;
	}

	public void setContextName(String contextName) {
		this.contextName = contextName;
	}

	public String getContextId() {
		return contextId;
	}

	public void setContextId(String contextId) {
		this.contextId = contextId;
	}

	public String getDebug() {
		return debug;
	}

	public void setDebug(String debug) {
		this.debug = debug;
	}

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public List<SnmpOid> getOids() {
		return oids;
	}

	public void setOids(List<SnmpOid> oids) {
		this.oids = oids;
	}

	public int getAuthProtocolInteger() {
		if (StringUtils.isEmpty(authProtocol))
			return SnmpTarget.NO_AUTH;
		else if (authProtocol.equals("SHA"))
			return SnmpTarget.SHA_AUTH;
		else if (authProtocol.equals("MD5"))
			return SnmpTarget.MD5_AUTH;
		else
			return SnmpTarget.NO_AUTH;
	}

	public Integer getPrivProtocolInteger() {
		if (privProtocol != null) {
			if (privProtocol.equals("AES-128")) {
				return SnmpTarget.CFB_AES_128;
			} else if (privProtocol.equals("AES-192")) {
				return SnmpTarget.CFB_AES_192;
			} else if (privProtocol.equals("AES-256")) {
				return SnmpTarget.CFB_AES_256;
			} else if (privProtocol.equals("3DES")) {
				return SnmpTarget.CBC_3DES;
			} else if (privProtocol.equals("DES")) {
				return SnmpTarget.CBC_DES;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

}
