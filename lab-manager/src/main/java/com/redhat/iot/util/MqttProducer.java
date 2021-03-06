package com.redhat.iot.util;

import lombok.extern.java.Log;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PreDestroy;

@Log
@Component
public class MqttProducer {

    private MqttClient client;
    private final String brokerURL;
    private final String username;
    private final String password;

    private static final int QOS = 2;

    public MqttProducer(@Value("${mqtt.service}") final String mqttServiceName,
                        @Value("${mqtt.port}") final String mqttServicePort,
                        @Value("${mqtt.username}") final String username,
                        @Value("${mqtt.password}") final String password) {
        this.brokerURL = String.format("tcp://%s:%s", mqttServiceName, mqttServicePort);
        this.username = username;
        this.password = password;
        log.info(String.format("Broker created with url: %s, username: %s", this.brokerURL, this.username));
    }

    public void connect(String appName) {
        if (client != null && client.isConnected()) {
            return;
        }

        try {
            this.client = new MqttClient(this.brokerURL, appName);
            MqttConnectOptions options = new MqttConnectOptions();
            options.setUserName(this.username);
            options.setPassword(this.password.toCharArray());
            options.setCleanSession(true);
            options.setConnectionTimeout(5000);
            options.setAutomaticReconnect(true);
            client.connect(options);
        } catch (MqttException e) {
            log.severe(e.getMessage());
        }

    }

    public void run(String address, String data) throws MqttException {
        log.info(String.format("Publishing message (%s) to address: %s", data, address));
        MqttMessage message = new MqttMessage();
        message.setQos(QOS);
        message.setPayload(data.getBytes());
        client.publish(address, message);
    }

    @PreDestroy
    public void close() throws MqttException {
        try {
            client.disconnect();
        } catch (Exception e) {
        }
        try {
            client.close();
        } catch (Exception e) {
        }
    }
}