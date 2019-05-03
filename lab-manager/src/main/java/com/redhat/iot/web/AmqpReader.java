package com.redhat.iot.web;

import lombok.extern.java.Log;
import org.apache.activemq.command.ActiveMQBytesMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.support.converter.MessageConverter;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Component;

import javax.jms.BytesMessage;
import javax.jms.Message;
import javax.jms.TextMessage;
import java.util.*;
import java.util.stream.Collectors;

@Log
//@Component
public class AmqpReader {

    @SendTo("/topic/sensordata")
    @JmsListener(destination = "user1")
    public Object receiveMessage(int[] rawMessage) throws Exception {
        String message = Arrays.stream(rawMessage).mapToObj(i -> String.valueOf((char)i)).collect(Collectors.joining());
        log.info(String.format("AMQ Message (%s) consumed from topic \"user1\"", message));
        String[] payload = message.split(",");
        Map<String, String> sensorData = new HashMap<>();
        sensorData.put("pumpId", payload[0]);
        sensorData.put("type", payload[1]);
        sensorData.put("timestamp", payload[2]);
        sensorData.put("value", payload[3]);
        switch (payload[1]) {
            case "temperature":
                sensorData.put("units", "F");
                break;
            case "vibration":
                sensorData.put("units", "g");
                break;
            case "throughput":
                sensorData.put("units", "bd");
                break;
            case "frequency":
                sensorData.put("units", "Hz");
                break;
        }
        return sensorData;
    }



}
