package com.redhat.iot.web;

import com.google.gson.Gson;
import com.redhat.iot.util.SensorRunner;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Log
@Controller
public class WebSocketController {

    private final String[] iotTypes;
    private final Long[] devices;
    private SensorRunner sensorRunner;

    @Autowired
    public WebSocketController(
            @Value("${pump.devices}") final Long[] devices,
            @Value("${iot.types}") final String[] iotTypes,
            SensorRunner sensorRunner
    ) {
        this.devices = devices;
        this.iotTypes = iotTypes;
        this.sensorRunner = sensorRunner;
    }

    @MessageMapping("/pumplist")
    @SendTo("/topic/pumps")
    public String pumpList() {
        log.info(String.format("WebSocket request for unique devices received"));
        return Arrays.toString(devices);
    }

    @MessageMapping("/devicelist")
    @SendTo("/topic/devices")
    public String setDevices(String devices) {
        System.out.println(devices);
        Long[] deviceList = Arrays.stream(devices.split(",")).map(Long::parseLong).collect(Collectors.toList()).toArray(new Long[]{});
        this.sensorRunner.reloadDevices(deviceList);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Message Received");
        return new Gson().toJson(response);
    }

}

