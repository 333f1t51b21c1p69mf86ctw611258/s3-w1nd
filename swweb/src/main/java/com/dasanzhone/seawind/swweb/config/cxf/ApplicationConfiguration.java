package com.dasanzhone.seawind.swweb.config.cxf;

import com.dasanzhone.seawind.swservice.controller.DeviceServiceController;
import com.dasanzhone.seawind.swservice.controller.WeatherServiceController;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


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
