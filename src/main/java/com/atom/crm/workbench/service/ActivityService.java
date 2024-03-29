package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int createActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);

    int queryCountOfActivityByCondition(Map<String, Object> map);

    int deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int modifyActivityById(Activity activity);

    List<Activity> queryAllActivities();

    List<Activity> queryActivityByIds(String[] ids);

    int saveCreateActivityByList(List<Activity> activities);

    Activity queryActivityForDetailById(String id);

    List<Activity> queryActivityByClueId(String clueId);

    List<Activity> queryActivityByName(String name);

    List<Activity> queryActivityByNameAndClueId(Map<String, Object> map);

    List<Activity> queryActivityListByName(String name);

    List<Activity> queryActivityListByContactsIdForDetail(String contactsId);

    List<Activity> queryActivityHasNotRelateWithTheContacts(Map<String, Object> map);

    String queryActivityNameById(String id);
}
