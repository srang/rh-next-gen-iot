package com.redhat.iot.routes;

import lombok.extern.java.Log;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.Processor;
import org.apache.camel.model.dataformat.JsonLibrary;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.apache.camel.Exchange;
import org.springframework.stereotype.Component;

@Log
@Component
public class AmqpKafkaBridge extends RouteBuilder {
    @Override
    public void configure() throws Exception {
        from("{{route.from}}")
            .process(exchange -> {
                String[] payload = exchange.getIn().getBody(String.class).split(",");
                log.info(String.format("AMQ Message (%s) consumed from topic \"user1\"", Arrays.toString(payload)));
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
            .marshal().json(JsonLibrary.Gson, HashMap.class)
            .to("{{route.to}}");
    }
}
