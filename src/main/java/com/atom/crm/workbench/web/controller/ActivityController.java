package com.atom.crm.workbench.web.controller;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.domain.ReturnObject;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.HSSFUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.settings.service.UserService;
import com.atom.crm.workbench.bean.Activity;
import com.atom.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;
import java.util.concurrent.ExecutionException;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        System.out.println("跳转到市场活动主页");

        List<User> users = userService.queryAllUser();
        request.setAttribute("users", users);

        return "/workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/createActivity.do")
    @ResponseBody
    public Object createActivity(HttpSession session, Activity activity){
        /*
        *   id
            owner
            name
            endDate
            startDate
            cost
            description
            createTime
            createBy
        *
        * */
        System.out.println("控制器：创建市场活动");
        //设置随机的uuid
        activity.setId(UUIDUtils.getUUID());
        //设置当前日期为创建日期
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        //设置当前登录用户为创建者
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateBy(loginUser.getId());
        ReturnObject returnObject = new ReturnObject();
        try{
            int count = activityService.createActivity(activity);
            if (count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("创建市场活动失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("创建市场活动失败");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name, String owner, String startDate, String endDate,
                                                  int pageNo, int pageSize){
        System.out.println("控制器：根据条件查询市场活动列表");
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        List<Activity> activities = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);

        Map<String, Object> map2 = new HashMap<>();
        map2.put("activityList", activities);
        map2.put("totalRows", totalRows);
        return map2;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int count = activityService.deleteActivityByIds(id);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("删除市场活动失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("删除市场活动失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/modifyActivityById.do")
    @ResponseBody
    public Object modifyActivityById(Activity activity, HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        //添加editTime和editBy
        String editTime = DateUtils.formatDateTime(new Date());
        User loginUser = (User) session.getAttribute(Contants.SESSION_USER);
        String editBy = loginUser.getId();
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);
        try{
            int count = activityService.modifyActivityById(activity);
            if(count == 1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("修改市场活动失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("修改市场活动失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws IOException {
        response.setContentType("applicaion/octet-stream; charset=UTF-8");
        OutputStream out = response.getOutputStream();

        //浏览器在收到响应信息的时候，默认会直接打开信息，即使打不开，也会调用其它应用打开。
        //只有在实在打不开的时候，才会激活文件下载功能，下载响应信息。
        //通过下面这条代码，可以设置浏览器直接激活下载功能，下载响应信息。
        response.addHeader("Content-Disposition", "attachment;filename=mystudentList.xls");

        InputStream is = new FileInputStream("C:\\Users\\Administrator\\Desktop\\studentList.xls");
        byte[] bytes = new byte[256];
        int i = 0;
        while ((i = is.read(bytes)) != -1){
            out.write(bytes, 0, i);
        }

        is.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response){
        //把查询到的所有市场活动信息保存到excel表中。
        List<Activity> activities = activityService.queryAllActivities();

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet();
        HSSFRow row1 = sheet.createRow(0);
        HSSFCell cell = row1.createCell(0);
        cell.setCellValue("id");
        cell = row1.createCell(1);
        cell.setCellValue("owner");
        cell = row1.createCell(2);
        cell.setCellValue("name");
        cell = row1.createCell(3);
        cell.setCellValue("start_date");
        cell = row1.createCell(4);
        cell.setCellValue("end_date");
        cell = row1.createCell(5);
        cell.setCellValue("cost");
        cell = row1.createCell(6);
        cell.setCellValue("description");
        cell = row1.createCell(7);
        cell.setCellValue("create_time");
        cell = row1.createCell(8);
        cell.setCellValue("create_by");
        cell = row1.createCell(9);
        cell.setCellValue("edit_time");
        cell = row1.createCell(10);
        cell.setCellValue("edit_by");

        Activity activity = null;
        if(activities != null && activities.size() > 0){
            for (int i = 1; i <= activities.size(); i++) {
                activity = activities.get(i - 1);
                HSSFRow row = sheet.createRow(i);
                HSSFCell cell1 = row.createCell(0);
                cell1.setCellValue(activity.getId());
                cell1 = row.createCell(1);
                cell1.setCellValue(activity.getOwner());
                cell1 = row.createCell(2);
                cell1.setCellValue(activity.getName());
                cell1 = row.createCell(3);
                cell1.setCellValue(activity.getStartDate());
                cell1 = row.createCell(4);
                cell1.setCellValue(activity.getEndDate());
                cell1 = row.createCell(5);
                cell1.setCellValue(activity.getCost());
                cell1 = row.createCell(6);
                cell1.setCellValue(activity.getDescription());
                cell1 = row.createCell(7);
                cell1.setCellValue(activity.getCreateTime());
                cell1 = row.createCell(8);
                cell1.setCellValue(activity.getCreateBy());
                cell1 = row.createCell(9);
                cell1.setCellValue(activity.getEditTime());
                cell1 = row.createCell(10);
                cell1.setCellValue(activity.getEditBy());
            }
        }

        //把文件通过字节流传递给浏览器
        response.setContentType("application/octet-stream; charset=UTF-8");
        //激活浏览器的下载功能
        response.addHeader("Content-disposition", "attachment;filename=activityList.xls");

        OutputStream out = null;
        try {
            out = response.getOutputStream();
            //直接把内存中的数据wb输出到输出流中。
            wb.write(out);
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                wb.close();
                out.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    @RequestMapping("/workbench/activity/exportActivityByIds.do")
    public void exportActivityByIds(String[] id, HttpServletResponse response){

        List<Activity> activities = activityService.queryActivityByIds(id);

        //创建excel容器
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet();
        HSSFRow row1 = sheet.createRow(0);
        HSSFCell cell = row1.createCell(0);
        cell.setCellValue("id");
        cell = row1.createCell(1);
        cell.setCellValue("owner");
        cell = row1.createCell(2);
        cell.setCellValue("name");
        cell = row1.createCell(3);
        cell.setCellValue("start_date");
        cell = row1.createCell(4);
        cell.setCellValue("end_date");
        cell = row1.createCell(5);
        cell.setCellValue("cost");
        cell = row1.createCell(6);
        cell.setCellValue("description");
        cell = row1.createCell(7);
        cell.setCellValue("create_time");
        cell = row1.createCell(8);
        cell.setCellValue("create_by");
        cell = row1.createCell(9);
        cell.setCellValue("edit_time");
        cell = row1.createCell(10);
        cell.setCellValue("edit_by");

        Activity activity = null;
        if(activities != null && activities.size() > 0){
            for (int i = 1; i <= activities.size(); i++) {
                activity = activities.get(i - 1);
                HSSFRow row = sheet.createRow(i);
                HSSFCell cell1 = row.createCell(0);
                cell1.setCellValue(activity.getId());
                cell1 = row.createCell(1);
                cell1.setCellValue(activity.getOwner());
                cell1 = row.createCell(2);
                cell1.setCellValue(activity.getName());
                cell1 = row.createCell(3);
                cell1.setCellValue(activity.getStartDate());
                cell1 = row.createCell(4);
                cell1.setCellValue(activity.getEndDate());
                cell1 = row.createCell(5);
                cell1.setCellValue(activity.getCost());
                cell1 = row.createCell(6);
                cell1.setCellValue(activity.getDescription());
                cell1 = row.createCell(7);
                cell1.setCellValue(activity.getCreateTime());
                cell1 = row.createCell(8);
                cell1.setCellValue(activity.getCreateBy());
                cell1 = row.createCell(9);
                cell1.setCellValue(activity.getEditTime());
                cell1 = row.createCell(10);
                cell1.setCellValue(activity.getEditBy());
            }
        }

        //创建到浏览器的输出流
        response.setContentType("application/octet-stream; charset=UTF-8");
        //激活浏览器的下载功能
        response.addHeader("Content-disposition", "attachment;filename=activityList.xls");
        OutputStream out = null;

        try {
            out = response.getOutputStream();
            //把excel数据写到输出流里
            wb.write(out);
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                wb.close();
                out.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    @RequestMapping("/workbench/activity/fileUpload.do")
    @ResponseBody
    public Object fileUpload(String userName, MultipartFile myFile) throws IOException {
        System.out.println(userName);

        String originalFilename = myFile.getOriginalFilename();
        File file = new File("D:\\IDEA Project\\springall\\crm_ssm\\crm\\src\\main\\webapp\\WEB-INF\\pages\\workbench\\activity", originalFilename);
        myFile.transferTo(file);

        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        returnObject.setMessage("上传成功");
        return returnObject;
    }


    /**
     * 批量导入市场活动
     * 问题：导入的数据是否合法
     * @param myFile
     * @return
     */
    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile myFile, HttpSession session){
        //从session域中获取当前登录的用户
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        //获取上传的文件的原始名称
        String originalFilename = myFile.getOriginalFilename();
        File file = new File("D:\\IDEA Project\\springall\\crm_ssm\\crm\\src\\main\\webapp\\WEB-INF\\pages\\workbench\\activity", originalFilename);
        //响应给浏览器的信息
        ReturnObject returnObject = new ReturnObject();
        //创建市场活动集合，用来存储所有市场活动
        List<Activity> activities = new ArrayList<>();

        try {
            //把上传的文件保存到本地
            myFile.transferTo(file);
            //读取保存到本地的excel文件
            FileInputStream is = new FileInputStream("D:\\IDEA Project\\springall\\crm_ssm\\crm\\src\\main\\webapp\\WEB-INF\\pages\\workbench\\activity\\" + originalFilename);
            HSSFWorkbook wb = new HSSFWorkbook(is);
            HSSFSheet sheet = wb.getSheetAt(0);

            Activity activity = null;
            //遍历excel表中的所有单元，获取单元数据
            for(int i = 1; i <= sheet.getLastRowNum(); i++){
                HSSFRow row = sheet.getRow(i);
                //创建市场活动对象，封装单元数据
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());
                activity.setName(HSSFUtils.getCellValueForStr(row.getCell(0)));
                activity.setStartDate(HSSFUtils.getCellValueForStr(row.getCell(1)));
                activity.setEndDate(HSSFUtils.getCellValueForStr(row.getCell(2)));
                activity.setCost(HSSFUtils.getCellValueForStr(row.getCell(3)));
                activity.setDescription(HSSFUtils.getCellValueForStr(row.getCell(4)));
                activities.add(activity);
            }
            //保存所有市场活动到数据库
            int count = activityService.saveCreateActivityByList(activities);
            if(count > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(count);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("批量导入市场活动失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("批量导入市场活动失败");
        }
        return returnObject;
    }
}
