package com.redhat.iot.model;

import com.redhat.iot.api.Pump;
import com.redhat.iot.api.SensorData;
import lombok.Data;
import lombok.extern.java.Log;
import org.kie.api.definition.type.Role;
import org.kie.api.definition.type.Timestamp;

import java.util.Date;
import java.util.List;

import static com.redhat.iot.model.SensorDataType.*;

@Data
@Log
@Role(Role.Type.EVENT)
@Timestamp("startTimestamp")
public class AggregatePumpData {
    private SensorDataRange intakePressure;
    private SensorDataRange motorTemperature;
    private SensorDataRange vibration;
    private SensorDataRange throughput;
    private Date startTimestamp;
    private Pump pump;
    // for easy removal from working memory
    private List<SensorData> readings;

    public AggregatePumpData(Pump pump, Date startTimestamp) {
        this.pump = pump;
        this.intakePressure = new SensorDataRange();
        this.motorTemperature = new SensorDataRange();
        this.vibration = new SensorDataRange();
        this.throughput = new SensorDataRange();
        this.startTimestamp = startTimestamp;
    }

    /*
    public void setSensorData(SensorData sensorData) {
        switch (SensorDataType.valueOf(sensorData.getType())) {
            case INTAKE_PRESSURE:
                this.intakePressure.setDataPoint(sensorData);
                break;
            case VIBRATION:
                this.vibration.setDataPoint(sensorData);
                break;
            case MOTOR_TEMP:
                this.motorTemperature.setDataPoint(sensorData);
                break;
            case THROUGHPUT:
                this.throughput.setDataPoint(sensorData);
                break;
            default:
                log.info("ERROR: unknown datatype");
                throw new RuntimeException("Unknown datatype sent to AggregatePumpData");
        }
    }
    */
}
