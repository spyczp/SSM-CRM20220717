package com.atom.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class HSSFUtils {
    /**
     * 获取excel表元素里的值，并转为String类型。
     * @param cell
     * @return
     */
    public static String getCellValueForStr(HSSFCell cell){
        String str = "";
        if(cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN){
            str = cell.getBooleanCellValue() + "";
        }else if(cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA){
            str = cell.getCellFormula() + "";
        }else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
            str = cell.getNumericCellValue() + "";
        }else if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
            str = cell.getStringCellValue() + "";
        }else{
            str = "";
        }
        return str;
    }
}
