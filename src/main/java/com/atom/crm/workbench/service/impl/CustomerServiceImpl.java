package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.mapper.CustomerMapper;
import com.atom.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public int createCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCustomerByCondition(map);
    }

    @Override
    public int queryCountByCondition(Map<String, Object> map) {
        return customerMapper.selectCountByCondition(map);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int editCustomerInfo(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    @Override
    public int deleteCustomerByIds(String[] id) {
        return customerMapper.deleteCustomerByIds(id);
    }
}
