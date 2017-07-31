
package com.dasanzhone.namespace.weatherservice.general;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import com.dasanzhone.namespace.weatherservice.datatypes.WeatherOverviewPdf;


/**
 * <p>Java class for WeatherInformationReturn complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="WeatherInformationReturn">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Success" type="{http://www.w3.org/2001/XMLSchema}boolean"/>
 *         &lt;element name="ResponseText" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="WeatherOverviewPdf" type="{http://www.dasanzhone.com/namespace/weatherservice/datatypes}WeatherOverviewPdf" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "WeatherInformationReturn", propOrder = {
    "success",
    "responseText",
    "weatherOverviewPdf"
})
public class WeatherInformationReturn {

    @XmlElement(name = "Success")
    protected boolean success;
    @XmlElement(name = "ResponseText")
    protected String responseText;
    @XmlElement(name = "WeatherOverviewPdf")
    protected WeatherOverviewPdf weatherOverviewPdf;

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
     * Gets the value of the weatherOverviewPdf property.
     * 
     * @return
     *     possible object is
     *     {@link WeatherOverviewPdf }
     *     
     */
    public WeatherOverviewPdf getWeatherOverviewPdf() {
        return weatherOverviewPdf;
    }

    /**
     * Sets the value of the weatherOverviewPdf property.
     * 
     * @param value
     *     allowed object is
     *     {@link WeatherOverviewPdf }
     *     
     */
    public void setWeatherOverviewPdf(WeatherOverviewPdf value) {
        this.weatherOverviewPdf = value;
    }

}
