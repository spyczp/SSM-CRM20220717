package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkByCustomerId(String customerId);

    int saveCreateCustomerRemark(CustomerRemark customerRemark);

    int editCustomerRemark(CustomerRemark customerRemark);

    int deleteCustomerRemarkById(String id);
}
