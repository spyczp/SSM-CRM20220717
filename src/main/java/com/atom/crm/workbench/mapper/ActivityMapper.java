package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {

    /**
     * 根据名称模糊查询市场活动
     * @param name
     * @return
     */
    List<Activity> selectActivityByName(String name);

    /*通过线索id查询市场活动，要用到tbl_clue_activity_relation表*/
    List<Activity> selectActivityByClueId(String clueId);

    /**
     * 根据市场活动的id查找市场活动信息
     * @param id
     * @return
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 批量导入市场活动
     * @param activities
     * @return
     */
    int insertActivityByList(List<Activity> activities);

    /**
     * 根据1个以上的id查找市场活动信息
     * @param ids
     * @return 市场活动列表
     */
    List<Activity> selectActivityByIds(String[] ids);

    /**
     * 查询所有市场活动信息
     * @return
     */
    List<Activity> selectAllActivities();

    /**
     * 根据市场活动id修改指定的市场活动数据
     * @param activity
     * @return
     */
    int updateActivityById(Activity activity);

    /**
     * 根据市场活动的id查找市场活动信息
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 根据市场活动id组成的数组批量删除市场活动信息。
     * @param ids
     * @return
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据条件查询市场活动的总条数
     * @param map
     * @return
     */
    int selectCountOfActivityByCondition(Map<String, Object> map);

    /**
     * 根据条件分页查询市场活动的列表
     * @param map
     * @return
     */
    List<Activity> selectActivityByConditionForPage(Map<String, Object> map);

    /**
     * 创建市场活动
     * @param activity
     * @return
     */
    int insertActivity(Activity activity);

}