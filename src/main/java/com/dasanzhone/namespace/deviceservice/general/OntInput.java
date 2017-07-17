
package com.dasanzhone.namespace.deviceservice.general;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for OntInput complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="OntInput">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="OntInterface" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="OntSlot" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="OntPort" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="SwVerPland" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="SwDnloadVersion" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Sernum" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="FecUp" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="EnableAes" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="PlndVar" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="OpticsHist" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Berint" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Provversion" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="AdminState" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="PlannedCardType" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Plndnumdataports" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="Plndnumvoiceports" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="AutoDetect" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "OntInput", propOrder = {
    "ontInterface",
    "ontSlot",
    "ontPort",
    "swVerPland",
    "swDnloadVersion",
    "sernum",
    "fecUp",
    "enableAes",
    "plndVar",
    "opticsHist",
    "berint",
    "provversion",
    "adminState",
    "plannedCardType",
    "plndnumdataports",
    "plndnumvoiceports",
    "autoDetect"
})
public class OntInput {

    @XmlElement(name = "OntInterface")
    protected String ontInterface;
    @XmlElement(name = "OntSlot")
    protected String ontSlot;
    @XmlElement(name = "OntPort")
    protected String ontPort;
    @XmlElement(name = "SwVerPland")
    protected String swVerPland;
    @XmlElement(name = "SwDnloadVersion")
    protected String swDnloadVersion;
    @XmlElement(name = "Sernum")
    protected String sernum;
    @XmlElement(name = "FecUp")
    protected String fecUp;
    @XmlElement(name = "EnableAes")
    protected String enableAes;
    @XmlElement(name = "PlndVar")
    protected String plndVar;
    @XmlElement(name = "OpticsHist")
    protected String opticsHist;
    @XmlElement(name = "Berint")
    protected String berint;
    @XmlElement(name = "Provversion")
    protected String provversion;
    @XmlElement(name = "AdminState")
    protected String adminState;
    @XmlElement(name = "PlannedCardType")
    protected String plannedCardType;
    @XmlElement(name = "Plndnumdataports")
    protected String plndnumdataports;
    @XmlElement(name = "Plndnumvoiceports")
    protected String plndnumvoiceports;
    @XmlElement(name = "AutoDetect")
    protected String autoDetect;

    /**
     * Gets the value of the ontInterface property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOntInterface() {
        return ontInterface;
    }

    /**
     * Sets the value of the ontInterface property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOntInterface(String value) {
        this.ontInterface = value;
    }

    /**
     * Gets the value of the ontSlot property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOntSlot() {
        return ontSlot;
    }

    /**
     * Sets the value of the ontSlot property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOntSlot(String value) {
        this.ontSlot = value;
    }

    /**
     * Gets the value of the ontPort property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOntPort() {
        return ontPort;
    }

    /**
     * Sets the value of the ontPort property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOntPort(String value) {
        this.ontPort = value;
    }

    /**
     * Gets the value of the swVerPland property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSwVerPland() {
        return swVerPland;
    }

    /**
     * Sets the value of the swVerPland property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSwVerPland(String value) {
        this.swVerPland = value;
    }

    /**
     * Gets the value of the swDnloadVersion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSwDnloadVersion() {
        return swDnloadVersion;
    }

    /**
     * Sets the value of the swDnloadVersion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSwDnloadVersion(String value) {
        this.swDnloadVersion = value;
    }

    /**
     * Gets the value of the sernum property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSernum() {
        return sernum;
    }

    /**
     * Sets the value of the sernum property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSernum(String value) {
        this.sernum = value;
    }

    /**
     * Gets the value of the fecUp property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFecUp() {
        return fecUp;
    }

    /**
     * Sets the value of the fecUp property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFecUp(String value) {
        this.fecUp = value;
    }

    /**
     * Gets the value of the enableAes property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEnableAes() {
        return enableAes;
    }

    /**
     * Sets the value of the enableAes property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEnableAes(String value) {
        this.enableAes = value;
    }

    /**
     * Gets the value of the plndVar property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPlndVar() {
        return plndVar;
    }

    /**
     * Sets the value of the plndVar property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPlndVar(String value) {
        this.plndVar = value;
    }

    /**
     * Gets the value of the opticsHist property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOpticsHist() {
        return opticsHist;
    }

    /**
     * Sets the value of the opticsHist property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOpticsHist(String value) {
        this.opticsHist = value;
    }

    /**
     * Gets the value of the berint property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBerint() {
        return berint;
    }

    /**
     * Sets the value of the berint property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBerint(String value) {
        this.berint = value;
    }

    /**
     * Gets the value of the provversion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProvversion() {
        return provversion;
    }

    /**
     * Sets the value of the provversion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProvversion(String value) {
        this.provversion = value;
    }

    /**
     * Gets the value of the adminState property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdminState() {
        return adminState;
    }

    /**
     * Sets the value of the adminState property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdminState(String value) {
        this.adminState = value;
    }

    /**
     * Gets the value of the plannedCardType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPlannedCardType() {
        return plannedCardType;
    }

    /**
     * Sets the value of the plannedCardType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPlannedCardType(String value) {
        this.plannedCardType = value;
    }

    /**
     * Gets the value of the plndnumdataports property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPlndnumdataports() {
        return plndnumdataports;
    }

    /**
     * Sets the value of the plndnumdataports property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPlndnumdataports(String value) {
        this.plndnumdataports = value;
    }

    /**
     * Gets the value of the plndnumvoiceports property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPlndnumvoiceports() {
        return plndnumvoiceports;
    }

    /**
     * Sets the value of the plndnumvoiceports property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPlndnumvoiceports(String value) {
        this.plndnumvoiceports = value;
    }

    /**
     * Gets the value of the autoDetect property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAutoDetect() {
        return autoDetect;
    }

    /**
     * Sets the value of the autoDetect property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAutoDetect(String value) {
        this.autoDetect = value;
    }

}
