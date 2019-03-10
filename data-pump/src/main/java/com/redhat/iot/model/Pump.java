package com.redhat.iot.model;

import com.redhat.iot.service.PumpUpdateStrategy;
import lombok.Builder;
import lombok.Data;

@Data
public class Pump {
    private PumpUpdateStrategy updateStrategy;
    private PumpState pumpState;
    private PumpControl pumpControl;
    private boolean isPumpAlreadyBroken = false;

    @Builder
    @java.beans.ConstructorProperties({"updateStrategy", "pumpState", "pumpControl"})
    public Pump(PumpUpdateStrategy updateStrategy, PumpState pumpState, PumpControl pumpControl) {
        this.updateStrategy = updateStrategy;
        this.pumpState = pumpState;
        this.pumpControl = pumpControl;
    }

    public void update() {
        updateStrategy.update(pumpState, pumpControl);
    }
}
