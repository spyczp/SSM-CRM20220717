package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    /**
     * 新增一条线索备注
     * @param clueRemark
     * @return
     */
    int insertClueRemark(ClueRemark clueRemark);

    /**
     * 根据线索id查询线索备注
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkByClueId(String clueId);
}