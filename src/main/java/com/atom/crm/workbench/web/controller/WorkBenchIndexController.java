package com.atom.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkBenchIndexController {
    @RequestMapping("/workbench/index.do")
    public String index(){
        System.out.println("跳转到工作台主页");
        return "/workbench/index";
    }
}
