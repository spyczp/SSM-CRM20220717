package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {

    /**
     * 新增单条客户备注
     * @param customerRemark
     * @return
     */
    int insertCustomerRemarkOne(CustomerRemark customerRemark);

    /**
     * 根据客户id查询客户备注
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectCustomerRemarkByCustomerId(String customerId);

    /**
     * 新增一批客户备注
     * @param customerRemarks
     * @return
     */
    int insertCustomerRemark(List<CustomerRemark> customerRemarks);
}