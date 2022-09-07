package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {

    List<Tran> queryTranByCustomerId(String customerId);

    void saveCreateTran(Map<String, Object> map);

    int deleteTranById(String id);

    List<Tran> queryAllTranForIndex();

    List<Tran> queryTranByCondition(Map<String, Object> map);

    int queryCountByCondition(Map<String, Object> map);
}
