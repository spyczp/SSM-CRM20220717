package com.atom.crm.settings.service;

import com.atom.crm.settings.bean.DicValue;

import java.util.List;

public interface DicValueService {

    List<DicValue> queryDicValueByTypeCode(String typeCode);

    String queryValueById(String id);
}
