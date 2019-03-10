package com.redhat.iot.service;

import com.redhat.iot.model.PumpControl;
import com.redhat.iot.model.PumpState;

public interface PumpUpdateStrategy {
    void update(PumpState pumpState, final PumpControl pumpControl);
}
