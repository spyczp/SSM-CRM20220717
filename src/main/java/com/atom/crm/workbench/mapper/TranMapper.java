package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {

    /**
     * 查询 符合条件的交易 的数量
     * @param map
     * @return
     */
    int selectCountByCondition(Map<String, Object> map);

    /**
     * 根据条件查询交易列表
     * @param map
     * @return
     */
    List<Tran> selectTranByCondition(Map<String, Object> map);

    /**
     * 查询所有交易，用于交易主页面
     * @return
     */
    List<Tran> selectAllTranForIndex();

    /**
     * 根据交易id删除交易
     * @param id
     * @return
     */
    int deleteTranById(String id);

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