package com.example.demo.controllers;

import java.util.Date;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IndexController {

    @RequestMapping({ "/", "/index" })
    public ModelAndView get(ModelAndView mav) {
        mav.setViewName("index");
        System.out.println(new Date());
        return mav;
    }
}