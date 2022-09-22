package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {

    /**
     * 根据id查询联系人名称
     * @param id
     * @return
     */
    String selectContactsNameById(String id);

    /**
     * 根据数个id删除数个联系人信息
     * @param ids
     * @return
     */
    int deleteContactsByIds(String[] ids);

    /**
     * 修改联系人信息
     * @param map
     * @return
     */
    int updateAContacts(Map<String, Object> map);

    /**
     * 根据id查询联系人信息，连表转义所有uuid
     * @param id
     * @return
     */
    Contacts selectContactsByIdForDetail(String id);

    /**
     * 根据id查询联系人信息
     * @param id
     * @return
     */
    Contacts selectContactsById(String id);

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