package com.dasanzhone.seawind.swservice.endpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.dasanzhone.namespace.weatherservice.WeatherException;
import com.dasanzhone.namespace.weatherservice.WeatherService;
import com.dasanzhone.namespace.weatherservice.general.ForecastRequest;
import com.dasanzhone.namespace.weatherservice.general.ForecastReturn;
import com.dasanzhone.namespace.weatherservice.general.WeatherInformationReturn;
import com.dasanzhone.namespace.weatherservice.general.WeatherReturn;
import com.dasanzhone.seawind.swservice.controller.WeatherServiceController;


public class WeatherServiceEndpoint implements WeatherService {

    private static final Logger LOG = LoggerFactory.getLogger(WeatherServiceEndpoint.class);

    @Autowired
    private WeatherServiceController weatherServiceController;
    
    @Override
    public ForecastReturn getCityForecastByZIP(ForecastRequest forecastRequest) throws WeatherException {
        LOG.debug("Method getCityForecastByZIP() was called. Processing the Request in the backend");

        return weatherServiceController.getCityForecastByZIP(forecastRequest);
    }
    
    @Override
    public WeatherInformationReturn getWeatherInformation(String zip) throws WeatherException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public WeatherReturn getCityWeatherByZIP(ForecastRequest forecastRequest) throws WeatherException {
        // TODO Auto-generated method stub
        return null;
    }

}
