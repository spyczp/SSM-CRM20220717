package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.Tran;
import com.atom.crm.workbench.mapper.TranMapper;
import com.atom.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;

    @Override
    public List<Tran> queryTranByCustomerId(String customerId) {
        return tranMapper.selectTranByCustomerId(customerId);
    }
}
