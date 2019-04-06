package com.redhat.iot.model;

public enum PumpStatusType {
    GREEN("green"),
    YELLOW("yellow"),
    RED("red");

    private String value;
    private PumpStatusType(String value) {
        this.value = value;
    }
    public String value() {
        return this.value;
    }
}
