package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Tran;

import java.util.List;

public interface TranService {

    List<Tran> queryTranByCustomerId(String customerId);
}
