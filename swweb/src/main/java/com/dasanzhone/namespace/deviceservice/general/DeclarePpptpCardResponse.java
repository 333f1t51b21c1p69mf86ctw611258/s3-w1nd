
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
 *         &lt;element name="DeclarePpptpCardResult" type="{http://www.dasanzhone.com/namespace/deviceservice/general}CommonOperationReturn" minOccurs="0"/>
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
    "declarePpptpCardResult"
})
@XmlRootElement(name = "DeclarePpptpCardResponse")
public class DeclarePpptpCardResponse {

    @XmlElement(name = "DeclarePpptpCardResult")
    protected CommonOperationReturn declarePpptpCardResult;

    /**
     * Gets the value of the declarePpptpCardResult property.
     * 
     * @return
     *     possible object is
     *     {@link CommonOperationReturn }
     *     
     */
    public CommonOperationReturn getDeclarePpptpCardResult() {
        return declarePpptpCardResult;
    }

    /**
     * Sets the value of the declarePpptpCardResult property.
     * 
     * @param value
     *     allowed object is
     *     {@link CommonOperationReturn }
     *     
     */
    public void setDeclarePpptpCardResult(CommonOperationReturn value) {
        this.declarePpptpCardResult = value;
    }

}
