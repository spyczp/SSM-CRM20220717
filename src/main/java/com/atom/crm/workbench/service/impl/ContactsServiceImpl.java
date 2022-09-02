package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.Contacts;
import com.atom.crm.workbench.mapper.ContactsMapper;
import com.atom.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsByCustomerId(String customerId) {
        return contactsMapper.selectContactsByCustomerId(customerId);
    }

    @Override
    public List<Contacts> queryContactsListByName(String name) {
        return contactsMapper.selectContactsListByName(name);
    }
}
