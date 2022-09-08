package com.atom.test;

import com.atom.crm.commons.utils.DateUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.UUID;

public class MyTest {

    @Test
    public void testJson() {
        InputStream is = null;
        Properties properties = new Properties();


        try {
            is = new FileInputStream("src/test/resources/possibility.properties");
            properties.load(is);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        ObjectMapper om = new ObjectMapper();
        String json = null;
        try {
            json = om.writeValueAsString(properties);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        System.out.println(json);
    }


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
