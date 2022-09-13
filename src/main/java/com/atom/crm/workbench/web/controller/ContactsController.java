package com.atom.crm.workbench.web.controller;

import com.atom.crm.settings.bean.DicValue;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.DicValueService;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.settings.service.impl.UserServiceImpl;
import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
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

    @RequestMapping("/workbench/contacts/toCreateContacts.do")
    @ResponseBody
    public Object toCreateContacts(){
        //访问业务层，获取数据
        return null;
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
