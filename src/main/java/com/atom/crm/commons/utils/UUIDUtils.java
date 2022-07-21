package com.atom.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {
    /**
     *
     * @return 获取32位UUID
     */
    public static String getUUID(){
        UUID uuid = UUID.randomUUID();
        String newUUID = uuid.toString().replaceAll("-", "");
        return newUUID;
    }
}
