
package com.dasanzhone.namespace.deviceservice.datatypes;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ProductName.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="ProductName">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="ForecastBasic"/>
 *     &lt;enumeration value="ForecastProfessional"/>
 *     &lt;enumeration value="ForecastUltimateXL"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "ProductName")
@XmlEnum
public enum ProductName {

    @XmlEnumValue("ForecastBasic")
    FORECAST_BASIC("ForecastBasic"),
    @XmlEnumValue("ForecastProfessional")
    FORECAST_PROFESSIONAL("ForecastProfessional"),
    @XmlEnumValue("ForecastUltimateXL")
    FORECAST_ULTIMATE_XL("ForecastUltimateXL");
    private final String value;

    ProductName(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static ProductName fromValue(String v) {
        for (ProductName c: ProductName.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
