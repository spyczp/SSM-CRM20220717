package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {

    /**
     * 根据联系人id查询联系人备注列表
     * @param contactsId
     * @return
     */
    List<ContactsRemark> selectContactsRemarkListByContactsIdForDetail(String contactsId);

    /**
     * 根据数个联系人id删除数个联系人备注
     * @param contactsIds
     * @return
     */
    int deleteContactsRemarkByContactsIds(String[] contactsIds);

    /**
     * 新增联系人备注
     * @param contactsRemarks
     * @return
     */
    int insertContactsRemark(List<ContactsRemark> contactsRemarks);
}