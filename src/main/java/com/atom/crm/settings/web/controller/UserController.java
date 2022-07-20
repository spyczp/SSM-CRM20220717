package com.atom.crm.settings.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.commons.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
    public Object login(String loginAct, String loginPwd, String isRemPwd,
                        HttpServletRequest request, HttpServletResponse response, HttpSession session){
        System.out.println("进入根据浏览器提交的参数获取用户信息并鉴权的控制器");
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);

        ReturnObject returnData = new ReturnObject();

        if(user==null){
            //账号密码错误
            returnData.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnData.setMessage("账号密码错误");
        }else {
            //和当前时间进行比较
            String nowStr = DateUtils.formatDateTime(new Date());
            if(nowStr.compareTo(user.getExpireTime()) > 0){
                //用户已过期
                returnData.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnData.setMessage("用户已过期");
            }else if("1".equals(user.getLockState())){
                //用户已锁定
                returnData.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnData.setMessage("用户已锁定");
            }else if(!(user.getAllowIps().contains(request.getRemoteAddr()))){
                //ip受限
                returnData.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnData.setMessage("用户IP受限");
            }else{
                //鉴权通过
                returnData.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                //把用户信息保存到session域中
                session.setAttribute(Contants.SESSION_USER, user);
                //如果需要10天免登录，则往浏览器提交Cookie
                if("true".equals(isRemPwd)){
                    System.out.println("添加cookie");
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    c1.setMaxAge(10 * 24 * 60 * 60);
                    //设置cookie关联的路径
                    c1.setPath(request.getContextPath());
                    response.addCookie(c1);

                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(10 * 24 * 60 * 60);
                    //设置cookie关联的路径
                    c2.setPath(request.getContextPath());
                    response.addCookie(c2);
                }else{
                    System.out.println("设置cookie失效");
                    //说明没有勾选10天免登录，则把之前可能保存的cookie生命周期设置为0，cookie失效。
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setMaxAge(0);
                    c1.setPath(request.getContextPath());
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setMaxAge(0);
                    c2.setPath(request.getContextPath());
                    response.addCookie(c2);
                }
            }
        }

        return returnData;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletRequest request, HttpServletResponse response, HttpSession session){
        System.out.println("安全退出到登录页面，这个过程会销毁cookie和session");
        //设置cookie失效
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        c1.setPath(request.getContextPath());
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        c2.setPath(request.getContextPath());
        response.addCookie(c2);
        //销毁session
        session.invalidate();

        return "redirect:/";
    }
}
