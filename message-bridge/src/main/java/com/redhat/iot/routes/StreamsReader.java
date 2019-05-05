
import java.util.Map;
import org.apache.camel.builder.RouteBuilder;
import org.kie.dmn.api.core.DMNContext;
import org.kie.dmn.api.core.DMNDecisionResult;
import org.kie.dmn.api.core.DMNResult;
import org.kie.server.api.marshalling.MarshallingFormat;
import org.kie.server.api.model.ServiceResponse;
import org.kie.server.client.DMNServicesClient;
import org.kie.server.client.KieServicesConfiguration;
import org.kie.server.client.KieServicesFactory;
import org.apache.camel.component.jackson.JacksonDataFormat;


import org.apache.camel.Exchange;
//kamel run StreamsReader.java -d mvn:org.kie.server:kie-server-client:7.18.0.Final -d camel-kafka -d camel-jackson --configmap application-yml



public class StreamsReader extends RouteBuilder {
  private static final String KIE_SERVER = "http://rules-manager-kieserver.user1.svc:8080/services/rest/server";
  private static final String KIE_USER = "jboss";
  private static final String KIE_PASS = "jboss";
  private static final String KIE_CONTAINER = "esp_rules";

  private static final String BROKER_URL = "iot-cluster-kafka-bootstrap.kafka.svc:9092";

  @Override
  public void configure() throws Exception {
    JacksonDataFormat jacksonDataFormat = new JacksonDataFormat();
    jacksonDataFormat.setUnmarshalType(Map.class);

    KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(KIE_SERVER, KIE_USER, KIE_PASS);
    conf.setMarshallingFormat(MarshallingFormat.XSTREAM);
    
    DMNServicesClient dmnServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(DMNServicesClient.class);
    DMNContext context = dmnServicesClient.newContext();
    
    //+"&groupId=user1"
    from("kafka:user1-data?brokers="+BROKER_URL)
    .log("from kafka ${body}")
    .unmarshal(jacksonDataFormat)
      .process(exchange -> {
        
        context.set("type", exchange.getIn().getBody(Map.class).get("type"));
        context.set("value", Float.parseFloat((String) exchange.getIn().getBody(Map.class).get("value")));
        ServiceResponse<DMNResult> serverResp = dmnServicesClient.evaluateAll(KIE_CONTAINER, "pump_rules", "pump_rules", context);
        DMNResult dmnResult = serverResp.getResult();
        for (DMNDecisionResult dr : dmnResult.getDecisionResults()) {
            log.info(String.format("%s: %s, Decision: '%s', Evaluation: %s, Result: %s",
            exchange.getIn().getBody(Map.class).get("type"), exchange.getIn().getBody(Map.class).get("value"), dr.getDecisionName(), dr.getEvaluationStatus().toString(), dr.getResult()));
        }
      });

  }
}

