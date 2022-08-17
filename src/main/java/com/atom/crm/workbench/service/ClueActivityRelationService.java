package com.atom.crm.workbench.service;

import com.atom.crm.workbench.bean.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {

    int createClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList);

    int unboundClueActivityRelationByClueIdAndActivityId(Map<String, Object> map);
}
