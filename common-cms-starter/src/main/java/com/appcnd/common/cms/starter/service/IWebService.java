package com.appcnd.common.cms.starter.service;

import com.appcnd.common.cms.entity.form.add.UniqueColumn;
import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.CascadingDeleteParam;
import com.appcnd.common.cms.starter.pojo.param.SpecialColumnParam;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.pojo.vo.ListVO;

import java.util.List;
import java.util.Map;

/**
 * @author nihao 2019/10/20
 */
public interface IWebService {
    MetaConfigPo getMetaConfigByName(String name);

    ListVO<Map<String,Object>> getPagination(ListParam param, Integer curPage, Integer pageSize);

    List<Map<String,Object>> getList(ListParam param);

    Map<String,Object> add(String schema, String table, String primaryKey, Map<String, Object> params,
                           List<SpecialColumnParam> specialColumnParams, List<UniqueColumn> uniqueColumns);

    Map<String,Object> info(String schema, String table, String primaryKey, Object primaryKeyValue, List<String> columns);

    int update(String schema, String table, String primaryKey, Map<String, Object> params,
               List<SpecialColumnParam> specialColumnParams, List<UniqueColumn> uniqueColumns);

    void delete(String schema, String table, String primaryKey,
                List<Object> primaryKeyValues,
                List<CascadingDeleteParam> cascadingDeleteParams);
}
