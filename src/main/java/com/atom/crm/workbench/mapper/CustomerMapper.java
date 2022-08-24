package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Customer;

public interface CustomerMapper {

    /**
     * 新建客户
     * @param customer
     * @return
     */
    int insertCustomer(Customer customer);
}