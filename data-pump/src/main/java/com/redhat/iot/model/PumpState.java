package com.redhat.iot.model;

import lombok.Builder;
import lombok.Data;

@Data
public class PumpState {
    private Integer intakePressure;
    private Integer minHealthyIntakePressure;
    private Integer maxHealthyIntakePressure;
    private Integer motorTemperature;
    private Integer minHealthyMotorTemperature;
    private Integer maxHealthyMotorTemperature;
    private Integer vibration;
    private Integer minHealthyVibration;
    private Integer maxHealthyVibration;
    private Integer throughput;

    @Builder
    @java.beans.ConstructorProperties({"intakePressure", "minHealthyIntakePressure", "maxHealthyIntakePressure", "motorTemperature", "minHealthyMotorTemperature", "maxHealthyMotorTemperature", "vibration", "minHealthyVibration", "maxHealthyVibration", "throughput"})
    public PumpState(Integer intakePressure, Integer minHealthyIntakePressure, Integer maxHealthyIntakePressure, Integer motorTemperature, Integer minHealthyMotorTemperature, Integer maxHealthyMotorTemperature, Integer vibration, Integer minHealthyVibration, Integer maxHealthyVibration, Integer throughput) {
        this.minHealthyIntakePressure = minHealthyIntakePressure;
        this.maxHealthyIntakePressure = maxHealthyIntakePressure;
        this.intakePressure = intakePressure;
        this.minHealthyMotorTemperature = minHealthyMotorTemperature;
        this.maxHealthyMotorTemperature = maxHealthyMotorTemperature;
        this.motorTemperature = motorTemperature;
        this.minHealthyVibration = minHealthyVibration;
        this.maxHealthyVibration = maxHealthyVibration;
        this.vibration = vibration;
        this.throughput = throughput;
    }
}
