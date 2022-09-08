package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.TranHistory;
import com.atom.crm.workbench.mapper.TranHistoryMapper;
import com.atom.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranHistoryServiceImpl implements TranHistoryService {

    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public List<TranHistory> queryTranHistoryListByTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryListByTranId(tranId);
    }
}
