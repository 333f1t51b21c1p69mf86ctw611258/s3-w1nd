
package com.dasanzhone.namespace.deviceservice.general;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="GetCityDeviceByZIPResult" type="{http://www.dasanzhone.com/namespace/deviceservice/general}DeviceReturn"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "getCityDeviceByZIPResult"
})
@XmlRootElement(name = "GetCityDeviceByZIPResponse")
public class GetCityDeviceByZIPResponse {

    @XmlElement(name = "GetCityDeviceByZIPResult", required = true)
    protected DeviceReturn getCityDeviceByZIPResult;

    /**
     * Gets the value of the getCityDeviceByZIPResult property.
     * 
     * @return
     *     possible object is
     *     {@link DeviceReturn }
     *     
     */
    public DeviceReturn getGetCityDeviceByZIPResult() {
        return getCityDeviceByZIPResult;
    }

    /**
     * Sets the value of the getCityDeviceByZIPResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link DeviceReturn }
     *     
     */
    public void setGetCityDeviceByZIPResult(DeviceReturn value) {
        this.getCityDeviceByZIPResult = value;
    }

}
