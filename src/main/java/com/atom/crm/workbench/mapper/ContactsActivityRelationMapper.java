package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {

    /**
     * 根据数个联系人id删除数个联系人市场活动关联关系
     * @param contactsIds
     * @return
     */
    int deleteContactsActivityRelationByContactsIds(String[] contactsIds);

    /**
     * 新增联系人和市场活动的关联关系
     * @param contactsActivityRelationList
     * @return
     */
    int insertContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList);
}