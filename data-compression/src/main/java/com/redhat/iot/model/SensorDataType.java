package com.redhat.iot.model;

import java.util.Arrays;

public enum SensorDataType {
    INTAKE_PRESSURE("intake-pressure"),
    MOTOR_TEMP("motor-temperature"),
    THROUGHPUT("throughput"),
    VIBRATION("vibration");

    private String value;
    private SensorDataType(String value) {
        this.value = value;
    }
    public String value() {
        return this.value;
    }
}
