package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.mapper.UserMapper;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.mapper.CustomerMapper;
import com.atom.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @RequestMapping("/workbench/customer/showCustomerList.do")
    @ResponseBody
    public Object showCustomerList(String name, String owner, String phone, String website, Integer pageNo, Integer pageSize){
        //封装数据
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        //调业务层，查询客户数据
        List<Customer> customers = customerService.queryCustomerByCondition(map);
        //调业务层，查询总页数
        int totalRows = customerService.queryCountByCondition(map);
        //封装数据
        Map<String, Object> map2 = new HashMap<>();
        map2.put("customers", customers);
        map2.put("totalRows", totalRows);

        return map2;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        customer.setId(UUIDUtils.getUUID());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setCreateBy(loginUser.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        try{
            int count = customerService.createCustomer(customer);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("创建客户失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("创建客户失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.queryAllUser();
        request.setAttribute("users", users);
        return "workbench/customer/index";
    }
}
