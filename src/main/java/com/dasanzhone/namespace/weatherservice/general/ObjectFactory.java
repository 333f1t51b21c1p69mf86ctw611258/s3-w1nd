
package com.dasanzhone.namespace.weatherservice.general;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.dasanzhone.namespace.weatherservice.general package. 
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

    private final static QName _WeatherReturn_QNAME = new QName("http://www.dasanzhone.com/namespace/weatherservice/general", "WeatherReturn");
    private final static QName _ForecastReturn_QNAME = new QName("http://www.dasanzhone.com/namespace/weatherservice/general", "ForecastReturn");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.dasanzhone.namespace.weatherservice.general
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link GetWeatherInformationResponse }
     * 
     */
    public GetWeatherInformationResponse createGetWeatherInformationResponse() {
        return new GetWeatherInformationResponse();
    }

    /**
     * Create an instance of {@link WeatherInformationReturn }
     * 
     */
    public WeatherInformationReturn createWeatherInformationReturn() {
        return new WeatherInformationReturn();
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
     * Create an instance of {@link GetCityWeatherByZIPResponse }
     * 
     */
    public GetCityWeatherByZIPResponse createGetCityWeatherByZIPResponse() {
        return new GetCityWeatherByZIPResponse();
    }

    /**
     * Create an instance of {@link WeatherReturn }
     * 
     */
    public WeatherReturn createWeatherReturn() {
        return new WeatherReturn();
    }

    /**
     * Create an instance of {@link GetWeatherInformation }
     * 
     */
    public GetWeatherInformation createGetWeatherInformation() {
        return new GetWeatherInformation();
    }

    /**
     * Create an instance of {@link GetCityWeatherByZIP }
     * 
     */
    public GetCityWeatherByZIP createGetCityWeatherByZIP() {
        return new GetCityWeatherByZIP();
    }

    /**
     * Create an instance of {@link ForecastReturn }
     * 
     */
    public ForecastReturn createForecastReturn() {
        return new ForecastReturn();
    }

    /**
     * Create an instance of {@link GetCityForecastByZIPResponse }
     * 
     */
    public GetCityForecastByZIPResponse createGetCityForecastByZIPResponse() {
        return new GetCityForecastByZIPResponse();
    }

    /**
     * Create an instance of {@link ForecastCustomer }
     * 
     */
    public ForecastCustomer createForecastCustomer() {
        return new ForecastCustomer();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link WeatherReturn }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.dasanzhone.com/namespace/weatherservice/general", name = "WeatherReturn")
    public JAXBElement<WeatherReturn> createWeatherReturn(WeatherReturn value) {
        return new JAXBElement<WeatherReturn>(_WeatherReturn_QNAME, WeatherReturn.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ForecastReturn }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://www.dasanzhone.com/namespace/weatherservice/general", name = "ForecastReturn")
    public JAXBElement<ForecastReturn> createForecastReturn(ForecastReturn value) {
        return new JAXBElement<ForecastReturn>(_ForecastReturn_QNAME, ForecastReturn.class, null, value);
    }

}
