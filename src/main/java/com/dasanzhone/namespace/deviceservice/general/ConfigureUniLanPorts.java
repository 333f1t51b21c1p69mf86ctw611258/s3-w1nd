
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
 *         &lt;element name="OntInput" type="{http://www.dasanzhone.com/namespace/deviceservice/general}OntInput" minOccurs="0"/>
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
    "ontInput"
})
@XmlRootElement(name = "ConfigureUniLanPorts")
public class ConfigureUniLanPorts {

    @XmlElement(name = "OntInput")
    protected OntInput ontInput;

    /**
     * Gets the value of the ontInput property.
     * 
     * @return
     *     possible object is
     *     {@link OntInput }
     *     
     */
    public OntInput getOntInput() {
        return ontInput;
    }

    /**
     * Sets the value of the ontInput property.
     * 
     * @param value
     *     allowed object is
     *     {@link OntInput }
     *     
     */
    public void setOntInput(OntInput value) {
        this.ontInput = value;
    }

}
