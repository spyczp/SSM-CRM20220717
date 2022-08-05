package com.atom.crm.commons.contants;

public class Contants {
    //登录认证成功或失败时，返回给浏览器的code
    public static final String RETURN_OBJECT_CODE_SUCCESS = "1";
    public static final String RETURN_OBJECT_CODE_FAIL = "0";

    //保存在session作用域的用户信息对应的key
    public static final String SESSION_USER = "sessionUser";

    //备注的修改标记
    public static final String REMARK_EDIT_FLAG_NO_EDITED = "0"; //没有修改过
    public static final String REMARK_EDIT_FLAG_YES_EDITED = "1"; //已经修改过
}
