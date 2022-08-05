package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.ActivityRemark;
import com.atom.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/createActivityRemark.do")
    @ResponseBody
    public Object createActivityRemark(ActivityRemark activityRemark, HttpSession session){
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        activityRemark.setCreateBy(loginUser.getId());
        activityRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject = new ReturnObject();

        try{
            //调用业务层，把市场活动备注信息保存到数据库
            int count = activityRemarkService.createActivityRemark(activityRemark);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("创建市场活动备注信息失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("创建市场活动备注信息失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/showActivityRemarkList.do")
    @ResponseBody
    public Object showActivityRemarkList(){

        List<ActivityRemark> activityRemarks = activityRemarkService.queryActivityRemarkList();

        return activityRemarks;
    }
}
