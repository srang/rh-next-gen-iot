package com.redhat.iot.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.support.converter.MessageConverter;
import org.springframework.stereotype.Component;

import javax.jms.BytesMessage;
import javax.jms.Message;
import javax.jms.TextMessage;
import java.util.Arrays;

@Component
public class AmqpReader {

    @JmsListener(destination = "user1")
    public void receiveMessage(Message message) throws Exception {
        System.out.println("Received <" + message + ">");

//        String[] payload = exchange.getIn().getBody(String.class).split(",");
//        log.info(String.format("AMQP message (%s) consumed", Arrays.toString(payload)));
//        Map<String, String> sensorData = new HashMap<>();
//        sensorData.put("pumpId", payload[0]);
//        sensorData.put("type", payload[1]);
//        sensorData.put("timestamp", payload[2]);
//        sensorData.put("value", payload[3]);
//        switch (payload[1]) {
//            case "temperature":
//                sensorData.put("units", "F");
//                break;
//            case "vibration":
//                sensorData.put("units", "g");
//                break;
//            case "throughput":
//                sensorData.put("units", "bd");
//                break;
//            case "frequency":
//                sensorData.put("units", "Hz");
//                break;
//        }

    }

}
