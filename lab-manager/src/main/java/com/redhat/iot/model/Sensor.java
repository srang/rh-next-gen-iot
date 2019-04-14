package com.redhat.iot.model;

import com.redhat.iot.api.Pump;
import com.redhat.iot.api.SensorData;
import lombok.Builder;
import lombok.Data;

@Data
public class Sensor {
    private Pump pump;
    private String sensorType;

    @java.beans.ConstructorProperties({"pump", "sensorType"})
    public Sensor(Pump pump, String sensorType) {
        this.pump = pump;
        this.sensorType = sensorType;
    }

    // function for reading from correct dataset to provide next value for each sensor type
    public void calculateCurrentMeasure(SensorData data) {
        // read from dataset set stuff
    }
}
