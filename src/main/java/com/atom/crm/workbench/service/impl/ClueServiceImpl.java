package com.atom.crm.workbench.service.impl;

import com.atom.crm.commons.contants.Contants;
import com.atom.crm.commons.utils.DateUtils;
import com.atom.crm.commons.utils.UUIDUtils;
import com.atom.crm.settings.bean.User;
import com.atom.crm.workbench.bean.*;
import com.atom.crm.workbench.mapper.*;
import com.atom.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByCondition(Map<String, Object> map) {
        return clueMapper.selectClueByCondition(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int updateClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueInfoById(String id) {
        return clueMapper.selectClueByIdWithOtherTable(id);
    }

    @Override
    public void saveConvert(Map<String, Object> map) {
        //拿到clueId
        String clueId = (String) map.get("clueId");
        //查询线索信息
        Clue clue = clueMapper.selectClueById(clueId);
        //把该线索中有关公司的信息转换到客户表中
        //创建客户实体类对象，封装数据
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        //获取当前登录的用户信息
        User loginUser = (User) map.get(Contants.SESSION_USER);
        customer.setOwner(loginUser.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(loginUser.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //保存客户数据
        customerMapper.insertCustomer(customer);
        //把该线索中有关个人的信息转换到联系人表中
        //创建联系人实体类对象，封装数据
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(loginUser.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(loginUser.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        //保存联系人信息
        contactsMapper.insertContacts(contacts);
        //把该线索下所有备注信息转换到客户备注表中一份
        //把该线索下所有备注信息转换到联系人备注表中一份
        //查询线索备注信息
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);
        //创建客户备注集合，保存所有客户备注信息
        List<CustomerRemark> customerRemarks = new ArrayList<>();
        //创建联系人备注集合，保存所有联系人备注信息
        List<ContactsRemark> contactsRemarks = new ArrayList<>();
        for(ClueRemark clueRemark: clueRemarks){
            //创建客户备注实体类对象，封装数据
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtils.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(loginUser.getId());
            customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
            customerRemark.setCustomerId(customer.getId());
            customerRemarks.add(customerRemark);
            //创建联系人备注实体类对象，封装数据
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtils.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(loginUser.getId());
            contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
            contactsRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemarks.add(contactsRemark);
        }
        //保存客户备注信息
        customerRemarkMapper.insertCustomerRemark(customerRemarks);
        //保存联系人备注信息
        contactsRemarkMapper.insertContactsRemark(contactsRemarks);
        //把该线索和市场活动的关联关系转换联系人和市场活动的关联关系表中
        //查询线索和市场活动的关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        //创建联系人和市场活动的关联关系集合，保存所有关联关系数据
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
        for(ClueActivityRelation clueActivityRelation: clueActivityRelationList){
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtils.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelationList.add(contactsActivityRelation);
        }
        //保存联系人和市场活动的关联关系
        contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelationList);
        //如果需要创建交易，则往交易表中添加一条记录

    }
}
