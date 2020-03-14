package com.example.demo.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class IndexController {

    private static final Logger logger = LoggerFactory.getLogger(IndexController.class);
    
    @RequestMapping({ "/", "/index" })
    public ModelAndView get(ModelAndView mav) {
        mav.setViewName("index");
        logger.debug("logger debug");
        logger.info("logger info");
        logger.warn("logger warn");
        logger.error("logger error");
        return mav;
    }
}