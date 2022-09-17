package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.FunnelVO;
import com.atom.crm.workbench.bean.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {

    /**
     * 根据联系人id查询交易列表
     * @param contactsId
     * @return
     */
    List<Tran> selectTranByContactsIdForDetail(String contactsId);

    /**
     * 查询存在的交易阶段名称
     * @return
     */
    List<String> selectTranStageNameList();

    /**
     * 查询各个交易阶段的数量
     * @return [{"name": 阶段, "value": 数量},{"name": 阶段, "value": 数量},{"name": 阶段, "value": 数量},...]
     */
    List<FunnelVO> selectStageNameAndCountList();

    /**
     * 修改一条交易的阶段数据。同时要改edit_by，edit_time
     * @param tran
     * @return
     */
    int updateATranStage(Tran tran);

    /**
     * 根据交易id查询交易数据，不连表
     * @param id
     * @return
     */
    Tran selectTranById02(String id);

    /**
     * 根据交易的id查询交易信息,连表解析id
     * @param id
     * @return
     */
    Tran selectTranById(String id);

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