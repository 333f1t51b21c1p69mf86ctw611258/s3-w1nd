
package com.dasanzhone.namespace.weatherservice.general;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import com.dasanzhone.namespace.weatherservice.datatypes.ProductName;


/**
 * <p>Java class for ForecastRequest complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ForecastRequest">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="ZIP" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="flagcolor" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="productName" type="{http://www.dasanzhone.com/namespace/weatherservice/datatypes}ProductName"/>
 *         &lt;element name="ForecastCustomer" type="{http://www.dasanzhone.com/namespace/weatherservice/general}ForecastCustomer"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ForecastRequest", propOrder = {
    "zip",
    "flagcolor",
    "productName",
    "forecastCustomer"
})
public class ForecastRequest {

    @XmlElement(name = "ZIP")
    protected String zip;
    @XmlElement(required = true)
    protected String flagcolor;
    @XmlElement(required = true)
    protected ProductName productName;
    @XmlElement(name = "ForecastCustomer", required = true)
    protected ForecastCustomer forecastCustomer;

    /**
     * Gets the value of the zip property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZIP() {
        return zip;
    }

    /**
     * Sets the value of the zip property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZIP(String value) {
        this.zip = value;
    }

    /**
     * Gets the value of the flagcolor property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFlagcolor() {
        return flagcolor;
    }

    /**
     * Sets the value of the flagcolor property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFlagcolor(String value) {
        this.flagcolor = value;
    }

    /**
     * Gets the value of the productName property.
     * 
     * @return
     *     possible object is
     *     {@link ProductName }
     *     
     */
    public ProductName getProductName() {
        return productName;
    }

    /**
     * Sets the value of the productName property.
     * 
     * @param value
     *     allowed object is
     *     {@link ProductName }
     *     
     */
    public void setProductName(ProductName value) {
        this.productName = value;
    }

    /**
     * Gets the value of the forecastCustomer property.
     * 
     * @return
     *     possible object is
     *     {@link ForecastCustomer }
     *     
     */
    public ForecastCustomer getForecastCustomer() {
        return forecastCustomer;
    }

    /**
     * Sets the value of the forecastCustomer property.
     * 
     * @param value
     *     allowed object is
     *     {@link ForecastCustomer }
     *     
     */
    public void setForecastCustomer(ForecastCustomer value) {
        this.forecastCustomer = value;
    }

}
