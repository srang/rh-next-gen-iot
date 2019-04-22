package com.redhat.iot.util;

import javax.annotation.PreDestroy;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.MqttPersistenceException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class MqttProducer {

    private Map<Long, MqttClient> clients = new ConcurrentHashMap<>();
    private MqttClient client;
    private MqttConnectOptions options;
    private MemoryPersistence persistence;

    @Value("${mqtt.username}")
    private String mqttUsername;

    @Value("${mqtt.password}")
    private String mqttPassword;

    @Value("${mqtt.port}")
    private String mqttServicePort;

    @Value("${mqtt.service}")
    private String mqttServiceName;

    @Value("${app.name}")
    private String appName;

    private final String brokerURL;
    private final String user;
    private final String password;

    private static final int QOS = 0;

    private static final Logger log = LoggerFactory.getLogger(MqttProducer.class);


    public MqttProducer() {
        brokerURL = String.format("tcp://%s:%s", mqttServiceName, mqttServicePort);
        user = mqttUsername;
        password = mqttPassword;
    }

    public synchronized void connect(String appName) {
        if (client != null && client.isConnected()) {
            return;
        }

        try {
            client = new MqttClient(brokerURL, appName);
            options = new MqttConnectOptions();
            options.setUserName(user);
            options.setPassword(password.toCharArray());
            client.connect(options);
        } catch (MqttException e) {
            log.error(e.getMessage(), e);
        }

    }

    public void run(String topic, String data, Long pumpId) throws MqttPersistenceException, MqttException {
        MqttMessage message = new MqttMessage();
        message.setQos(QOS);

        message.setPayload(data.getBytes());
        client.publish(topic, message);
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