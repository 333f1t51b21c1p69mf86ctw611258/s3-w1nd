
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
 *         &lt;element name="GetDeviceInformationResult" type="{http://www.dasanzhone.com/namespace/deviceservice/general}DeviceInformationReturn" minOccurs="0"/>
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
    "getDeviceInformationResult"
})
@XmlRootElement(name = "GetDeviceInformationResponse")
public class GetDeviceInformationResponse {

    @XmlElement(name = "GetDeviceInformationResult")
    protected DeviceInformationReturn getDeviceInformationResult;

    /**
     * Gets the value of the getDeviceInformationResult property.
     * 
     * @return
     *     possible object is
     *     {@link DeviceInformationReturn }
     *     
     */
    public DeviceInformationReturn getGetDeviceInformationResult() {
        return getDeviceInformationResult;
    }

    /**
     * Sets the value of the getDeviceInformationResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link DeviceInformationReturn }
     *     
     */
    public void setGetDeviceInformationResult(DeviceInformationReturn value) {
        this.getDeviceInformationResult = value;
    }

}
