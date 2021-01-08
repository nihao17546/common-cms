package com.appcnd.common.cms.starter.dao;

import com.appcnd.common.cms.starter.pojo.po.ColumnInfo;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;

import java.util.List;
import java.util.Map;


/**
 * @author nihao 2019/10/19
 */
public interface IMetaConfigDao {
    MetaConfigPo selectByName(String name);
    MetaConfigPo selectById(Integer id);
    int insert(MetaConfigPo metaConfigPo);
    int update(MetaConfigPo metaConfigPo);
    int delete(Integer id);
    List<MetaConfigPo> selectAll();

    Map<String,String> showTable(String tableSchema, String tableName);
    List<ColumnInfo> getTableInfo(String tableSchema, String tableName);
}
