package com.atom.crm.settings.service.impl;

import com.atom.crm.settings.bean.DicValue;
import com.atom.crm.settings.mapper.DicValueMapper;
import com.atom.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }

    @Override
    public String queryValueById(String id) {
        return dicValueMapper.selectValueById(id);
    }
}
