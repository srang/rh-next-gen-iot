import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.Processor;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.kie.server.api.marshalling.MarshallingFormat;
import org.kie.server.client.KieServicesClient;
import org.kie.server.client.KieServicesConfiguration;
import org.kie.server.client.KieServicesFactory;

import java.util.HashMap;

import org.apache.camel.Exchange;
//kamel run Sample.java -d mvn:com.google.code.gson:gson:2.8.5 -d camel-gson

public class StreamsReader extends RouteBuilder {
  private static final String KIE_SERVER = "data-compression.svc:8080/kie-server/services/rest/server";
  private static final String KIE_USER = "adminUser";
  private static final String KIE_PASS = "sMTKhI5!";
  @Override
  public void configure() throws Exception {
    HashMap sensorData = new HashMap();
    //from("kafka:my-topic?brokers=my-cluster-kafka-bootstrap:9091")
    from("timer:tick?fixedRate=true&period=2000")
    .setBody(constant(600))
    .process(
      new Processor() {
        public void process(Exchange exchange) throws Exception {
          String payload = exchange.getIn().getBody(String.class);
          // do something with the payload and/or exchange here
          sensorData.put("type", "motor-temperature");
          sensorData.put("value", payload);
          sensorData.put("units", "F");
          exchange.getIn().setBody(sensorData);
          exchange.getIn().setHeader("Content-Type", "application-json")
     }
    })
    .marshal().json(JsonLibrary.Gson, HashMap.class)
    .setHeader(Exchange.HTTP_METHOD, constant(org.apache.camel.component.http4.HttpMethods.POST))
    .log("${body}")
    .toD("http4:" +
            "?authUsername=executionUser" +
            "&authPassword=SWfHOH7!"
    );
  }
}
