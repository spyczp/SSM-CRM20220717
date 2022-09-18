package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.TranRemark;

import java.util.List;

public interface TranRemarkMapper {

    /**
     * 根据交易id删除对应的交易备注
     * @param tranId
     * @return
     */
    int deleteTranRemarkByTranId(String tranId);

    /**
     * 根据交易的id查询交易备注列表
     * @param tranId
     * @return
     */
    List<TranRemark> selectTranRemarkListByTranId(String tranId);

    /**
     * 创建交易备注
     * @param tranRemarkList
     * @return
     */
    int insertTranRemark(List<TranRemark> tranRemarkList);
}