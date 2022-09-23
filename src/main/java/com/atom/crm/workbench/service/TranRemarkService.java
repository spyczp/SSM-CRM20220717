package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.TranRemark;

import java.util.List;

public interface TranRemarkService {

    List<TranRemark> queryTranRemarkListByTranId(String tranId);

    int saveCreateATranRemark(TranRemark tranRemark);

    int saveEditATranRemark(TranRemark tranRemark);

    int deleteTranRemarkById(String id);
}
