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
import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.bean.CustomerRemark;
import com.atom.crm.workbench.bean.Tran;
import com.atom.crm.workbench.service.ContactsService;
import com.atom.crm.workbench.service.CustomerRemarkService;
import com.atom.crm.workbench.service.CustomerService;
import com.atom.crm.workbench.service.TranService;
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

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @Autowired
    private TranService tranService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/workbench/customer/toCreateTran.do")
    public String toCreateTranInCustomerDetail(HttpServletRequest request){
        //查询用户信息和字典，用来给前端生成下拉标签
        List<User> userList = userService.queryAllUser();
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

         //把数据保存到请求域中
        request.setAttribute("userList", userList);
        request.setAttribute("transactionTypeList", transactionTypeList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("sourceList", sourceList);

        //请求转发到 创建交易 的页面
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/customer/deleteCustomerRemarkById.do")
    @ResponseBody
    public Object deleteCustomerRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用业务层，根据客户备注id删除客户备注信息
            int count = customerRemarkService.deleteCustomerRemarkById(id);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("删除客户备注失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除客户备注失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/editCustomerRemarkInCustomerDetail.do")
    @ResponseBody
    public Object editCustomerRemarkInCustomerDetail(CustomerRemark customerRemark, HttpSession session){
        //封装参数
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        customerRemark.setEditBy(loginUser.getId());
        customerRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);

        ReturnObject returnObject = new ReturnObject();

        try{
            //访问业务层，把修改后的客户备注信息传递进去，进行修改。
            int count = customerRemarkService.editCustomerRemark(customerRemark);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("修改客户备注失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("修改客户备注失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomerRemark.do")
    @ResponseBody
    public Object saveCreateCustomerRemark(CustomerRemark customerRemark, HttpSession session){
        //封装数据
        customerRemark.setId(UUIDUtils.getUUID());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        customerRemark.setCreateBy(loginUser.getId());
        customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject = new ReturnObject();
        try{
            //访问业务层，保存客户备注信息
            int count = customerRemarkService.saveCreateCustomerRemark(customerRemark);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("保存客户备注失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("保存客户备注失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/showCustomerRemarkListInCustomerDetail.do")
    @ResponseBody
    public Object showCustomerRemarkListInCustomerDetail(String customerId){
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkByCustomerId(customerId);
        return customerRemarkList;
    }

    @RequestMapping("/workbench/customer/showCustomerDetail.do")
    public String showCustomerDetail(String id, HttpServletRequest request){
        /*
        *
        * 1.客户详情 ✔
        * 2.备注列表 ✔
        * 3.交易列表 ✔
        * 4.联系人列表 ✔
        * */
        Customer customer = customerService.queryCustomerByIdForDetail(id);
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkByCustomerId(id);
        List<Tran> tranList = tranService.queryTranByCustomerId(id);
        List<Contacts> contactsList = contactsService.queryContactsByCustomerId(id);

        request.setAttribute("customer", customer);
        request.setAttribute("customerRemarkList", customerRemarkList);
        request.setAttribute("tranList", tranList);
        request.setAttribute("contactsList", contactsList);

        return "workbench/customer/detail";
    }

    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    @ResponseBody
    public Object deleteCustomerByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用业务层，根据id删除客户信息
            int count = customerService.deleteCustomerByIds(id);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("删除客户信息失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除客户信息失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/saveEditCustomer.do")
    @ResponseBody
    public Object saveEditCustomer(Customer customer, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        try {
            User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
            customer.setEditBy(loginUser.getId());
            customer.setEditTime(DateUtils.formatDateTime(new Date()));
            //调用业务层，修改客户信息
            int count = customerService.editCustomerInfo(customer);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("更新客户信息失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("更新客户信息失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id){
        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }

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
