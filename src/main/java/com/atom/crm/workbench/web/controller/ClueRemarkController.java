package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.ClueRemark;
import com.atom.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/deleteClueRemark.do")
    @ResponseBody
    public Object deleteClueRemark(String id){
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用业务层，删除线索备注
            int count = clueRemarkService.deleteClueRemark(id);
            if(count > 0){
                //删除成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                //删除失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("删除线索备注失败");
            }
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除线索备注失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/editClueRemark.do")
    @ResponseBody
    public Object editClueRemark(ClueRemark clueRemark, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        //封装参数
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        clueRemark.setEditBy(loginUser.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);

        try{
            int count = clueRemarkService.editClueRemark(clueRemark);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("修改线索备注失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("修改线索备注失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/showClueRemarkList.do")
    @ResponseBody
    public Object showClueRemarkList(String clueId){
        List<ClueRemark> clueRemarks = clueRemarkService.queryClueRemarkByClueId(clueId);

        return clueRemarks;
    }

    @RequestMapping("/workbench/clue/createClueRemark.do")
    @ResponseBody
    public Object createClueRemark(ClueRemark clueRemark, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        //封装数据
        clueRemark.setId(UUIDUtils.getUUID());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        clueRemark.setCreateBy(loginUser.getId());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        try{
            //调用业务层，传递数据
            int count = clueRemarkService.createClueRemark(clueRemark);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("新建线索备注失败");
            }
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("新建线索备注失败");
        }

        return returnObject;
    }
}
