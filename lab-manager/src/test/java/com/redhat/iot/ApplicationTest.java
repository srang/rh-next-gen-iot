package com.redhat.iot;

import com.redhat.iot.util.MqttProducer;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit4.SpringRunner;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ApplicationTest {
    @MockBean
    private MqttProducer mqttProducer;
    @Test
    public void testStartup() throws Exception {
        doNothing().when(mqttProducer).connect(any());
        System.out.println("Success");
    }
}
