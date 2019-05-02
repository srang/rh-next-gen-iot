package com.redhat.iot.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.support.converter.MessageConverter;
import org.springframework.stereotype.Component;

import javax.jms.BytesMessage;
import javax.jms.Message;
import javax.jms.TextMessage;
import java.util.Arrays;

@Component
public class AmqpReader {
    
    @JmsListener(destination = "user1")
    public void receiveMessage(Message message) throws Exception {
        System.out.println("Received <" + message.getBody(String.class) + ">");
    }

}
