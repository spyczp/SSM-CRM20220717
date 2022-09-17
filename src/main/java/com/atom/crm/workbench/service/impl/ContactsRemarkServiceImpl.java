package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.ContactsRemark;
import com.atom.crm.workbench.mapper.ContactsRemarkMapper;
import com.atom.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public List<ContactsRemark> queryContactsRemarkListByContactsIdForDetail(String contactsId) {
        return contactsRemarkMapper.selectContactsRemarkListByContactsIdForDetail(contactsId);
    }
}
