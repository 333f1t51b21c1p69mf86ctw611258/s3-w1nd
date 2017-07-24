
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
 *         &lt;element name="GetNetworkDeviceByIdResult" type="{http://www.dasanzhone.com/namespace/deviceservice/general}NetworkDeviceReturn" minOccurs="0"/>
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
    "getNetworkDeviceByIdResult"
})
@XmlRootElement(name = "GetNetworkDeviceByIdResponse")
public class GetNetworkDeviceByIdResponse {

    @XmlElement(name = "GetNetworkDeviceByIdResult")
    protected NetworkDeviceReturn getNetworkDeviceByIdResult;

    /**
     * Gets the value of the getNetworkDeviceByIdResult property.
     * 
     * @return
     *     possible object is
     *     {@link NetworkDeviceReturn }
     *     
     */
    public NetworkDeviceReturn getGetNetworkDeviceByIdResult() {
        return getNetworkDeviceByIdResult;
    }

    /**
     * Sets the value of the getNetworkDeviceByIdResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link NetworkDeviceReturn }
     *     
     */
    public void setGetNetworkDeviceByIdResult(NetworkDeviceReturn value) {
        this.getNetworkDeviceByIdResult = value;
    }

}
