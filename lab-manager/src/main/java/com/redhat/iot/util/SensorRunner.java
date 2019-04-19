package com.redhat.iot.util;

import java.time.ZoneOffset;
import java.time.ZonedDateTime;

import com.redhat.iot.api.SensorData;
import com.redhat.iot.model.Sensor;
import lombok.extern.java.Log;
import org.eclipse.paho.client.mqttv3.MqttException;

@Log
public class SensorRunner implements Runnable {

    private final Sensor sensor;

    private final MqttProducer mqttProducer;

    private String topicName;
    private String appName;

    private static final String SLASH = "/";

    public SensorRunner(Sensor sensor, Config config, MqttProducer mqttProducer) {
        this.sensor = sensor;
        this.mqttProducer = mqttProducer;
        this.appName = config.getAppName();

        generateTopicName();
    }

    @Override
    public void run() {
        ZonedDateTime utc = ZonedDateTime.now(ZoneOffset.UTC);
        SensorData data = new SensorData()
                .pumpId(this.sensor.getPump().getId())
                .type(this.sensor.getSensorType())
                .timestamp(utc.toInstant().toEpochMilli() / 1000);

        sensor.calculateCurrentMeasure(data);

        log.fine(String.format("Current Measure [%s-%s]: %d", sensor.getPump().getName(), data.getType(), data.getValue()));
        String serializedData = sensor.getPump().getId() + "," + data.getTimestamp() + "," + data.getValue();
        try {
            mqttProducer.run(topicName, serializedData, sensor.getPump().getId());
        } catch (MqttException e) {
            log.severe(e.getMessage());
        }

    }

    private void generateTopicName() {
        StringBuilder sb = new StringBuilder();
        sb.append(sensor.getSensorType());

        topicName = sb.toString();
    }

}
