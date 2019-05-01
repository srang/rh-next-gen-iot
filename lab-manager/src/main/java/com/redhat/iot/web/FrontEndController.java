package com.redhat.iot.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

//@Controller
public class FrontEndController {
    @RequestMapping(value = "/")
    public String index() {
        return "index";
    }
}
