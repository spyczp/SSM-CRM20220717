package com.atom.crm.workbench.service.impl;

import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.bean.Tran;
import com.atom.crm.workbench.mapper.CustomerMapper;
import com.atom.crm.workbench.mapper.TranMapper;
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

    }
}
