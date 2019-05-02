package com.redhat.iot.web;

import lombok.extern.java.Log;
import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

@Log
//@Component
public class AmqStompBridge extends RouteBuilder {
    @Override
    public void configure() throws Exception {
        from("amqp:topic:user1")
                .process(exchange -> {
                    String[] payload = exchange.getIn().getBody(String.class).split(",");
                    log.info(String.format("AMQP message (%s) consumed", Arrays.toString(payload)));
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
                    exchange.getIn().setBody(sensorData);
                })
            .to("websocket://ws/sensordata?sendToAll=true");

        from("websocket://ws/sensordata")
                .to("log");
    }
}
