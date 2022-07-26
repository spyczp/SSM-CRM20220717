package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int createActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);

    int queryCountOfActivityByCondition(Map<String, Object> map);

    int deleteActivityByIds(String[] ids);
}
