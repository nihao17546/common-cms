package com.appcnd.common.cms.manager.dao;

import com.appcnd.common.cms.manager.pojo.po.ColumnInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * @author nihao 2020/12/16
 */
@Mapper
public interface DbDao {
    Map<String,String> showTable(@Param("tableSchema") String tableSchema,
                                 @Param("tableName") String tableName);
    List<ColumnInfo> getTableInfo(@Param("tableSchema") String tableSchema,
                                  @Param("tableName") String tableName);
}
