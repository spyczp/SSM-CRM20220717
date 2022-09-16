package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.DicValue;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.DicValueService;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.service.ContactsService;
import com.atom.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
