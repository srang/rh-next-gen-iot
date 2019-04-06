package com.redhat.iot.model;

import com.redhat.iot.api.SensorData;
import lombok.Data;
import org.kie.api.definition.type.Role;
import org.kie.api.definition.type.Timestamp;

import java.io.Serializable;
import java.util.Date;

@Data
@Role(Role.Type.EVENT)
@Timestamp("eventTimestamp")
public class UnhealthyPumpEvent implements Serializable {
    private SensorData sensorData;
    Date eventTimestamp;

    @java.beans.ConstructorProperties({"sensorData"})
    public UnhealthyPumpEvent(SensorData sensorData) {
        this.sensorData = sensorData;
        this.eventTimestamp = new Date(sensorData.getTimestamp());
    }
}
