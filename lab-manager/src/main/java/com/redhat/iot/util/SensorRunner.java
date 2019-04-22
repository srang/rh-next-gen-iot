package com.redhat.iot.util;

import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

import com.redhat.iot.api.SensorData;
import com.redhat.iot.model.Sensor;
import com.redhat.iot.model.SensorFactory;
import lombok.extern.java.Log;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Log
@Component
public class SensorRunner {

    private List<Sensor> sensors;

    private final MqttProducer mqttProducer;

    private final String[] iotTypes;
    private final Long[] devices;
    private final String appName;

    @Autowired
    public SensorRunner(MqttProducer mqttProducer,
                        @Value("${app.name}") final String appName,
                        @Value("${pump.devices}") final Long[] devices,
                        @Value("${iot.types}") final String[] iotTypes) {
        this.appName = appName;
        this.devices = devices;
        this.iotTypes = iotTypes;
        this.mqttProducer = mqttProducer;
        this.sensors = new ArrayList<>();
        for(String iotType : this.iotTypes) {
            for(Long device : this.devices) {
                log.info(String.format("Starting Sensor: %s, Pump: %s, Client: %s", iotType, device, this.appName));
                this.sensors.add(SensorFactory.create(iotType, device));
            }
        }
        log.info(String.format("Connecting to Broker with clientId: %s", this.appName));
        mqttProducer.connect(this.appName);
    }

    @Scheduled(fixedRate = 5000)
    public void run() {
        ZonedDateTime utc = ZonedDateTime.now(ZoneOffset.UTC);
        for(Sensor sensor : this.sensors) {
            SensorData data = new SensorData()
                    .pumpId(sensor.getPump().getId())
                    .type(sensor.getSensorType())
                    .timestamp(utc.toInstant().toEpochMilli() / 1000);

            sensor.calculateCurrentMeasure(data);

            log.info(String.format("Current Measure [%s-%s]: %f", sensor.getPump().getName(), data.getType(), data.getValue()));
            String serializedData = sensor.getPump().getId() + "," + data.getTimestamp() + "," + data.getValue();
            try {
                mqttProducer.run(generateTopicName(sensor), serializedData);
            } catch (MqttException e) {
                log.severe(e.getMessage());
            }
        }
    }

    private String generateTopicName(Sensor sensor) {
        return sensor.getSensorType();
    }

}
