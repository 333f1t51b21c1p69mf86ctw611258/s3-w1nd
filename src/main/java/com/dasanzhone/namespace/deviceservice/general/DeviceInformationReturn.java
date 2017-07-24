
package com.dasanzhone.namespace.deviceservice.general;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import com.dasanzhone.namespace.deviceservice.datatypes.DeviceOverviewPdf;


/**
 * <p>Java class for DeviceInformationReturn complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DeviceInformationReturn">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Success" type="{http://www.w3.org/2001/XMLSchema}boolean"/>
 *         &lt;element name="ResponseText" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DeviceOverviewPdf" type="{http://www.dasanzhone.com/namespace/deviceservice/datatypes}DeviceOverviewPdf" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DeviceInformationReturn", propOrder = {
    "success",
    "responseText",
    "deviceOverviewPdf"
})
public class DeviceInformationReturn {

    @XmlElement(name = "Success")
    protected boolean success;
    @XmlElement(name = "ResponseText")
    protected String responseText;
    @XmlElement(name = "DeviceOverviewPdf")
    protected DeviceOverviewPdf deviceOverviewPdf;

    /**
     * Gets the value of the success property.
     * 
     */
    public boolean isSuccess() {
        return success;
    }

    /**
     * Sets the value of the success property.
     * 
     */
    public void setSuccess(boolean value) {
        this.success = value;
    }

    /**
     * Gets the value of the responseText property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getResponseText() {
        return responseText;
    }

    /**
     * Sets the value of the responseText property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setResponseText(String value) {
        this.responseText = value;
    }

    /**
     * Gets the value of the deviceOverviewPdf property.
     * 
     * @return
     *     possible object is
     *     {@link DeviceOverviewPdf }
     *     
     */
    public DeviceOverviewPdf getDeviceOverviewPdf() {
        return deviceOverviewPdf;
    }

    /**
     * Sets the value of the deviceOverviewPdf property.
     * 
     * @param value
     *     allowed object is
     *     {@link DeviceOverviewPdf }
     *     
     */
    public void setDeviceOverviewPdf(DeviceOverviewPdf value) {
        this.deviceOverviewPdf = value;
    }

}
