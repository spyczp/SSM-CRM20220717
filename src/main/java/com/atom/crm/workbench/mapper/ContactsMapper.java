package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Contacts;

public interface ContactsMapper {

    /**
     * 新增联系人信息
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);
}