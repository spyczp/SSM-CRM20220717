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
import com.atom.crm.workbench.bean.Clue;
import com.atom.crm.workbench.bean.ClueRemark;
import com.atom.crm.workbench.mapper.ClueRemarkMapper;
import com.atom.crm.workbench.service.ActivityService;
import com.atom.crm.workbench.service.ClueRemarkService;
import com.atom.crm.workbench.service.ClueService;
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
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/clue/queryClueByIdForDetail.do")
    public String queryClueByIdForDetail(String id, HttpServletRequest request){
        Clue clue = clueService.queryClueInfoById(id);
        List<ClueRemark> clueRemarks = clueRemarkService.queryClueRemarkByClueId(id);
        List<Activity> activities = activityService.queryActivityByClueId(id);

        request.setAttribute("clue", clue);
        request.setAttribute("clueRemarks", clueRemarks);
        request.setAttribute("activities", activities);

        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    @ResponseBody
    public Object deleteClueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();

        try{
            int count = clueService.deleteClueByIds(id);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("删除失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/editClue.do")
    @ResponseBody
    public Object editClue(Clue clue, HttpSession session){

        ReturnObject returnObject = new ReturnObject();

        //封装数据
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setEditBy(loginUser.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));

        try{
            int count = clueService.updateClue(clue);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("修改线索数据失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("修改线索数据失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id){
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/workbench/clue/queryClueByCondition.do")
    @ResponseBody
    public Object queryClueByCondition(String fullname, String owner, String company, String mphone,
                                       String phone, String state, String source, int pageNo, int pageSize){
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("fullname", fullname);
        map.put("owner", owner);
        map.put("company", company);
        map.put("mphone", mphone);
        map.put("phone", phone);
        map.put("state", state);
        map.put("source", source);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        List<Clue> clues = clueService.queryClueByCondition(map);
        int totalRows = clueService.queryCountOfClueByCondition(map);

        Map<String, Object> map2 = new HashMap<>();
        map2.put("clues", clues);
        map2.put("totalRows", totalRows);

        return map2;
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        //封装数据
        clue.setId(UUIDUtils.getUUID());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setCreateBy(loginUser.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));

        try{
            int count = clueService.saveCreateClue(clue);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("保存线索失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("保存线索失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.queryAllUser();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("users", users);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("clueStateList", clueStateList);
        request.setAttribute("sourceList", sourceList);

        return "workbench/clue/index";
    }
}
