package com.dasanzhone.seawind.swservice.entity;

import java.util.HashMap;
import java.util.Map;

import net.logstash.logback.encoder.org.apache.commons.lang.StringUtils;

public class OntInputParamMapper {

	public static final String STRING_DOWN = "down";
	public static final String STRING_UP = "up";
	public static final String STRING_DISABLE = "disable";
	public static final String STRING_ENABLE = "enable";

	private String defaultValue;
	private Map<String, String> mapValues = new HashMap<String, String>();

	private String rawValue;

	public OntInputParamMapper() {

	}

	public OntInputParamMapper(String defaultValue, String rawValue) {
		this.defaultValue = defaultValue;
		this.rawValue = rawValue;
	}

	public String getDefaultValue() {
		return defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public Map<String, String> getMapValues() {
		return mapValues;
	}

	public void setMapValues(Map<String, String> mapValues) {
		this.mapValues = mapValues;
	}

	public String getRawValue() {
		return rawValue;
	}

	public void setRawValue(String rawValue) {
		this.rawValue = rawValue;
	}

	public String getFinalValue() {
		if (StringUtils.isEmpty(this.getRawValue())) {
			return this.getDefaultValue();
		} else if (this.getMapValues() != null && this.getMapValues().size() > 0) {
			return this.getMapValues().get(this.getRawValue());
		} else {
			return this.getRawValue();
		}
	}

}
