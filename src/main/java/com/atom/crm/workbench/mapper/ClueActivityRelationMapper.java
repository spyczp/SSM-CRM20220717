package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {

    /**
     * 新增线索和市场活动关联数据
     * @param clueActivityRelationList
     * @return
     */
    int insertClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList);
}
