package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {

    int createContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList);

    int deleteContactsActivityRelationByActivityIdAndContactsId(ContactsActivityRelation contactsActivityRelation);
}
