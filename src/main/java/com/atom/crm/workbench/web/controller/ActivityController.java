package com.atom.crm.workbench.web.controller;

import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        System.out.println("跳转到市场活动主页");

        List<User> users = userService.queryAllUser();
        request.setAttribute("users", users);

        return "/workbench/activity/index";
    }

}
