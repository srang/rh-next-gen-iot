package com.redhat.iot.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class ResultsController {
    @Autowired
    SimpMessagingTemplate messagingTemplate;

    @PostMapping("/api/results")
    public void receiveResults(@RequestBody String messageBody) {
        messagingTemplate.convertAndSend("/topic/pumpstatus", messageBody);
    }
}
