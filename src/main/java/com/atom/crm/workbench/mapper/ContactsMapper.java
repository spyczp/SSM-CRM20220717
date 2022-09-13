package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {

    /**
     * 根据条件查询匹配的联系人的数量，用于分页功能：总条数
     * @return
     */
    int selectContactsCountByCondition(Map<String, Object> map);

    /**
     * 根据条件，查询联系人 列表
     * @return
     */
    List<Contacts> selectContactsListByCondition(Map<String, Object> map);

    /**
     * 根据联系人的id删除联系人信息
     * @param id
     * @return
     */
    int deleteContactsById(String id);

    /**
     * 根据名称模糊查询联系人列表
     * @param name
     * @return
     */
    List<Contacts> selectContactsListByName(String name);

    /**
     * 根据客户id查询联系人列表信息
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsByCustomerId(String customerId);

    /**
     * 新增联系人信息
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);
}