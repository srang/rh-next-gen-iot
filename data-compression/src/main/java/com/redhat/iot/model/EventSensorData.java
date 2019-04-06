package com.redhat.iot.model;

import com.redhat.iot.api.SensorData;
import lombok.Data;
import org.kie.api.definition.type.Role;
import org.kie.api.definition.type.Timestamp;

import java.util.Date;

@Data
@Role(Role.Type.EVENT)
@Timestamp("eventTimestamp")
public class EventSensorData {
    private SensorData sensorData;
    private Date eventTimestamp;
    public EventSensorData(SensorData sensorData) {
        this.sensorData = sensorData;
        this.eventTimestamp = new Date(sensorData.getTimestamp());
    }
}
