
package com.dasanzhone.namespace.deviceservice.general;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.dasanzhone.namespace.deviceservice.general package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _NetworkDeviceReturn_QNAME = new QName("http://www.dasanzhone.com/namespace/deviceservice/general", "NetworkDeviceReturn");
    private final static QName _DeviceReturn_QNAME = new QName("http://www.dasanzhone.com/namespace/deviceservice/general", "DeviceReturn");
    private final static QName _ForecastReturn_QNAME = new QName("http://www.dasanzhone.com/namespace/deviceservice/general", "ForecastReturn");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.dasanzhone.namespace.deviceservice.general
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link DeclareOntIdResponse }
     * 
     */
    public DeclareOntIdResponse createDeclareOntIdResponse() {
        return new DeclareOntIdResponse();
    }

    /**
     * Create an instance of {@link CommonOperationReturn }
     * 
     */
    public CommonOperationReturn createCommonOperationReturn() {
        return new CommonOperationReturn();
    }

    /**
     * Create an instance of {@link GetCityForecastByZIP }
     * 
     */
    public GetCityForecastByZIP createGetCityForecastByZIP() {
        return new GetCityForecastByZIP();
    }

    /**
     * Create an instance of {@link ForecastRequest }
     * 
     */
    public ForecastRequest createForecastRequest() {
        return new ForecastRequest();
    }

    /**
     * Create an instance of {@link GetNetworkDeviceById }
     * 
     */
    public GetNetworkDeviceById createGetNetworkDeviceById() {
        return new GetNetworkDeviceById();
    }

    /**
     * Create an instance of {@link ActivateDeactivateOntId }
     * 
     */
    public ActivateDeactivateOntId createActivateDeactivateOntId() {
        return new ActivateDeactivateOntId();
    }

    /**
     * Create an instance of {@link OntInput }
     * 
     */
    public OntInput createOntInput() {
        return new OntInput();
    }

    /**
     * Create an instance of {@link ForecastReturn }
     * 
     */
    public ForecastReturn createForecastReturn() {
        return new ForecastReturn();
    }

    /**
     * Create an instance of {@link ActivateDeactivateOntIdResponse }
     * 
     */
    public ActivateDeactivateOntIdResponse createActivateDeactivateOntIdResponse() {
        return new ActivateDeactivateOntIdResponse();
    }

    /**
     * Create an instance of {@link NetworkDeviceReturn }
     * 
     */
    public NetworkDeviceReturn createNetworkDeviceReturn() {
        return new NetworkDeviceReturn();
    }

    /**
     * Create an instance of {@link DeclareOntId }
     * 
     */
    public DeclareOntId createDeclareOntId() {
        return new DeclareOntId();
    }

    /**
     * Create an instance of {@link DeclarePpptpCard }
     * 
     */
    public DeclarePpptpCard createDeclarePpptpCard() {
        return new DeclarePpptpCard();
    }

    /**
     * Create an instance of {@link DeclarePpptpCardResponse }
     * 
     */
    public DeclarePpptpCardResponse createDeclarePpptpCardResponse() {
        return new DeclarePpptpCardResponse();
    }

    /**
     * Create an instance of {@link GetCityForecastByZIPResponse }
     * 
     */
    public GetCityForecastByZIPResponse createGetCityForecastByZIPResponse() {
        return new GetCityForecastByZIPResponse();
    }

    /**
     * Create an instance of {@link GetDeviceInformationResponse }
     * 
     */
    public GetDeviceInformationResponse createGetDeviceInformationResponse() {
        return new GetDeviceInformationResponse();
    }

    /**
     * Create an instance of {@link DeviceInformationReturn }
     * 
     */
    public DeviceInformationReturn createDeviceInformationReturn() {
        return new DeviceInformationReturn();
    }

    /**
     * Create an instance of {@link ConfigureUniLanPorts }
     * 
     */
    public ConfigureUniLanPorts createConfigureUniLanPorts() {
        return new ConfigureUniLanPorts();
    }

    /**
     * Create an instance of {@link GetCityDeviceByZIPResponse }
     * 
     */
    public GetCityDeviceByZIPResponse createGetCityDeviceByZIPResponse() {
        return new GetCityDeviceByZIPResponse();
    }

    /**
     * Create an instance of {@link DeviceReturn }
     * 
     */
    public DeviceReturn createDeviceReturn() {
        return new DeviceReturn();
    }

    /**
     * Create an instance of {@link GetCityDeviceByZIP }
     * 
     */
    public GetCityDeviceByZIP createGetCityDeviceByZIP() {
        return new GetCityDeviceByZIP();
    }

    /**
     * Create an instance of {@link GetNetworkDeviceByIdResponse }
     * 
     */
    public GetNetworkDeviceByIdResponse createGetNetworkDeviceByIdResponse() {
        return new GetNetworkDeviceByIdResponse();
    }

    /**
     * Create an instance of {@link GetDeviceInformation }
     * 
     */
    public GetDeviceInformation createGetDeviceInformation() {
        return new GetDeviceInformation();
    }

    /**
     * Create an instance of {@link ConfigureUniLanPortsResponse }
     * 
     */
    public ConfigureUniLanPortsResponse createConfigureUniLanPortsResponse() {
        return new ConfigureUniLanPortsResponse();
    }

    /**
     * Create an instance of {@link ForecastCustomer }
     * 
     */
    public ForecastCustomer createForecastCustomer() {
        return new ForecastCustomer();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link NetworkDeviceReturn }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.dasanzhone.com/namespace/deviceservice/general", name = "NetworkDeviceReturn")
    public JAXBElement<NetworkDeviceReturn> createNetworkDeviceReturn(NetworkDeviceReturn value) {
        return new JAXBElement<NetworkDeviceReturn>(_NetworkDeviceReturn_QNAME, NetworkDeviceReturn.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link DeviceReturn }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.dasanzhone.com/namespace/deviceservice/general", name = "DeviceReturn")
    public JAXBElement<DeviceReturn> createDeviceReturn(DeviceReturn value) {
        return new JAXBElement<DeviceReturn>(_DeviceReturn_QNAME, DeviceReturn.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ForecastReturn }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.dasanzhone.com/namespace/deviceservice/general", name = "ForecastReturn")
    public JAXBElement<ForecastReturn> createForecastReturn(ForecastReturn value) {
        return new JAXBElement<ForecastReturn>(_ForecastReturn_QNAME, ForecastReturn.class, null, value);
    }

}
