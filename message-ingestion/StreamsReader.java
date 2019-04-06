import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.Processor;
import org.apache.camel.model.dataformat.JsonLibrary;

import java.util.HashMap;

import org.apache.camel.Exchange;
//kamel run Sample.java -d mvn:com.google.code.gson:gson:2.8.5 -d camel-gson

public class IotSample extends RouteBuilder {
  @Override
  public void configure() throws Exception {
    HashMap sensorData = new HashMap();
    //from("kafka:my-topic?brokers=my-cluster-kafka-bootstrap:9091")
    from("timer:tick?fixedRate=true&period=2000")
    .setBody(constant(1.2))
    .process(
      new Processor() {
        public void process(Exchange exchange) throws Exception {
          String payload = exchange.getIn().getBody(String.class);
          // do something with the payload and/or exchange here
          sensorData.put("id", 1);
          sensorData.put("type", "type");
          sensorData.put("value", payload);
          sensorData.put("units", "theUnit");
          exchange.getIn().setBody(sensorData);
     }
    })
    .marshal().json(JsonLibrary.Gson, HashMap.class)
    .log("${body}")
    .toD("http4://")
    ;       
  }
}
