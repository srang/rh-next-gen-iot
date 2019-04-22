package com.redhat.iot.util;

import java.time.ZoneOffset;
import java.time.ZonedDateTime;

import com.redhat.iot.api.SensorData;
import com.redhat.iot.model.Sensor;
import com.redhat.iot.model.SensorFactory;
import lombok.extern.java.Log;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Log
@Component
public class SensorRunner {

    private final Sensor sensor;

    private final MqttProducer mqttProducer;

    private String topicName;
    @Value("${app.name}")
    private String appName;

    private static final String SLASH = "/";

    @Autowired
    public SensorRunner(MqttProducer mqttProducer) {
        log.info(String.format("Starting Sensor: %s, Pump: %s", "temperature", 1l));
        this.sensor = SensorFactory.create("temperature", 1l);
        this.mqttProducer = mqttProducer;

        generateTopicName();
    }

    @Scheduled(fixedRate = 5000)
    public void run() {
        ZonedDateTime utc = ZonedDateTime.now(ZoneOffset.UTC);
        SensorData data = new SensorData()
                .pumpId(this.sensor.getPump().getId())
                .type(this.sensor.getSensorType())
                .timestamp(utc.toInstant().toEpochMilli() / 1000);

        sensor.calculateCurrentMeasure(data);

        log.info(String.format("Current Measure [%s-%s]: %f", sensor.getPump().getName(), data.getType(), data.getValue()));
        String serializedData = sensor.getPump().getId() + "," + data.getTimestamp() + "," + data.getValue();
        try {
            mqttProducer.run(topicName, serializedData, sensor.getPump().getId());
        } catch (MqttException e) {
            log.severe(e.getMessage());
        }

    }

    private void generateTopicName() {
        topicName = sensor.getSensorType();
    }

}
