package com.dasanzhone.seawind.swservice.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.dasanzhone.seawind.swservice.controller.DeviceServiceController;
import com.dasanzhone.seawind.swservice.controller.WeatherServiceController;


@Configuration
public class ApplicationConfiguration {

	@Bean
	public WeatherServiceController weatherServiceController() {
		return new WeatherServiceController();
	}
	
	@Bean
	public DeviceServiceController deviceServiceController() {
		return new DeviceServiceController();
	}
	
}
