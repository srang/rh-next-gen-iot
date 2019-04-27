package com.redhat.iot.routes;

import com.redhat.iot.api.SensorData;
import lombok.extern.java.Log;
import org.apache.camel.builder.RouteBuilder;
import org.kie.server.api.marshalling.MarshallingFormat;
import org.kie.server.api.model.ServiceResponse;
import org.kie.server.client.RuleServicesClient;
import org.kie.server.client.KieServicesConfiguration;
import org.kie.server.client.KieServicesFactory;
import org.kie.api.command.BatchExecutionCommand;
import org.kie.api.command.Command;
import org.kie.api.command.KieCommands;
import org.kie.api.runtime.ExecutionResults;
import org.kie.api.KieServices;
import org.springframework.stereotype.Component;

import java.util.*;

@Log
@Component
public class AmqpRulesBridge extends RouteBuilder {
    private static final String KIE_SERVER = "http://data-compression-ks:8080/services/rest/server";
    private static final String KIE_USER = "jboss";
    private static final String KIE_PASS = "jboss";
    private static final String KIE_CONTAINER = "datacompression";

    @Override
    public void configure() throws Exception {
        from("{{route.from}}")
                .process(exchange -> {
                    String[] payload = exchange.getIn().getBody(String.class).split(",");
                    log.info(String.format("MQTT message (%s) consumed", Arrays.toString(payload)));
                    Map<String, String> sensorData = new HashMap<>();
                    sensorData.put("pumpId", payload[0]);
                    sensorData.put("type", payload[1]);
                    sensorData.put("timestamp", payload[2]);
                    sensorData.put("value", payload[3]);
                    switch (payload[1]) {
                        case "temperature":
                            sensorData.put("units", "F");
                            break;
                        case "vibration":
                            sensorData.put("units", "g");
                            break;
                        case "throughput":
                            sensorData.put("units", "bd");
                            break;
                        case "frequency":
                            sensorData.put("units", "Hz");
                            break;
                    }
                    // do something with the payload and/or exchange here
                    KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(KIE_SERVER, KIE_USER, KIE_PASS);
                    conf.setMarshallingFormat(MarshallingFormat.XSTREAM);

                    RuleServicesClient ruleServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(RuleServicesClient.class);

                    KieCommands commandsFactory = KieServices.Factory.get().getCommands();
                    List<Command<?>> commands = new ArrayList<>();
                    commands.add((Command<?>) commandsFactory.newInsert(sensorData));
                    commands.add((Command<?>) commandsFactory.newFireAllRules());
                    BatchExecutionCommand batch = commandsFactory.newBatchExecution(commands);
                    log.info(String.format("Rules command set (%s) staged", batch.toString()));
                    ServiceResponse<ExecutionResults> executeResponse = ruleServicesClient.executeCommandsWithResults(KIE_CONTAINER, batch);
                    log.info(String.format("Execution response (%s) received", executeResponse.toString()));
                });
    }
}
