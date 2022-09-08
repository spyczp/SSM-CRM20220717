package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.TranHistory;

import java.util.List;

public interface TranHistoryMapper {

    /**
     * 根据交易的id查询交易历史列表
     * @param tranId
     * @return
     */
    List<TranHistory> selectTranHistoryListByTranId(String tranId);

    /**
     * 新增一条交易历史
     * @param tranHistory
     * @return
     */
    int insertATranHistory(TranHistory tranHistory);
}
