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
@Component
public class SchedulerManager implements ApplicationContextAware {

    private ApplicationContext applicationContext;

    @Value("${iot.types}")
    private String[] iotTypes;

    @Value("${pump.devices}")
    private Long[] devices;

    @Value("${iot.frequency}")
    private Integer frequency;

    @Autowired
    private Config config;

    @Autowired
    private MqttProducer mqttProducer;

    private ScheduledExecutorService executorService;

    @PostConstruct
    public void startup() {
        log.info("Starting up...");

        executorService = Executors.newScheduledThreadPool(iotTypes.length);

        // TODO remove comment
        // For each type of iot, get a (new?) sensor bean from the application context
        for (String iotType : iotTypes) {
            for (Long deviceId : devices) {

                try {

                    Sensor sensor = SensorFactory.create(iotType, deviceId);

                    mqttProducer.connect(sensor.getPump());

                    log.info("Starting Sensor: " + sensor.getSensorType());
                    executorService.scheduleAtFixedRate(new SensorRunner(sensor, config, mqttProducer), 0, frequency, TimeUnit.SECONDS);

                } catch (NoSuchBeanDefinitionException nsbde) {
                    log.warning("Sensor type " + iotType + " not available");
                }

            }
        }

    }

    @PreDestroy
    public void shutdown() {
        log.info("Shutting Down");

        if (executorService != null) {
            executorService.shutdownNow();
        }
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }


}
