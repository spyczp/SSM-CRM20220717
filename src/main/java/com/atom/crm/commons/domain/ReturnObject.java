package com.atom.crm.commons.domain;

/**
 * code:获取数据成功则为1，失败则为0.
 * message:获取失败时，返回的信息。
 * retData:附加信息
 */
public class ReturnObject {
    private String code;
    private String message;
    private Object retData;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
