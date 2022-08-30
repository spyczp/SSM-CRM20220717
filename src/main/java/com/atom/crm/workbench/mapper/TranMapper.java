package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Tran;

import java.util.List;

public interface TranMapper {

    /**
     * 根据客户id查询交易信息
     * @param customerId
     * @return
     */
    List<Tran> selectTranByCustomerId(String customerId);

    /**
     * 创建一条交易
     * @param tran
     * @return
     */
    int insertTran(Tran tran);
}