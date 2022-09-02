package com.atom.crm.workbench.web.controller;

import com.atom.crm.workbench.bean.Activity;
import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.service.ActivityService;
import com.atom.crm.workbench.service.ContactsService;
import com.atom.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class TranController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

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
