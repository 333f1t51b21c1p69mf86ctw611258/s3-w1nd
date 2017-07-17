
package com.dasanzhone.namespace.weatherservice.exception;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


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
 *         &lt;element name="Uuid" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="timestamp" type="{http://www.w3.org/2001/XMLSchema}dateTime"/>
 *         &lt;element name="businessErrorId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="bigBusinessErrorCausingMoneyLoss" type="{http://www.w3.org/2001/XMLSchema}boolean"/>
 *         &lt;element name="exceptionDetails" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
    "uuid",
    "timestamp",
    "businessErrorId",
    "bigBusinessErrorCausingMoneyLoss",
    "exceptionDetails"
})
@XmlRootElement(name = "WeatherException")
public class WeatherException {

    @XmlElement(name = "Uuid", required = true)
    protected String uuid;
    @XmlElement(required = true)
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar timestamp;
    @XmlElement(required = true)
    protected String businessErrorId;
    protected boolean bigBusinessErrorCausingMoneyLoss;
    @XmlElement(required = true)
    protected String exceptionDetails;

    /**
     * Gets the value of the uuid property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUuid() {
        return uuid;
    }

    /**
     * Sets the value of the uuid property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUuid(String value) {
        this.uuid = value;
    }

    /**
     * Gets the value of the timestamp property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getTimestamp() {
        return timestamp;
    }

    /**
     * Sets the value of the timestamp property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setTimestamp(XMLGregorianCalendar value) {
        this.timestamp = value;
    }

    /**
     * Gets the value of the businessErrorId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBusinessErrorId() {
        return businessErrorId;
    }

    /**
     * Sets the value of the businessErrorId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBusinessErrorId(String value) {
        this.businessErrorId = value;
    }

    /**
     * Gets the value of the bigBusinessErrorCausingMoneyLoss property.
     * 
     */
    public boolean isBigBusinessErrorCausingMoneyLoss() {
        return bigBusinessErrorCausingMoneyLoss;
    }

    /**
     * Sets the value of the bigBusinessErrorCausingMoneyLoss property.
     * 
     */
    public void setBigBusinessErrorCausingMoneyLoss(boolean value) {
        this.bigBusinessErrorCausingMoneyLoss = value;
    }

    /**
     * Gets the value of the exceptionDetails property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getExceptionDetails() {
        return exceptionDetails;
    }

    /**
     * Sets the value of the exceptionDetails property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setExceptionDetails(String value) {
        this.exceptionDetails = value;
    }

}
