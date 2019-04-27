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
  private static final String KIE_SERVER = "http://data-compression-kieserver:8080/services/rest/server";
  private static final String KIE_USER = "jboss";
  private static final String KIE_PASS = "jboss";
  private static final String KIE_CONTAINER = "datacompression";
  @Override
  public void configure() throws Exception {
    //from("kafka:my-topic?brokers=my-cluster-kafka-bootstrap:9091")
    from("{{route.from}}")
    .setBody(constant(600))
    .process(
      new Processor() {
        public void process(Exchange exchange) throws Exception {
          String payload = exchange.getIn().getBody(String.class);
          // do something with the payload and/or exchange here
          HashMap sensorData = new HashMap();
          sensorData.put("type", "motor-temperature");
          sensorData.put("value", payload);
          sensorData.put("units", "F");
          KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(KIE_SERVER, KIE_USER, KIE_PASS);
          conf.setMarshallingFormat(MarshallingFormat.XSTREAM);

          RuleServicesClient ruleServicesClient = KieServicesFactory.newKieServicesClient(conf).getServicesClient(RuleServicesClient.class);

          KieCommands commandsFactory = KieServices.Factory.get().getCommands();
          List<Command<?>> commands = new ArrayList<>();
          commands.add((Command<?>)commandsFactory.newInsert(sensorData));
          commands.add((Command<?>)commandsFactory.newFireAllRules());
          BatchExecutionCommand batch = commandsFactory.newBatchExecution(commands);
          System.out.println(batch.toString());
          ServiceResponse<ExecutionResults> executeResponse = ruleServicesClient.executeCommandsWithResults(KIE_CONTAINER, batch);
          System.out.println(executeResponse);
     }
    });
  }
}
