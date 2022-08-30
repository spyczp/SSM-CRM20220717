package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkByCustomerId(String customerId);
}
