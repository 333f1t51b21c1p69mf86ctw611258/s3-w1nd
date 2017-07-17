
package com.dasanzhone.namespace.weatherservice.datatypes;

import javax.xml.bind.annotation.XmlRegistry;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.dasanzhone.namespace.weatherservice.datatypes package. 
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


    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.dasanzhone.namespace.weatherservice.datatypes
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link POP }
     * 
     */
    public POP createPOP() {
        return new POP();
    }

    /**
     * Create an instance of {@link Temp }
     * 
     */
    public Temp createTemp() {
        return new Temp();
    }

    /**
     * Create an instance of {@link WeatherOverviewPdf }
     * 
     */
    public WeatherOverviewPdf createWeatherOverviewPdf() {
        return new WeatherOverviewPdf();
    }

    /**
     * Create an instance of {@link WeatherDescription }
     * 
     */
    public WeatherDescription createWeatherDescription() {
        return new WeatherDescription();
    }

    /**
     * Create an instance of {@link Forecast }
     * 
     */
    public Forecast createForecast() {
        return new Forecast();
    }

    /**
     * Create an instance of {@link ArrayOfForecast }
     * 
     */
    public ArrayOfForecast createArrayOfForecast() {
        return new ArrayOfForecast();
    }

}
