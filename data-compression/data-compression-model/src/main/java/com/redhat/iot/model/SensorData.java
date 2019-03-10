package com.redhat.iot.model;

import lombok.Data;

@Data
public class SensorData {
    private Long id;
    private Long pumpId;
    private Long timestamp;
    private String type;
    private Long value;
    private String units;
}
