package com.atom.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
    @RequestMapping("/workbench/main/index.do")
    public String index(){
        System.out.println("进入工作台主页");
        return "/workbench/main/index";
    }
}
