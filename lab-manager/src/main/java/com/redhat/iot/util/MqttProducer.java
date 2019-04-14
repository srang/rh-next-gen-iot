package com.redhat.iot.util;

import javax.annotation.PreDestroy;

import com.redhat.iot.api.Pump;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.MqttPersistenceException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MqttProducer {

    private Map<Long, MqttClient> clients = new ConcurrentHashMap<>();
    private MqttConnectOptions options;
    private MemoryPersistence persistence;

    private final String brokerURL;
    private final String user;
    private final String password;

    private static final int QOS = 2;

    private static final Logger log = LoggerFactory.getLogger(MqttProducer.class);


    public MqttProducer(String brokerURL, String user, String password) {

        this.brokerURL = brokerURL;
        this.user = user;
        this.password = password;

    }

    public synchronized void connect(Pump pump) {
        MqttClient client = (clients.containsKey(pump.getId())) ? clients.get(pump.getId()) : null;
        if (client != null && client.isConnected()) {
            return;
        }

        try {
            client = new MqttClient(brokerURL, pump.getName());
            options = new MqttConnectOptions();
            options.setUserName(user);
            options.setPassword(password.toCharArray());
            client.connect(options);
            clients.put(pump.getId(), client);
        } catch (MqttException e) {
            log.error(e.getMessage(), e);
        }

    }

    public void run(String topic, String data, Long pumpId) throws MqttPersistenceException, MqttException {

        MqttClient client = clients.get(pumpId);
        MqttMessage message = new MqttMessage();
        message.setQos(QOS);

        message.setPayload(data.getBytes());
        client.publish(topic, message);

    }

    @PreDestroy
    public void close() throws MqttException {
        for (MqttClient client : clients.values()) {
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
}