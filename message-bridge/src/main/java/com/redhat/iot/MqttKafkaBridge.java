import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.Processor;
import org.apache.camel.model.dataformat.JsonLibrary;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

import org.apache.camel.Exchange;

public class MqttKafkaBridge extends RouteBuilder {
  @Override
  public void configure() throws Exception {
//    from("mqtt:mqttconsumer?subscribeTopicName=user1&host=tcp://broker-amq-headless:1883")
    from("amqp:topic:user1")
    .process(
      new Processor() {
        public void process(Exchange exchange) throws Exception {
          String[] payload = exchange.getIn().getBody(String.class).split(",");
          HashMap sensorData = new HashMap();
          sensorData.put("pumpId", payload[0]);
          sensorData.put("type", payload[1]);
          sensorData.put("timestamp", payload[2]);
          sensorData.put("value", payload[3]);
          switch(payload[1]) {
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
          exchange.getIn().setBody(sensorData);
        }
    })
    .marshal().json(JsonLibrary.Gson, HashMap.class)
    .log("${body}");
    //.to("kafka:my-topic?brokers=my-cluster-kafka-bootstrap:9091");
  }
}
