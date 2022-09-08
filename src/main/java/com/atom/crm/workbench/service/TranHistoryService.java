package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.TranHistory;

import java.util.List;

public interface TranHistoryService {

    List<TranHistory> queryTranHistoryListByTranId(String tranId);
}
