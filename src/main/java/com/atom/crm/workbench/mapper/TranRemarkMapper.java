package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.TranRemark;

import java.util.List;

public interface TranRemarkMapper {

    /**
     * 创建交易备注
     * @param tranRemarkList
     * @return
     */
    int insertTranRemark(List<TranRemark> tranRemarkList);
}