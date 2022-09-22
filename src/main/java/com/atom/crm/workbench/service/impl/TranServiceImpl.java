package com.atom.crm.workbench.service.impl;

import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.bean.FunnelVO;
import com.atom.crm.workbench.bean.Tran;
import com.atom.crm.workbench.bean.TranHistory;
import com.atom.crm.workbench.mapper.CustomerMapper;
import com.atom.crm.workbench.mapper.TranHistoryMapper;
import com.atom.crm.workbench.mapper.TranMapper;
import com.atom.crm.workbench.mapper.TranRemarkMapper;
import com.atom.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<Tran> queryTranByCustomerId(String customerId) {
        return tranMapper.selectTranByCustomerId(customerId);
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        Tran tran = (Tran) map.get("tran");
        User loginUser = (User) map.get("loginUser");

        //拿到客户的名称，到底层查询是否存在。不存在则新建
        String customerName = tran.getCustomerId();
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            //把tran的customerId改为新建的customer的id
            tran.setCustomerId(customer.getId());
            customer.setOwner(loginUser.getId());
            customer.setName(customerName);
            customer.setCreateBy(loginUser.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }else{
            tran.setCustomerId(customer.getId());
        }

        tranMapper.insertTran(tran);

        //新增一条交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setCreateBy(loginUser.getId());
        tranHistory.setTranId(tran.getId());
        tranHistoryMapper.insertATranHistory(tranHistory);
    }

    @Override
    public void deleteTranById(String id) {
        /*
        * 1.删除交易备注
        * 2.删除交易
        * */
        tranRemarkMapper.deleteTranRemarkByTranId(id);

        tranMapper.deleteTranById(id);
    }

    @Override
    public List<Tran> queryAllTranForIndex() {
        return tranMapper.selectAllTranForIndex();
    }

    @Override
    public List<Tran> queryTranByCondition(Map<String, Object> map) {
        return tranMapper.selectTranByCondition(map);
    }

    @Override
    public int queryCountByCondition(Map<String, Object> map) {
        return tranMapper.selectCountByCondition(map);
    }

    @Override
    public Tran queryTranById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public Tran queryTranById02(String id) {
        return tranMapper.selectTranById02(id);
    }


    @Override
    public void editATranStage(Map<String, Object> map) {
        //封装数据
        Tran tran = new Tran();
        tran.setId((String) map.get("tranId"));
        tran.setStage((String) map.get("stageId"));
        User loginUser = (User) map.get("loginUser");
        tran.setEditBy(loginUser.getId());
        tran.setEditTime(DateUtils.formatDateTime(new Date()));
        //修改交易的阶段数据
        tranMapper.updateATranStage(tran);

        //新增一条交易记录
        tran = tranMapper.selectTranById02((String) map.get("tranId"));
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setCreateBy(loginUser.getId());
        tranHistory.setTranId(tran.getId());
        tranHistoryMapper.insertATranHistory(tranHistory);
    }

    @Override
    public List<FunnelVO> queryStageNameAndCountList() {
        return tranMapper.selectStageNameAndCountList();
    }

    @Override
    public List<String> queryTranStageNameList() {
        return tranMapper.selectTranStageNameList();
    }

    @Override
    public List<Tran> queryTranByContactsIdForDetail(String contactsId) {
        return tranMapper.selectTranByContactsIdForDetail(contactsId);
    }

    @Override
    public void saveEditTran(Map<String, Object> map) {
        /*
				后端
			* 1.需要判断客户是否存在，不存在则新建。存在则获取它的id。
			  2.判断阶段是否改变。改变，则需要新增阶段历史；不变，则不需要新建阶段历史。
			  3.最后修改交易数据。
			*
			* */
        //获取当前登录用户的信息
        User loginUser = (User) map.get("loginUser");
        //拿到客户名称
        String customerName = (String) map.get("customerName");
        //到数据库查询该客户是否存在。不存在则新建
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer == null){
            //新建客户
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(loginUser.getId());
            customer.setName(customerName);
            customer.setCreateBy(loginUser.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            //访问数据库，新增一条客户数据
            customerMapper.insertCustomer(customer);
        }
        //查询数据库，获取原来的交易阶段id，和前端提交的阶段id比较，若有改变，则需要新建一条阶段历史。
        Tran tran = tranMapper.selectTranById02((String) map.get("id"));
        //拿到前端提交的阶段id
        String stage = (String) map.get("stage");
        //比较
        if(!(tran.getStage().equals(stage))){
            //新建阶段历史
            TranHistory th = new TranHistory();
            th.setId(UUIDUtils.getUUID());
            th.setStage(stage);
            th.setMoney((String)map.get("money"));
            th.setExpectedDate((String)map.get("expectedDate"));
            th.setCreateTime(DateUtils.formatDateTime(new Date()));
            th.setCreateBy(loginUser.getId());
            th.setTranId((String)map.get("id"));
            //访问数据库，新增一条阶段历史
            tranHistoryMapper.insertATranHistory(th);
        }
        //修改交易数据
        tran = new Tran();
        tran.setId((String)map.get("id"));
        tran.setOwner((String)map.get("owner"));
        tran.setMoney((String)map.get("money"));
        tran.setName((String)map.get("name"));
        tran.setExpectedDate((String)map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setStage((String)map.get("stage"));
        tran.setType((String)map.get("type"));
        tran.setSource((String)map.get("source"));
        tran.setActivityId((String)map.get("activityId"));
        tran.setContactsId((String)map.get("contactsId"));
        tran.setEditBy(loginUser.getId());
        tran.setEditTime(DateUtils.formatDateTime(new Date()));
        tran.setDescription((String)map.get("description"));
        tran.setContactSummary((String)map.get("contactSummary"));
        tran.setNextContactTime((String)map.get("nextContactTime"));
        //访问数据库，修改交易数据
        tranMapper.updateATran(tran);
    }
}
