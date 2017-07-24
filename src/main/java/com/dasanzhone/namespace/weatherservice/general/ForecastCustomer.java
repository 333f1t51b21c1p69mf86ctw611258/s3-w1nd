
package com.dasanzhone.namespace.weatherservice.general;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ForecastCustomer complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ForecastCustomer">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Age" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="Contribution" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="MethodOfPayment" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ForecastCustomer", propOrder = {
    "age",
    "contribution",
    "methodOfPayment"
})
public class ForecastCustomer {

    @XmlElement(name = "Age")
    protected int age;
    @XmlElement(name = "Contribution")
    protected int contribution;
    @XmlElement(name = "MethodOfPayment", required = true)
    protected String methodOfPayment;

    /**
     * Gets the value of the age property.
     * 
     */
    public int getAge() {
        return age;
    }

    /**
     * Sets the value of the age property.
     * 
     */
    public void setAge(int value) {
        this.age = value;
    }

    /**
     * Gets the value of the contribution property.
     * 
     */
    public int getContribution() {
        return contribution;
    }

    /**
     * Sets the value of the contribution property.
     * 
     */
    public void setContribution(int value) {
        this.contribution = value;
    }

    /**
     * Gets the value of the methodOfPayment property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMethodOfPayment() {
        return methodOfPayment;
    }

    /**
     * Sets the value of the methodOfPayment property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMethodOfPayment(String value) {
        this.methodOfPayment = value;
    }

}
