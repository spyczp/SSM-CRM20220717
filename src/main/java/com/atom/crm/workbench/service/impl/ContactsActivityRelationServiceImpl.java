package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.ContactsActivityRelation;
import com.atom.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.atom.crm.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;


    @Override
    public int createContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList) {
        return contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelationList);
    }

    @Override
    public int deleteContactsActivityRelationByActivityIdAndContactsId(ContactsActivityRelation contactsActivityRelation) {
        return contactsActivityRelationMapper.deleteContactsActivityRelationByActivityIdAndContactsId(contactsActivityRelation);
    }
}
