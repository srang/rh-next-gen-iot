import com.google.gson.Gson;
import org.apache.camel.builder.RouteBuilder;
import org.kie.dmn.api.core.DMNContext;
import org.kie.dmn.api.core.DMNDecisionResult;
import org.kie.dmn.api.core.DMNResult;
import org.kie.server.api.marshalling.MarshallingFormat;
import org.kie.server.api.model.ServiceResponse;
import org.kie.server.client.DMNServicesClient;
import org.kie.server.client.KieServicesConfiguration;
import org.kie.server.client.KieServicesFactory;

import java.util.Map;

public class StreamsReader extends RouteBuilder {
    private static final String KIE_SERVER = "http://rules-manager-kieserver:8080/services/rest/server";
    private static final String KIE_USER = "jboss";
    private static final String KIE_PASS = "jboss";
    private static final String KIE_CONTAINER = "esp_rules";

    @Override
    public void configure() throws Exception {
        from("kafka:user1-data?brokers=iot-cluster-kafka-bootstrap.kafka.svc:9092")
                .process(exchange -> {
                    String message = exchange.getIn().getBody(String.class);
                    Map payload = new Gson().fromJson(message, Map.class);
                    log.info(String.format("Kafka message (%s) consumed", payload.toString()));

                    KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(KIE_SERVER, KIE_USER, KIE_PASS);
                    conf.setMarshallingFormat(MarshallingFormat.XSTREAM);

                    DMNServicesClient dmnServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(DMNServicesClient.class);
                    DMNContext context = dmnServicesClient.newContext();
                    context.set("type", payload.get("type"));
                    context.set("value", Float.parseFloat((String) payload.get("value")));
                    ServiceResponse<DMNResult> serverResp = dmnServicesClient.evaluateAll(KIE_CONTAINER, "pump_rules", "pump_rules", context);
                    DMNResult dmnResult = serverResp.getResult();
                    for (DMNDecisionResult dr : dmnResult.getDecisionResults()) {
                        log.info(String.format("%s: %s, Decision: '%s', Evaluation: %s, Result: %s",
                                payload.get("type"), payload.get("value"), dr.getDecisionName(), dr.getEvaluationStatus().toString(), dr.getResult()));
                    }
                });
    }
}


