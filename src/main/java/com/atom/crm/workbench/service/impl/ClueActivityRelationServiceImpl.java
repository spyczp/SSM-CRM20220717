package com.atom.crm.workbench.service.impl;

import com.atom.crm.workbench.bean.ClueActivityRelation;
import com.atom.crm.workbench.mapper.ClueActivityRelationMapper;
import com.atom.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int createClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertClueActivityRelation(clueActivityRelationList);
    }

    @Override
    public int unboundClueActivityRelationByClueIdAndActivityId(Map<String, Object> map) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdAndActivityId(map);
    }
}
