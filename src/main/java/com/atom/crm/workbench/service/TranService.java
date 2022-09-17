package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.FunnelVO;
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

    Tran queryTranById(String id);

    void editATranStage(Map<String, Object> map);

    List<FunnelVO> queryStageNameAndCountList();

    List<String> queryTranStageNameList();

    List<Tran> queryTranByContactsIdForDetail(String contactsId);
}
