import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.Processor;
import org.apache.camel.model.dataformat.JsonLibrary;
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

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

import org.apache.camel.Exchange;
//kamel run Sample.java -d mvn:com.google.code.gson:gson:2.8.5 -d camel-gson

public class StreamsReader extends RouteBuilder {
    private static final String KIE_SERVER = "http://rules-manager-kieserver:8080/services/rest/server";
    private static final String KIE_USER = "jboss";
    private static final String KIE_PASS = "jboss";
    private static final String KIE_CONTAINER = "esp_rules";

    @Override
    public void configure() throws Exception {
        //from("kafka:my-topic?brokers=my-cluster-kafka-bootstrap:9091")
        from("{{route.from}}")
                .process(exchange -> {
                    String payload = exchange.getIn().getBody(String.class)
                    log.info(String.format("Kafka message (%s) consumed", Arrays.toString(payload)));
                    KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(kieServer, kieUser, kiePass);
                    conf.setMarshallingFormat(MarshallingFormat.XSTREAM);

                    DMNServicesClient dmnServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(DMNServicesClient.class);
                    DMNContext context = dmnServicesClient.newContext();
                    context.set("type", sensorData.get("type"));
                    context.set("value", Float.parseFloat(sensorData.get("value")));
                    ServiceResponse<DMNResult> serverResp = dmnServicesClient.evaluateAll(kieContainer, "pump_rules", "pump_rules", context);
                    DMNResult dmnResult = serverResp.getResult();
                    for (DMNDecisionResult dr : dmnResult.getDecisionResults()) {
                        log.info(String.format("%s: %s, Decision: '%s', Evaluation: %s, Result: %s",
                                sensorData.get("type"), sensorData.get("value"), dr.getDecisionName(), dr.getEvaluationStatus().toString(), dr.getResult()));
                    }
                });
    }
}
