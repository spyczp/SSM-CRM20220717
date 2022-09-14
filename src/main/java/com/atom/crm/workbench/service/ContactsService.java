package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsByCustomerId(String customerId);

    List<Contacts> queryContactsListByName(String name);

    void saveCreateContacts(Map<String, Object> map);

    int deleteContactsById(String id);

    List<Contacts> queryContactsListByCondition(Map<String, Object> map);

    int queryContactsCountByCondition(Map<String, Object> map);

    Contacts queryContactsById(String id);

    void saveEditContacts(Map<String, Object> map);
}
