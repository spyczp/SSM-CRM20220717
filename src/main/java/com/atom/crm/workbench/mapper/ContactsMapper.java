package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Contacts;

import java.util.List;

public interface ContactsMapper {

    /**
     * 根据名称模糊查询联系人列表
     * @param name
     * @return
     */
    List<Contacts> selectContactsListByName(String name);

    /**
     * 根据客户id查询联系人列表信息
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsByCustomerId(String customerId);

    /**
     * 新增联系人信息
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);
}