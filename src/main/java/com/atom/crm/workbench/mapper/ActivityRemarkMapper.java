package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {

    /**
     * 修改市场活动备注信息
     * @param activityRemark
     * @return
     */
    int updateActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据市场活动备注的id删除市场活动备注
     * @param id
     * @return
     */
    int deleteActivityRemarkById(String id);

    /**
     * 查询市场活动备注列表
     * @return
     */
    List<ActivityRemark> selectActivityRemarkList();

    /**
     * 保存市场活动备注信息
     * @param activityRemark
     * @return
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据市场活动id查找市场活动的所有备注信息
     * @param activityId
     * @return
     */
    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String activityId);
}