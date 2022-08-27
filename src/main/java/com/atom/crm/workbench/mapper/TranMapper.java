package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Tran;

public interface TranMapper {

    /**
     * 创建一条交易
     * @param tran
     * @return
     */
    int insertTran(Tran tran);
}