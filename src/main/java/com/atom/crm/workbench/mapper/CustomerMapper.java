package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {

    /**
     * 根据用户输入的名称查询客户名称列表
     * @param name
     * @return
     */
    List<String> selectCustomerNameListByName(String name);

    /**
     * 删除 指定一些id 的客户信息
     * @param id
     * @return
     */
    int deleteCustomerByIds(String[] id);

    /**
     * 更新一条客户的信息
     * @param customer
     * @return
     */
    int updateCustomer(Customer customer);

    /**
     * 根据客户id查询客户信息，会进行表连接，把一些字段是uuid的值转为名称
     * @param id
     * @return
     */
    Customer selectCustomerByIdConnectOtherTable(String id);

    /**
     * 根据客户id查询客户信息
     * @param id
     * @return
     */
    Customer selectCustomerById(String id);

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