package com.dasanzhone.seawind.swservice.configuration;

import javax.xml.ws.Endpoint;

import org.apache.cxf.Bus;
import org.apache.cxf.bus.spring.SpringBus;
import org.apache.cxf.interceptor.AbstractLoggingInterceptor;
import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.apache.cxf.jaxws.EndpointImpl;
import org.apache.cxf.transport.servlet.CXFServlet;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.dasanzhone.namespace.deviceservice.Device;
import com.dasanzhone.namespace.deviceservice.DeviceService;
import com.dasanzhone.namespace.weatherservice.Weather;
import com.dasanzhone.namespace.weatherservice.WeatherService;
import com.dasanzhone.seawind.swservice.endpoint.DeviceServiceEndpoint;
import com.dasanzhone.seawind.swservice.endpoint.WeatherServiceEndpoint;
import com.dasanzhone.seawind.swservice.soapmsglogging.SoapMsgToMdcExtractionLoggingInInterceptor;
import com.dasanzhone.seawind.swservice.soapmsglogging.SoapMsgToMdcExtractionLoggingOutInterceptor;

@Configuration
public class WebServiceConfiguration {

    public static final String BASE_URL = "/soap-api";
    public static final String SERVICE_URL_DEVICE = "/DeviceSoapService_1.0";
    public static final String SERVICE_URL_WEATHER = "/WeatherSoapService_1.0";

    @Bean
    public ServletRegistrationBean cxfServlet() {
        return new ServletRegistrationBean(new CXFServlet(), BASE_URL + "/*");
    }

    @Bean(name = Bus.DEFAULT_BUS_ID)
    public SpringBus springBus() {
        SpringBus springBus = new SpringBus();
        springBus.getInInterceptors().add(logInInterceptor());
        springBus.getInFaultInterceptors().add(logInInterceptor());
        springBus.getOutInterceptors().add(logOutInterceptor());
        springBus.getOutFaultInterceptors().add(logOutInterceptor());
        return springBus;
    }

    @Bean
    public WeatherService weatherService() {
    	return new WeatherServiceEndpoint();
    }

    @Bean
    public DeviceService deviceService() {
    	return new DeviceServiceEndpoint();
    }

    @Bean
    public Endpoint endpoint_Weather() {
        EndpointImpl endpoint = new EndpointImpl(springBus(), weatherService());
        // CXF JAX-WS implementation relies on the correct ServiceName as QName-Object with
        // the name-Attribute´s text <wsdl:service name="Weather"> and the targetNamespace
        // "http://www.dasanzhone.com/namespace/weatherservice/"
        // Also the WSDLLocation must be set
        endpoint.setServiceName(weather().getServiceName());
        endpoint.setWsdlLocation(weather().getWSDLDocumentLocation().toString());
        endpoint.publish(SERVICE_URL_WEATHER);
        return endpoint;
    }

    @Bean
    public Endpoint endpoint_Device() {
        EndpointImpl endpoint = new EndpointImpl(springBus(), deviceService());
        // CXF JAX-WS implementation relies on the correct ServiceName as QName-Object with
        // the name-Attribute´s text <wsdl:service name="Device"> and the targetNamespace
        // "http://www.dasanzhone.com/namespace/deviceservice/"
        // Also the WSDLLocation must be set
        endpoint.setServiceName(device().getServiceName());
        endpoint.setWsdlLocation(device().getWSDLDocumentLocation().toString());
        endpoint.publish(SERVICE_URL_DEVICE);
        return endpoint;
    }

    @Bean
    public Weather weather() {
        // Needed for correct ServiceName & WSDLLocation to publish contract first incl. original WSDL
        return new Weather();
    }

    @Bean
    public Device device() {
        // Needed for correct ServiceName & WSDLLocation to publish contract first incl. original WSDL
        return new Device();
    }

    @Bean
    public AbstractLoggingInterceptor logInInterceptor() {
        LoggingInInterceptor logInInterceptor = new SoapMsgToMdcExtractionLoggingInInterceptor();
        logInInterceptor.setPrettyLogging(true);
        return logInInterceptor;
    }

    @Bean
    public AbstractLoggingInterceptor logOutInterceptor() {
        LoggingOutInterceptor logOutInterceptor = new SoapMsgToMdcExtractionLoggingOutInterceptor();
        logOutInterceptor.setPrettyLogging(true);
        return logOutInterceptor;
    }
}
