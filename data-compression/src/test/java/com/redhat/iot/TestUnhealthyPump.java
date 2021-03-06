package com.redhat.iot;

import com.redhat.iot.api.SensorData;
import com.redhat.iot.model.SensorDataType;
import com.redhat.iot.model.UnhealthyPumpEvent;
import org.junit.Test;
import org.kie.api.KieBase;
import org.kie.api.KieServices;
import org.kie.api.builder.Message;
import org.kie.api.builder.Results;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;

import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertThat;

public class TestUnhealthyPump {
    private static final long starterTimestamp = 1554047427555l;
    private KieSession getFilterSession() {
        KieServices kieServices = KieServices.Factory.get();
        KieContainer kieContainer = kieServices.getKieClasspathContainer();
        return kieContainer.getKieBase("filterKB").newKieSession();
    }

    @Test
    public void testContainerCreation() {
        KieServices kieServices = KieServices.Factory.get();
        KieContainer kieContainer = kieServices.getKieClasspathContainer();
        Results results = kieContainer.verify();
        kieContainer.getKieBaseNames().forEach(kieBase -> {
            System.out.println(">> Loading KieBase: "+ kieBase );
            kieContainer.getKieSessionNamesInKieBase(kieBase).stream().forEach((kieSession) -> {
                System.out.println("  >> Containing KieSession: "+ kieSession );
            });
        });
        if (results.hasMessages(Message.Level.ERROR)){
            List<Message> messages = results.getMessages(Message.Level.ERROR);
            for (Message message : messages) {
                System.out.printf("[%s] - %s[%s,%s]: %s", message.getLevel(), message.getPath(), message.getLine(), message.getColumn(), message.getText());
            }
            throw new IllegalStateException("errors starting container");
        }
        assertThat(kieContainer, notNullValue());
        KieBase kieBase = kieContainer.getKieBase("filterKB");
        assertThat(kieBase, notNullValue());
        KieSession kieSession = getFilterSession();
        assertThat(kieSession, notNullValue());
        kieSession.destroy();
    }

    @Test
    public void testHealthyMotorTempPumpData() {
        KieSession kieSession = getFilterSession();
        SensorData data = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(200f);

        kieSession.insert(data);
        int firedRules = kieSession.fireAllRules();
        assertThat(firedRules, equalTo(0));
        kieSession.destroy();
    }

    @Test
    public void testUnhealthyMotorTempPumpData() {
        KieSession kieSession = getFilterSession();
        SensorData data = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(600f);

        kieSession.insert(data);
        int firedRules = kieSession.fireAllRules();
        assertThat(firedRules, equalTo(1));
        kieSession.destroy();
    }

    @Test
    public void testMultipleUnhealthyEvents() {
        KieSession kieSession = getFilterSession();
        SensorData data1 = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(601f);
        UnhealthyPumpEvent event1 = new UnhealthyPumpEvent(data1);
        SensorData data2 = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 1001l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(603f);
        UnhealthyPumpEvent event2 = new UnhealthyPumpEvent(data2);
        SensorData data3 = new SensorData()
                .id(3l)
                .pumpId(2l)
                .timestamp(starterTimestamp + 2000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(600f);
        UnhealthyPumpEvent event3 = new UnhealthyPumpEvent(data3);
        SensorData data4 = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 12000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(599f);
        UnhealthyPumpEvent event4 = new UnhealthyPumpEvent(data4);

        kieSession.insert(event1);
        kieSession.insert(event2);
        kieSession.insert(event3);
        kieSession.insert(event4);
        int firedRules = kieSession.fireAllRules();
        assertThat(firedRules, equalTo(2));
        kieSession.destroy();
    }

    @Test
    public void testMultipleUnhealthyEventsOverLongWindow() {
        KieSession kieSession = getFilterSession();
        SensorData data1 = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(600f);
        UnhealthyPumpEvent event1 = new UnhealthyPumpEvent(data1);
        SensorData data2 = new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 20000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(600f);
        UnhealthyPumpEvent event2 = new UnhealthyPumpEvent(data2);

        kieSession.insert(event1);
        kieSession.insert(event2);
        int firedRules = kieSession.fireAllRules();
        assertThat(firedRules, equalTo(0));
        kieSession.destroy();
    }
}