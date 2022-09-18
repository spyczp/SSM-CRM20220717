package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.DicValue;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.DicValueService;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.workbench.bean.Activity;
import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.bean.ContactsRemark;
import com.atom.crm.workbench.bean.Tran;
import com.atom.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ContactsController {

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @Autowired
    private TranService tranService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/contacts/showContactsRemarkList.do")
    @ResponseBody
    public Object showContactsRemarkList(String contactsId){
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsRemarkListByContactsIdForDetail(contactsId);
        return contactsRemarkList;
    }

    @RequestMapping("/workbench/contacts/saveCreateContactsRemark.do")
    @ResponseBody
    public Object saveCreateContactsRemark(ContactsRemark contactsRemark, HttpSession session){
        //封装数据
        contactsRemark.setId(UUIDUtils.getUUID());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        contactsRemark.setCreateBy(loginUser.getId());
        contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        contactsRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject = new ReturnObject();

        try{
            //访问业务层，新增一条联系人备注
            int count = contactsRemarkService.createAContactsRemark(contactsRemark);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("保存联系人备注失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("保存联系人备注失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/contacts/toContactsDetail.do")
    public String toContactsDetail(String id, HttpServletRequest request){
        //访问业务层，获取数据：联系人信息、联系人备注、交易、关联的市场活动
        Contacts contacts = contactsService.queryContactsByIdForDetail(id);
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsRemarkListByContactsIdForDetail(id);
        List<Tran> tranList = tranService.queryTranByContactsIdForDetail(id);
        List<Activity> activityList = activityService.queryActivityListByContactsIdForDetail(id);
        List<User> userList = userService.queryAllUser();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");

        //查询交易阶段可能性数据
        ResourceBundle possibilityBundle = ResourceBundle.getBundle("possibility");
        for(Tran tran: tranList){
            String possibility = possibilityBundle.getString(tran.getStage());
            tran.setPossibility(possibility);
        }

        //保存数据到请求域中
        request.setAttribute("contacts", contacts);
        request.setAttribute("contactsRemarkList", contactsRemarkList);
        request.setAttribute("tranList", tranList);
        request.setAttribute("activityList", activityList);
        request.setAttribute("userList", userList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("appellationList", appellationList);

        //请求转发
        return "workbench/contacts/detail";
    }

    @RequestMapping("/workbench/contacts/deleteContacts.do")
    @ResponseBody
    public Object deleteContacts(String[] id){
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用业务层，删除联系人信息
            contactsService.deleteContactsByIds(id);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除联系人失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/contacts/saveEditContacts.do")
    @ResponseBody
    public Object saveEditContacts(@RequestParam Map<String, Object> map, HttpSession session){
        //封装参数
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        map.put("loginUser", loginUser);

        ReturnObject returnObject = new ReturnObject();

        try {
            //访问业务层，修改联系人信息
            contactsService.saveEditContacts(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("修改联系人信息失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/contacts/toEditContacts.do")
    @ResponseBody
    public Object toEditContacts(String id){
        Contacts contacts = contactsService.queryContactsById(id);
        return contacts;
    }

    @RequestMapping("/workbench/contacts/toCreateContacts.do")
    @ResponseBody
    public Object toCreateContacts(){
        //访问业务层，获取数据
        return null;
    }

    @RequestMapping("/workbench/contacts/saveCreateContacts.do")
    @ResponseBody
    public Object saveCreateContacts(Contacts contacts, HttpSession session){
        //封装数据
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(loginUser.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));

        Map<String, Object> map = new HashMap<>();
        map.put("contacts", contacts);
        map.put("loginUser", loginUser);

        ReturnObject returnObject = new ReturnObject();

        try{
            //访问业务层，新建联系人
            contactsService.saveCreateContacts(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("创建联系人失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/contacts/showCustomerNameListByNameForContactsCreate.do")
    @ResponseBody
    public Object showCustomerNameListByNameForContactsCreate(String name){
        List<String> customerNameList = customerService.queryCustomerNameListByName(name);
        return customerNameList;
    }

    @RequestMapping("/workbench/contacts/showContactsList.do")
    @ResponseBody
    public Object showContactsList(String owner, String fullname, String customerName, String source, String nextContactTime,
                                   Integer pageNo, Integer pageSize){
        //获取参数
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("fullname", fullname);
        map.put("customerName", customerName);
        map.put("source", source);
        map.put("nextContactTime", nextContactTime);
        map.put("startNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        //访问业务层，获取联系人集合和总条数
        List<Contacts> contactsList = contactsService.queryContactsListByCondition(map);
        int totalRows = contactsService.queryContactsCountByCondition(map);

        //封装数据
        Map<String ,Object> map2 = new HashMap<>();
        map2.put("contactsList", contactsList);
        map2.put("totalRows", totalRows);

        //返回json数据给浏览器
        return map2;
    }

    @RequestMapping("/workbench/contacts/goToContactsIndex.do")
    public String goToContactsIndex(HttpServletRequest request){
        //访问业务层，获取数据，填充前端联系人页面的所有下拉列表
        List<User> userList = userService.queryAllUser();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");

        //把数据保存到请求域中
        request.setAttribute("userList", userList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("appellationList", appellationList);

        //请求转发
        return "workbench/contacts/index";
    }
}
