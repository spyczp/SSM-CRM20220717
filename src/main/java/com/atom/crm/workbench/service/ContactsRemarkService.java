package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    List<ContactsRemark> queryContactsRemarkListByContactsIdForDetail(String contactsId);

    int createAContactsRemark(ContactsRemark contactsRemark);

    int saveEditAContactsRemark(ContactsRemark contactsRemark);

    int deleteAContactsRemark(String id);
}
