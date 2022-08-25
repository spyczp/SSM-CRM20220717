package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {

    /**
     * 新增联系人和市场活动的关联关系
     * @param contactsActivityRelationList
     * @return
     */
    int insertContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList);
}