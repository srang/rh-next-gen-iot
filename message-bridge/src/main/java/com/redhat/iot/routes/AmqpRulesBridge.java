package com.redhat.iot.routes;

import com.redhat.iot.api.SensorData;
import lombok.extern.java.Log;
import org.apache.camel.builder.RouteBuilder;
import org.kie.dmn.api.core.DMNContext;
import org.kie.dmn.api.core.DMNDecisionResult;
import org.kie.dmn.api.core.DMNResult;
import org.kie.server.api.marshalling.MarshallingFormat;
import org.kie.server.api.model.ServiceResponse;
import org.kie.server.client.DMNServicesClient;
import org.kie.server.client.RuleServicesClient;
import org.kie.server.client.KieServicesConfiguration;
import org.kie.server.client.KieServicesFactory;
import org.kie.api.command.BatchExecutionCommand;
import org.kie.api.command.Command;
import org.kie.api.command.KieCommands;
import org.kie.api.runtime.ExecutionResults;
import org.kie.api.KieServices;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.*;

@Log
@Component
public class AmqpRulesBridge extends RouteBuilder {
    @Value("${kie.container}")
    private String kieContainer;
    @Value("${kie.server}")
    private String kieServer;
    @Value("${kie.username}")
    private String kieUser;
    @Value("${kie.password}")
    private String kiePass;

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
                    KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(kieServer, kieUser, kiePass);
                    conf.setMarshallingFormat(MarshallingFormat.XSTREAM);

                    DMNServicesClient dmnServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(DMNServicesClient.class);
                    DMNContext context = dmnServicesClient.newContext();
                    context.set(sensorData.get("type"), sensorData.get("value"));
                    ServiceResponse<DMNResult> serverResp = dmnServicesClient.evaluateAll(kieContainer, "", "", context);
                    DMNResult dmnResult = serverResp.getResult();
                    for (DMNDecisionResult dr : dmnResult.getDecisionResults()) {
                        log.info(String.format("%s: %s, Decision: '%s', Result: %s", sensorData.get("type"), sensorData.get("value"), dr.getDecisionName(), dr.getResult()));
                    }

//                    RuleServicesClient ruleServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(RuleServicesClient.class);
//
//                    KieCommands commandsFactory = KieServices.Factory.get().getCommands();
//                    List<Command<?>> commands = new ArrayList<>();
//                    commands.add((Command<?>) commandsFactory.newInsert(sensorData));
//                    commands.add((Command<?>) commandsFactory.newFireAllRules());
//                    BatchExecutionCommand batch = commandsFactory.newBatchExecution(commands);
//                    log.info(String.format("Rules command set (%s) staged", batch.toString()));
//                    ServiceResponse<ExecutionResults> executeResponse = ruleServicesClient.executeCommandsWithResults(kieContainer, batch);
//                    log.info(String.format("Execution response (%s) received", executeResponse.toString()));
                });
    }
}
