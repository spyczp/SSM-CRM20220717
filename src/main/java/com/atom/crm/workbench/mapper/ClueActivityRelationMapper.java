package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationMapper {

    /**
     * 删除指定clueId对应的所有线索和市场活动关联关系
     * @param clueId
     * @return
     */
    int deleteClueActivityRelationByClueId(String clueId);

    /**
     * 根据线索id查询线索和市场活动的关联关系
     * @param clueId
     * @return
     */
    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    /**
     * 根据线索id和市场活动id删除关联数据
     * @param map
     * @return
     */
    int deleteClueActivityRelationByClueIdAndActivityId(Map<String, Object> map);

    /**
     * 新增线索和市场活动关联数据
     * @param clueActivityRelationList
     * @return
     */
    int insertClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList);
}
