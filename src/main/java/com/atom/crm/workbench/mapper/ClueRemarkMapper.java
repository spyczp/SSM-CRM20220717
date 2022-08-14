package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    /**
     * 删除一条线索备注
     * @param id
     * @return
     */
    int deleteClueRemark(String id);

    /**
     * 更新线索备注信息
     * @param clueRemark
     * @return
     */
    int updateClueRemark(ClueRemark clueRemark);

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