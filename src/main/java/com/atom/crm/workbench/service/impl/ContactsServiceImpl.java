package com.atom.crm.workbench.service.impl;

import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.bean.Customer;
import com.atom.crm.workbench.mapper.ContactsMapper;
import com.atom.crm.workbench.mapper.CustomerMapper;
import com.atom.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Contacts> queryContactsByCustomerId(String customerId) {
        return contactsMapper.selectContactsByCustomerId(customerId);
    }

    @Override
    public List<Contacts> queryContactsListByName(String name) {
        return contactsMapper.selectContactsListByName(name);
    }

    @Override
    public void saveCreateContacts(Map<String, Object> map) {
        Contacts contacts = (Contacts) map.get("contacts");
        User loginUser = (User) map.get("loginUser");
        //拿到客户名称
        String customerName = contacts.getCustomerId();
        //到数据访问层查询客户名称是否存在。存在，则找到id，把id赋值给contacts.customerId。不存在，则新建客户，把新的客户id赋值给contacts.customerId
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer == null){
            //新建客户
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            //保存id到contacts.customerId
            contacts.setCustomerId(customer.getId());
            customer.setOwner(loginUser.getId());
            customer.setName(customerName);
            customer.setCreateBy(loginUser.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());
            //调用数据访问层，新建客户数据
            customerMapper.insertCustomer(customer);
        }else {
            //保存id到contacts.customerId
            contacts.setCustomerId(customer.getId());
        }

        //调用数据访问层，新建联系人
        contactsMapper.insertContacts(contacts);
    }

    @Override
    public int deleteContactsById(String id) {
        return contactsMapper.deleteContactsById(id);
    }

    @Override
    public List<Contacts> queryContactsListByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsListByCondition(map);
    }

    @Override
    public int queryContactsCountByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsCountByCondition(map);
    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }

    @Override
    public void saveEditContacts(Map<String, Object> map) {
        //获取当前登录用户的信息
        User loginUser = (User) map.get("loginUser");
        //获取客户名称
        String customerName = (String) map.get("customerName");
        //到数据访问层，查询客户名称是否存在，存在，则返回客户id；不存在，则新建客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer == null){
            //不存在，则新建客户
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(loginUser.getId());
            customer.setName(customerName);
            customer.setCreateBy(loginUser.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setContactSummary((String) map.get("contactSummary"));
            customer.setNextContactTime((String) map.get("nextContactTime"));
            customer.setDescription((String) map.get("description"));
            customer.setAddress((String) map.get("address"));
            //访问数据访问层，新建客户
            customerMapper.insertCustomer(customer);
        }
        //修改联系人信息
        map.put("editBy", loginUser.getId());
        map.put("editTime", DateUtils.formatDateTime(new Date()));
        map.put("customerId", customer.getId());
        contactsMapper.updateAContacts(map);
    }
}
