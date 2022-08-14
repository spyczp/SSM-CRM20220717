package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> queryClueRemarkByClueId(String clueId);

    int createClueRemark(ClueRemark clueRemark);

    int editClueRemark(ClueRemark clueRemark);
}
