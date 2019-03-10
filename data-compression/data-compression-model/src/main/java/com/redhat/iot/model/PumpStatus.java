package com.redhat.iot.model;

import lombok.Data;

@Data
public class PumpStatus {
    private Long id;
    private Long pumpId;
    private Long timestamp;
    private String status;
}
