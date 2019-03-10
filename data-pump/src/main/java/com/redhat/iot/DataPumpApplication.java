package com.redhat.iot;

import com.redhat.iot.model.Pump;
import com.redhat.iot.model.PumpControl;
import com.redhat.iot.model.PumpState;
import com.redhat.iot.service.HealthyPumpUpdateStrategy;
import com.redhat.iot.service.PumpUpdateStrategy;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DataPumpApplication implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(DataPumpApplication.class, args);
    }


    @Override
    public void run(String... args) throws Exception {
        Long timestamp = 1552250160l;
        PumpControl control = PumpControl.builder().pumpRandSeed(1).powerFrequency(50).wellheadPressure(500).timestamp(timestamp).build();
        PumpState state = PumpState.builder()
                .intakePressure(250).minHealthyIntakePressure(0).maxHealthyIntakePressure(500)
                .motorTemperature(250).minHealthyMotorTemperature(0).maxHealthyMotorTemperature(550)
                .vibration(8).minHealthyVibration(1).maxHealthyVibration(16)
                .throughput(150)
                .build();
        PumpUpdateStrategy healthy = new HealthyPumpUpdateStrategy(control.getPumpRandSeed(), control.getTimestamp());
        Pump pump1 = Pump.builder().updateStrategy(healthy).pumpControl(control).pumpState(state).build();
        while (true) {
            Thread.sleep(1000);
            timestamp += 5;
            control.setTimestamp(timestamp);
            pump1.update();
        }
    }
}
