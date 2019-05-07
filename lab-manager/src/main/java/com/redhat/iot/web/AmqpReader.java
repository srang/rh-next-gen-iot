package com.redhat.iot.web;

import com.google.gson.Gson;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Log
@Component
public class AmqpReader {

    @Autowired
    SimpMessagingTemplate messagingTemplate;

    @JmsListener(destination = "user1")
    public void receiveMessage(int[] rawMessage) throws Exception {
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
        messagingTemplate.convertAndSend("/topic/sensordata", new Gson().toJson(sensorData));
    }

}
