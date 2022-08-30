package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    int createCustomer(Customer customer);

    List<Customer> queryCustomerByCondition(Map<String, Object> map);

    int queryCountByCondition(Map<String, Object> map);

    Customer queryCustomerById(String id);

    int editCustomerInfo(Customer customer);

    int deleteCustomerByIds(String[] id);

    Customer queryCustomerByIdForDetail(String id);
}
