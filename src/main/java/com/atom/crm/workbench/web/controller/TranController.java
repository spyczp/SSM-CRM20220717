package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.DicValue;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.DicValueService;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.workbench.bean.*;
import com.atom.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.*;

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

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private TranRemarkService tranRemarkService;

    @Autowired
    private TranHistoryService tranHistoryService;

    @RequestMapping("/workbench/transaction/showStageIcon.do")
    @ResponseBody
    public Object getStageList(){
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        //获取可能性数据列表
        Properties possibilityList = new Properties();
        try {
            InputStream is = new FileInputStream("D:\\IDEA Project\\springall\\crm_ssm\\crm\\src\\main\\resources\\possibility.properties");
            possibilityList.load(is);
        } catch (Exception e) {
            e.printStackTrace();
        }

        Map<String, Object> map = new HashMap<>();
        map.put("stageList", stageList);
        map.put("possibilityList", possibilityList);

        return map;
    }

    @RequestMapping("/workbench/transaction/toTranDetail.do")
    public String toTranDetail(String id, HttpServletRequest request){
        //访问业务层，获取数据
        Tran tran = tranService.queryTranById(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkListByTranId(id);
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryListByTranId(id);

        //获取可能性数据
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());

        //保存数据到请求域中
        request.setAttribute("tran", tran);
        request.setAttribute("tranRemarkList", tranRemarkList);
        request.setAttribute("tranHistoryList", tranHistoryList);
        request.setAttribute("possibility", possibility);

        //请求转发到交易详情页
        return "workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/showPossibilityOfTran.do")
    @ResponseBody
    public Object showPossibilityOfTran(String stageValue){
        ResourceBundle b = ResourceBundle.getBundle("possibility");
        String possibility = b.getString(stageValue);
        return possibility;
    }

    @RequestMapping("/workbench/transaction/toTranSave.do")
    public String toTranSave(HttpServletRequest request){
        //获取数据
        List<User> userList = userService.queryAllUser();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        //保存数据到请求域中
        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("transactionTypeList", transactionTypeList);
        request.setAttribute("sourceList", sourceList);

        //请求转发到save页面
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/showTranListForIndex.do")
    @ResponseBody
    public Object showTranListForIndex(String owner, String name, String customerName, String stage,
                                       String type, String source, String contactsName, Integer pageNo,
                                       Integer pageSize){
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerName", customerName);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsName", contactsName);
        map.put("startNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        //调用业务层，根据条件查询交易列表和交易总数
        List<Tran> tranList = tranService.queryTranByCondition(map);
        int totalRows = tranService.queryCountByCondition(map);

        //封装数据
        Map<String, Object> map2 = new HashMap<>();
        map2.put("tranList", tranList);
        map2.put("totalRows", totalRows);

        return map2;
    }

    @RequestMapping("/workbench/transaction/toTranIndex.do")
    public String toTranIndex(HttpServletRequest request){
        //访问业务层，获取需要的数据
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        //把数据保存到请求域中
        request.setAttribute("stageList", stageList);
        request.setAttribute("transactionTypeList", transactionTypeList);
        request.setAttribute("sourceList", sourceList);

        //请求转发到index页面
        return "workbench/transaction/index";
    }

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