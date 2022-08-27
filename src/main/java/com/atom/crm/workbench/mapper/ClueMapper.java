package com.atom.crm.workbench.mapper;

import com.atom.crm.workbench.bean.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {

    /**
     * 根据一个线索id删除线索
     * @param id
     * @return
     */
    int deleteClueById(String id);

    /**
     * 根据id删除线索
     * @param ids
     * @return
     */
    int deleteClueByIds(String[] ids);

    /**
     * 修改单条线索数据
     * @param clue
     * @return
     */
    int updateClue(Clue clue);

    /**
     * 根据线索的id查找线索
     * @param id
     * @return
     */
    Clue selectClueById(String id);

    /**
     * 根据线索的id查找线索
     * 进行了表连接，把一些为uuid的数据转成具体的值
     * @param id
     * @return
     */
    Clue selectClueByIdWithOtherTable(String id);

    /**
     * 根据条件查询线索条数
     * @param map
     * @return
     */
    int selectCountOfClueByCondition(Map<String, Object> map);

    /**
     * 根据条件查询线索
     * @return
     */
    List<Clue> selectClueByCondition(Map<String, Object> map);

    /**
     * 新建一条线索
     * @param clue
     * @return
     */
    int insertClue(Clue clue);
}