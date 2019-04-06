package com.redhat.iot.model;

import lombok.Builder;
import lombok.Data;

@Data
public class PumpControl {
    private final Integer pumpRandSeed;
    private Integer powerFrequency;
    private Integer wellheadPressure;
    private Long timestamp;

    @Builder
    @java.beans.ConstructorProperties({"pumpRandSeed", "powerFrequency", "wellheadPressure", "timestamp"})
    public PumpControl(Integer pumpRandSeed, Integer powerFrequency, Integer wellheadPressure, Long timestamp) {
        this.pumpRandSeed = pumpRandSeed;
        this.powerFrequency = powerFrequency;
        this.wellheadPressure = wellheadPressure;
        this.timestamp = timestamp;
    }
}
