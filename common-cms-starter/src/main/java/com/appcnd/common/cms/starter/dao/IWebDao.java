package com.appcnd.common.cms.starter.dao;

import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.CascadingDeleteParam;

import java.util.List;
import java.util.Map;

/**
 * @author nihao 2019/10/20
 */
public interface IWebDao {
    Long selectOneToOneCount(ListParam param);

    List<Map<String,Object>> selectOneToOneList(ListParam param, Integer curPage, Integer pageSize);

    List<Map<String,Object>> selectKeyValue(String schema, String table, String key, String value);
    int insert(String schema, String table, String pramaryKey, Map<String, Object> params);

    Map<String,Object> selectByPrimaryKey(String schema, String table, String primaryKey, Object primaryKeyValue, List<String> columns);

    int update(String schema, String table, String primaryKey, Object primaryKeyValue, Map<String, Object> param);

    int delete(String schema, String table, String primaryKey, List<Object> primaryKeyValues, List<CascadingDeleteParam> cascadingDeleteParams);

    List<Map<String,Object>> selectUnique(String schema, String table, String primaryKey, Map<String, Object> uniqueParams);
}
