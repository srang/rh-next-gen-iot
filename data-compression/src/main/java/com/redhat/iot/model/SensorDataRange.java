package com.redhat.iot.model;

import com.redhat.iot.api.SensorData;
import lombok.Data;

@Data
public class SensorDataRange {
    private String type;
    private String units;
    private Float minValue;
    private Float maxValue;
    private Long minTimestamp;
    private Long maxTimestamp;
    private Float average;

}
