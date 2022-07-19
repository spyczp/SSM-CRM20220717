package com.atom.crm.settings.service;

import com.atom.crm.settings.bean.User;

import java.util.Map;

public interface UserService {
    User queryUserByLoginActAndPwd(Map<String, Object> map);
}
