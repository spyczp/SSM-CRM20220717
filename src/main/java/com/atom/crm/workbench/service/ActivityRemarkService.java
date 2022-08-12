package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId);

    int createActivityRemark(ActivityRemark activityRemark);

    List<ActivityRemark> queryActivityRemarkList();

    int deleteActivityRemarkById(String id);

    int saveEditActivityRemark(ActivityRemark activityRemark);
}