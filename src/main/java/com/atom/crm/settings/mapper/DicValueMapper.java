package com.atom.crm.settings.mapper;

import com.atom.crm.settings.bean.DicValue;

import java.util.List;

public interface DicValueMapper {

    /**
     * 根据typeCode查询数据字典
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);
}