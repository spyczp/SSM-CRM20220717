package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.TranRemark;

import java.util.List;

public interface TranRemarkMapper {

    /**
     * 根据交易备注id删除交易备注
     * @param id
     * @return
     */
    int deleteTranRemarkById(String id);

    /**
     * 修改一条交易备注
     * @param tranRemark
     * @return
     */
    int updateATranRemark(TranRemark tranRemark);

    /**
     * 新增一条交易备注
     * @param tranRemark
     * @return
     */
    int insertATranRemark(TranRemark tranRemark);

    /**
     * 根据一系列交易id删除交易备注
     * @param tranIds
     * @return
     */
    int deleteTranRemarkByTranIds(String[] tranIds);

    /**
     * 根据交易id删除对应的交易备注
     * @param tranId
     * @return
     */
    int deleteTranRemarkByTranId(String tranId);

    /**
     * 根据交易的id查询交易备注列表
     * @param tranId
     * @return
     */
    List<TranRemark> selectTranRemarkListByTranId(String tranId);

    /**
     * 创建交易备注
     * @param tranRemarkList
     * @return
     */
    int insertTranRemark(List<TranRemark> tranRemarkList);
}