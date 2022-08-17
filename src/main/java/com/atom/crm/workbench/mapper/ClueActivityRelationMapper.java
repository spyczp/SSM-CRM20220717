package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationMapper {
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
