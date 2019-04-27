package com.redhat.iot;

import org.apache.camel.component.amqp.AMQPConnectionDetails;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Bean
    AMQPConnectionDetails amqpConnection(
            @Value("${MESSAGING_SERVICE}") String messagingHost,
            @Value("${MESSAGING_PORT}") String messagingPort
    ) {
        return new AMQPConnectionDetails(String.format("amqp://%s:%s", messagingHost, messagingPort));
    }

    @Bean
    AMQPConnectionDetails securedAmqpConnection(
            @Value("${MESSAGING_SERVICE}") String messagingHost,
            @Value("${MESSAGING_PORT}") String messagingPort,
            @Value("${MESSAGING_USERNAME}") String messagingUser,
            @Value("${MESSAGING_PASSWORD}") String messagingPass
    ) {
        return new AMQPConnectionDetails(String.format("amqp://%s:%s", messagingHost, messagingPort), messagingUser, messagingPass);
    }
}

