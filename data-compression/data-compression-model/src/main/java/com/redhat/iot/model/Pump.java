package com.redhat.iot.model;

import lombok.Data;

@Data
public class Pump {
    private Long id;
    private String name;
    private Float latitude;
    private Float longitude;
}
