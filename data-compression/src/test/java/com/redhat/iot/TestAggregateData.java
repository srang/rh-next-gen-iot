package com.redhat.iot;

import com.redhat.iot.api.Pump;
import com.redhat.iot.api.SensorData;
import com.redhat.iot.model.SensorDataType;
import com.redhat.iot.model.UnhealthyPumpEvent;
import lombok.extern.java.Log;
import org.junit.Test;
import org.kie.api.KieBase;
import org.kie.api.KieServices;
import org.kie.api.builder.Message;
import org.kie.api.builder.Results;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertThat;


public class TestAggregateData {
    private static final long starterTimestamp = 1554047427555l;
    private KieSession getAggregateSession() {
        KieServices kieServices = KieServices.Factory.get();
        KieContainer kieContainer = kieServices.getKieClasspathContainer();
        return kieContainer.getKieBase("aggregateKB").newKieSession();
    }

    @Test
    public void testContainerCreation() {
        KieServices kieServices = KieServices.Factory.get();
        KieContainer kieContainer = kieServices.getKieClasspathContainer();
        Results results = kieContainer.verify();
        kieContainer.getKieBaseNames().forEach(kieBase -> {
            System.out.println(">> Loading KieBase: " + kieBase);
            kieContainer.getKieSessionNamesInKieBase(kieBase).stream().forEach((kieSession) -> {
                System.out.println("  >> Containing KieSession: " + kieSession);
            });
        });
        if (results.hasMessages(Message.Level.ERROR)) {
            List<Message> messages = results.getMessages(Message.Level.ERROR);
            for (Message message : messages) {
                System.out.printf("[%s] - %s[%s,%s]: %s", message.getLevel(), message.getPath(), message.getLine(), message.getColumn(), message.getText());
            }
            throw new IllegalStateException("errors starting container");
        }
        assertThat(kieContainer, notNullValue());
        KieBase kieBase = kieContainer.getKieBase("aggregateKB");
        assertThat(kieBase, notNullValue());
        KieSession kieSession = getAggregateSession();
        assertThat(kieSession, notNullValue());
        kieSession.destroy();
    }

    @Test
    public void testCreateAggregateSensorData() {
        KieSession kieSession = getAggregateSession();

        Pump pump1 = new Pump().id(1l);
        Pump pump2 = new Pump().id(2l);
        List<SensorData> dataList = new ArrayList<>();
        dataList.add(new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(600l));
        dataList.add(new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 1000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(600l));
        dataList.add(new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 2000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(602l));
        dataList.add(new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 5000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(559l));
        dataList.add(new SensorData()
                .pumpId(1l)
                .timestamp(starterTimestamp + 12000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(500l));
        dataList.add(new SensorData()
                .pumpId(2l)
                .timestamp(starterTimestamp + 20000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(502l));
        dataList.add(new SensorData()
                .pumpId(2l)
                .timestamp(starterTimestamp + 21000l)
                .type(SensorDataType.MOTOR_TEMP.value())
                .value(502l));
        dataList.forEach(kieSession::insert);
        kieSession.insert(pump1);
        kieSession.insert(pump2);
        int firedRules = kieSession.fireAllRules();
        assertThat(firedRules, equalTo(11));
        // todo query session for aggregates, test average, min etc
        kieSession.destroy();
    }
}
