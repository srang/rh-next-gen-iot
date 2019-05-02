package com.redhat.iot.web;

import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

@Component
@Log
public class SensorDataEventHandler {
    private final SimpMessagingTemplate websocket;

    @Autowired
    public SensorDataEventHandler(SimpMessagingTemplate websocket) {
        this.websocket = websocket;
    }

    @JmsListener(destination = "user1")
    public void receiveTopic(String payload) {
        log.info(String.format("JMS message (%s) consumed", payload));
        this.websocket.convertAndSend("/topic/sensordata", payload);
    }
}
