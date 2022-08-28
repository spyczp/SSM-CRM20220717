package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {

    /**
     * 根据条件查询客户的总条数
     * @param map
     * @return
     */
    int selectCountByCondition(Map<String, Object> map);

    /**
     * 根据条件查询客户信息,所有字段为id的，都通过连表转换为名称
     * @param map
     * @return
     */
    List<Customer> selectCustomerByCondition(Map<String, Object> map);

    /**
     * 新建客户
     * @param customer
     * @return
     */
    int insertCustomer(Customer customer);
}