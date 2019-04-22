package com.redhat.iot.util;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import com.redhat.iot.model.Sensor;
import com.redhat.iot.model.SensorFactory;
import lombok.extern.java.Log;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Log
public class SchedulerManager implements ApplicationContextAware {

    private ApplicationContext applicationContext;

//    @Value("${iot.types}")
//    private String[] iotTypes;
//
//    @Value("${pump.devices}")
//    private Long[] devices;
//
//    @Value("${iot.frequency}")
//    private Integer frequency;
//
//    @Value("${app.name}")
//    private String appName;
//
//    @Autowired
//    private Config config;
//
//    @Autowired
//    private MqttProducer mqttProducer;
//
//    private ScheduledExecutorService executorService;
//
//    @PostConstruct
//    public void startup() {
//        log.info(String.format("Starting up %d thread(s)...", iotTypes.length));
//
//        executorService = Executors.newScheduledThreadPool(iotTypes.length);
//
//        for (String iotType : iotTypes) {
//            for (Long deviceId : devices) {
//                Sensor sensor = SensorFactory.create(iotType, deviceId);
//                mqttProducer.connect(appName);
//                log.info(String.format("Starting Sensor: %s, Pump: %s", sensor.getSensorType(), deviceId.toString()));
//                executorService.scheduleAtFixedRate(new SensorRunner(sensor, config, mqttProducer), 0, frequency, TimeUnit.SECONDS);
//            }
//        }
//
//    }
//
//    @PreDestroy
//    public void shutdown() {
//        log.info("Shutting Down");
//
//        if (executorService != null) {
//            executorService.shutdownNow();
//        }
//    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }


}
