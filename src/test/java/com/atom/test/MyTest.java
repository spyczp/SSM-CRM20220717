package com.atom.test;

import com.atom.crm.commons.utils.DateUtils;
import org.junit.Test;

import java.util.Date;
import java.util.UUID;

public class MyTest {
    @Test
    public void testUUID(){
        UUID uuid = UUID.randomUUID();
        System.out.println(uuid);
        String newUUID = uuid.toString().replaceAll("-", "");
        System.out.println(newUUID);
    }

    @Test
    public void testDate(){
        System.out.println(DateUtils.formatDateTime(new Date()));
    }
}
