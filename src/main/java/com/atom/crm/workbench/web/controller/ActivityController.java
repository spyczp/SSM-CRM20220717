package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.workbench.bean.Activity;
import com.atom.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        System.out.println("跳转到市场活动主页");

        List<User> users = userService.queryAllUser();
        request.setAttribute("users", users);

        return "/workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/createActivity.do")
    @ResponseBody
    public Object createActivity(HttpSession session, Activity activity){
        /*
        *   id
            owner
            name
            enddate
            startdate
            cost
            description
            createtime
            createby
        *
        * */
        //设置随机的uuid
        activity.setId(UUIDUtils.getUUID());
        //设置当前日期为创建日期
        activity.setCreatetime(DateUtils.formatDateTime(new Date()));
        //设置当前登录用户为创建者
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateby(loginUser.getId());
        ReturnObject returnObject = new ReturnObject();
        try{
            int count = activityService.createActivity(activity);
            if (count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("创建市场活动失败");
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        return returnObject;
    }
}
