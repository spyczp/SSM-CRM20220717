package com.atom.test.exceltest;

import com.atom.crm.commons.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.*;

public class MyTest {

    @Test
    public void testLoadExcel() throws IOException {
        InputStream is = new FileInputStream("C:\\Users\\Administrator\\Desktop\\studentList.xls");
        HSSFWorkbook wb = new HSSFWorkbook(is);
        HSSFSheet sheet = wb.getSheetAt(0);
        for(int i = 0; i <= sheet.getLastRowNum(); i++){
            HSSFRow row = sheet.getRow(i);
            for(int j = 0; j < row.getLastCellNum(); j++){
                HSSFCell cell = row.getCell(j);
                System.out.print(HSSFUtils.getCellValueForStr(cell) + " ");
            }
            System.out.println();
        }
    }


    @Test
    public void testExcel() throws IOException {
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet();
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("学号");
        HSSFCell cell1 = row.createCell(1);
        cell1.setCellValue("姓名");
        HSSFCell cell2 = row.createCell(2);
        cell2.setCellValue("年龄");

        HSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER);

        for(int i = 1; i <= 10; i++){
            HSSFRow row1 = sheet.createRow(i);
            HSSFCell cell3 = row1.createCell(0);
            cell3.setCellValue("100" + i);
            HSSFCell cell4 = row1.createCell(1);
            cell4.setCellValue("name" + i);
            HSSFCell cell5 = row1.createCell(2);
            cell5.setCellValue(20 + i);
            cell5.setCellStyle(cellStyle);
        }

        FileOutputStream os = new FileOutputStream("C:\\Users\\Administrator\\Desktop\\studentList.xls");
        wb.write(os);

        os.close();
        wb.close();

        System.out.println("========create ok==========");
    }
}
