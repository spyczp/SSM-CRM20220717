package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveCreateClue(Clue clue);

    List<Clue> queryClueByCondition(Map<String, Object> map);

    int queryCountOfClueByCondition(Map<String, Object> map);

    Clue queryClueById(String id);

    int updateClue(Clue clue);

    int deleteClueByIds(String[] ids);

    Clue queryClueInfoById(String id);

    void saveConvert(Map<String, Object> map);
}
