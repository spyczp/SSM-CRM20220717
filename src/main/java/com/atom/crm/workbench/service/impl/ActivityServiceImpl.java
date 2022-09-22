package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.Activity;
import com.atom.crm.workbench.mapper.ActivityMapper;
import com.atom.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int createActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int modifyActivityById(Activity activity) {
        return activityMapper.updateActivityById(activity);
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    @Override
    public List<Activity> queryActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }

    @Override
    public int saveCreateActivityByList(List<Activity> activities) {
        return activityMapper.insertActivityByList(activities);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityByClueId(String clueId) {
        return activityMapper.selectActivityByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityByName(String name) {
        return activityMapper.selectActivityByName(name);
    }

    @Override
    public List<Activity> queryActivityByNameAndClueId(Map<String, Object> map) {
        return activityMapper.selectActivityByNameAndClueId(map);
    }

    @Override
    public List<Activity> queryActivityListByName(String name) {
        return activityMapper.selectActivityListByName(name);
    }

    @Override
    public List<Activity> queryActivityListByContactsIdForDetail(String contactsId) {
        return activityMapper.selectActivityListByContactsIdForDetail(contactsId);
    }

    @Override
    public List<Activity> queryActivityHasNotRelateWithTheContacts(Map<String, Object> map) {
        return activityMapper.selectActivityHasNotRelateWithTheContacts(map);
    }

    @Override
    public String queryActivityNameById(String id) {
        return activityMapper.selectActivityNameById(id);
    }
}
