package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.Activity;
import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.bean.Tran;
import com.atom.crm.workbench.service.ActivityService;
import com.atom.crm.workbench.service.ContactsService;
import com.atom.crm.workbench.service.CustomerService;
import com.atom.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TranController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private TranService tranService;

    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(Tran tran, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        //封装参数
        tran.setId(UUIDUtils.getUUID());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        tran.setCreateBy(loginUser.getId());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        Map<String , Object> map = new HashMap<>();
        map.put("loginUser", loginUser);
        map.put("tran", tran);

        //调用业务层，保存创建的 交易
        try{
            tranService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("创建交易失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/showContactsListByName.do")
    @ResponseBody
    public Object showContactsListByName(String name){
        List<Contacts> contactsList = contactsService.queryContactsListByName(name);
        return contactsList;
    }

    @RequestMapping("/workbench/transaction/showActivityListByName.do")
    @ResponseBody
    public Object showActivityListByName(String name){
        List<Activity> activityList = activityService.queryActivityListByName(name);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryCustomerNameListByNameForTranCreate.do")
    @ResponseBody
    public Object queryCustomerNameListByNameForTranCreate(String name){
        List<String> customerNameList = customerService.queryCustomerNameListByName(name);
        return customerNameList;
    }
}
