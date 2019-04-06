package com.redhat.iot.service;

import com.redhat.iot.model.PumpControl;
import com.redhat.iot.model.PumpState;
import lombok.extern.java.Log;

import java.util.Random;

@Log
public class HealthyPumpUpdateStrategy implements PumpUpdateStrategy {
    private Random rng;

    public HealthyPumpUpdateStrategy(Integer randSeed, Long timestamp) {
        rng = new Random(timestamp + randSeed);
    }

    @Override
    public void update(PumpState pumpState, final PumpControl pumpControl) {

        Integer intakePressure = computeHealthyStep(pumpState.getIntakePressure(),
                pumpState.getMinHealthyIntakePressure(), pumpState.getMaxHealthyIntakePressure());
        pumpState.setIntakePressure(intakePressure);

        Integer motorTemperature = computeHealthyStep(pumpState.getMotorTemperature(),
                pumpState.getMinHealthyMotorTemperature(), pumpState.getMaxHealthyMotorTemperature());
        pumpState.setMotorTemperature(motorTemperature);

        Integer vibration = computeHealthyStep(pumpState.getVibration(),
                pumpState.getMinHealthyVibration(), pumpState.getMaxHealthyVibration());
        pumpState.setMotorTemperature(motorTemperature);

        // if pump isn't already broken check to see if it breaks
        if (pumpState.getThroughput() != 0 && !isPumpInHealthyRange(pumpState)) {
            pumpState.setThroughput(0); // it's broken
        } else {
            pumpState.setThroughput(computeHealthyStep(pumpState.getThroughput(), 150, 300));
        }

        log.info(String.format("Timestamp:  %d | Pressure:  %2$3d psi | Motor Temp:  %3$3d F | Vibration: %4$2dg | Throughput: %5$3d b/d",
                pumpControl.getTimestamp(), intakePressure, motorTemperature, vibration, pumpState.getThroughput()));

    }

    private Integer computeHealthyStep(Integer current, Integer min, Integer max) {
        return (rng.nextInt(2 * (max + min)) + (3 * (max + min)))/8 ;
    }

    private boolean isPumpInHealthyRange(final PumpState pumpState) {
        return pumpState.getIntakePressure() <= pumpState.getMaxHealthyIntakePressure() &&
                pumpState.getIntakePressure() >= pumpState.getMinHealthyIntakePressure() &&
                pumpState.getMotorTemperature() <= pumpState.getMaxHealthyMotorTemperature() &&
                pumpState.getMotorTemperature() >= pumpState.getMinHealthyMotorTemperature() &&
                pumpState.getVibration() <= pumpState.getMaxHealthyVibration() &&
                pumpState.getVibration() >= pumpState.getMinHealthyVibration();
    }
}
