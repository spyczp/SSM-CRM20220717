package com.atom.crm.settings.web.controller;

import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        System.out.println("跳转到登录页面");
        return "settings/qx/user/login";
    }

    /**
     * 根据浏览器提交的用户名和密码获取登录数据，并判断查到的用户是否有权限。
     * @return
     */
    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request){
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);

        ReturnObject returnData = new ReturnObject();

        if(user==null){
            //账号密码错误
            returnData.setCode("0");
            returnData.setMessage("账号密码错误");
        }else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date now = new Date();
            String nowStr = sdf.format(now);
            if(nowStr.compareTo(user.getExpireTime()) > 0){
                //用户已过期
                returnData.setCode("0");
                returnData.setMessage("用户已过期");
            }else if("1".equals(user.getLockState())){
                //用户已锁定
                returnData.setCode("0");
                returnData.setMessage("用户已锁定");
            }else if(!(user.getAllowIps().contains(request.getRemoteAddr()))){
                //ip受限
                returnData.setCode("0");
                returnData.setMessage("用户IP受限");
            }else{
                //鉴权通过
                returnData.setCode("1");
            }
        }

        return returnData;
    }
}
