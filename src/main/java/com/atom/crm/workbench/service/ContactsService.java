package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Contacts;

import java.util.List;

public interface ContactsService {

    List<Contacts> queryContactsByCustomerId(String customerId);

    List<Contacts> queryContactsListByName(String name);
}
