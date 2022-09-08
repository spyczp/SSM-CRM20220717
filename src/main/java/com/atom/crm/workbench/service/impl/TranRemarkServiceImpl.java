package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.TranRemark;
import com.atom.crm.workbench.mapper.TranRemarkMapper;
import com.atom.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranRemarkServiceImpl implements TranRemarkService {

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<TranRemark> queryTranRemarkListByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkListByTranId(tranId);
    }
}
