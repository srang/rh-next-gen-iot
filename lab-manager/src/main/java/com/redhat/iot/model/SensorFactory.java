package com.redhat.iot.model;

import com.redhat.iot.api.Pump;

public class SensorFactory {
    public static Sensor create(String sensorType, Long pumpId) {
        Pump pump = new Pump().id(pumpId).latitude(0f).longitude(0f).name("ESP_" + pumpId);
        return new Sensor(pump, sensorType);
    }
}
