package com.appcnd.common.cms.manager.dao;

import com.appcnd.common.cms.manager.pojo.po.ColumnInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
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
    List<Map<String,Object>> selectConfig();
    Map<String,Object> selectConfigById(@Param("id") Integer id);
    int insert(@Param("name") String name,
               @Param("config") String config,
               @Param("created_at") Date created_at,
               @Param("updated_at") Date updated_at);
    int update(@Param("id") Integer id,
               @Param("config") String config,
               @Param("updated_at") Date updated_at);
    Map<String,Object> selectConfigByName(@Param("name") String name);
    int delete(@Param("id") Integer id);
}
