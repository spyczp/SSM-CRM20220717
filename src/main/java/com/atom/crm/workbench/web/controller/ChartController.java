package com.atom.crm.workbench.web.controller;

import com.atom.crm.workbench.bean.FunnelVO;
import com.atom.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ChartController {

    @Autowired
    private TranService tranService;

    @RequestMapping("/workbench/chart/transaction/showTranStageStatsChart.do")
    @ResponseBody
    public Object showTranStageStats(){
        //访问业务层，获取数据
        List<String> nameList = tranService.queryTranStageNameList();
        List<FunnelVO> dataList = tranService.queryStageNameAndCountList();

        //封装数据
        Map<String, Object> map = new HashMap<>();
        map.put("nameList", nameList);
        map.put("dataList", dataList);

        //返回数据到浏览器
        return map;
    }

    @RequestMapping("/workbench/chart/transaction/toTransactionChartIndex.do")
    public String toTransactionChartIndex(){
        return "workbench/chart/transaction/index";
    }
}
