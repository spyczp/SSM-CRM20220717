package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {

    /**
     * 新增联系人备注
     * @param contactsRemarks
     * @return
     */
    int insertContactsRemark(List<ContactsRemark> contactsRemarks);
}