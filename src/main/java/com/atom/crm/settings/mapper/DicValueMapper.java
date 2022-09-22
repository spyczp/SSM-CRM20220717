package com.atom.crm.settings.mapper;

import com.atom.crm.settings.bean.DicValue;

import java.util.List;

public interface DicValueMapper {

    /**
     * 根据id查询字典名称
     * @param id
     * @return
     */
    String selectValueById(String id);

    /**
     * 根据typeCode查询数据字典
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);
}