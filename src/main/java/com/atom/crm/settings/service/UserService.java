package com.atom.crm.settings.service;

import com.atom.crm.settings.bean.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User queryUserByLoginActAndPwd(Map<String, Object> map);

    /**
     * 查询所有用户信息
     * @return
     */
    List<User> queryAllUser();
}
