package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {

    /**
     * 根据客户id查询客户备注
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectCustomerRemarkByCustomerId(String customerId);

    /**
     * 新增客户备注
     * @param customerRemarks
     * @return
     */
    int insertCustomerRemark(List<CustomerRemark> customerRemarks);
}