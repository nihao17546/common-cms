package com.appcnd.common.cms.starter.service.impl;

import com.appcnd.common.cms.entity.constant.AddColumnType;
import com.appcnd.common.cms.entity.form.add.UniqueColumn;
import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.dao.IWebDao;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.SpecialColumnParam;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.pojo.vo.ListVO;
import com.appcnd.common.cms.starter.service.BaseService;
import com.appcnd.common.cms.starter.service.IWebService;
import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.dao.IWebDao;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.SpecialColumnParam;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.pojo.vo.ListVO;
import com.appcnd.common.cms.starter.service.BaseService;
import com.appcnd.common.cms.starter.service.IWebService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;

import java.util.*;

/**
 * @author nihao 2019/10/20
 */
@Slf4j
public class WebServiceImpl extends BaseService implements IWebService {

    @Autowired
    private IMetaConfigDao metaConfigDao;
    @Autowired
    private IWebDao webDao;

    @Override
    public MetaConfigPo getMetaConfigByName(String name) {
        MetaConfigPo metaConfigPo = metaConfigDao.selectByName(name);
        if (metaConfigPo == null) {
            error(HttpStatus.SYSTEM_ERROR, "配置[" + name + "]不存在");
        }
        return metaConfigPo;
    }

    @Override
    public ListVO<Map<String, Object>> getPagination(ListParam param, Integer curPage, Integer pageSize) {
        ListVO<Map<String, Object>> result = new ListVO<>(curPage, pageSize);
        Long count = webDao.selectOneToOneCount(param);
        if (count == 0) {
            return result;
        }
        result.setTotalCount(count);
        List<Map<String,Object>> list = webDao.selectOneToOneList(param, curPage, pageSize);
        result.setList(list);
        return result;
    }

    @Override
    public List<Map<String, Object>> getList(ListParam param) {
        List<Map<String,Object>> list = webDao.selectOneToOneList(param, null, null);
        return list;
    }

    @Override
    public Map<String, Object> add(String schema, String table, String primaryKey, Map<String, Object> params,
                                   List<SpecialColumnParam> specialColumnParams, List<UniqueColumn> uniqueColumns) {
        if (!CollectionUtils.isEmpty(uniqueColumns)) {
            for (UniqueColumn uniqueColumn : uniqueColumns) {
                b:
                if (!CollectionUtils.isEmpty(uniqueColumn.getColumns())) {
                    Map<String,Object> uniqueParams = new LinkedHashMap<>();
                    for (String key : uniqueColumn.getColumns()) {
                        if (params.containsKey(key)) {
                            uniqueParams.put(key,params.get(key));
                        } else {
                            break b;
                        }
                    }
                    List<Map<String,Object>> list = webDao.selectUnique(schema, table, primaryKey, uniqueParams);
                    if (!CollectionUtils.isEmpty(list)) {
                        error(HttpStatus.SYSTEM_EXCEPTION, uniqueColumn.getToast());
                    }
                }
            }
        }

        if (!CollectionUtils.isEmpty(specialColumnParams)) {
            for (SpecialColumnParam specialColumn : specialColumnParams) {
                if (AddColumnType.CREATE_DATETIME.name().equals(specialColumn.getColumnType())) {
                    params.put(specialColumn.getColumn(), new Date());
                } else if (AddColumnType.UPDATE_DATETIME.name().equals(specialColumn.getColumnType())) {
                    params.put(specialColumn.getColumn(), new Date());
                }
            }
        }
        webDao.insert(schema, table, primaryKey, params);
        params.put("primaryKey", primaryKey);
        return params;
    }

    @Override
    public Map<String,Object> info(String schema, String table, String primaryKey, Object primaryKeyValue, List<String> columns) {
        return webDao.selectByPrimaryKey(schema, table, primaryKey, primaryKeyValue, columns);
    }

    @Override
    public int update(String schema, String table, String primaryKey, Map<String, Object> params,
                      List<SpecialColumnParam> specialColumnParams, List<UniqueColumn> uniqueColumns) {
        Object primaryKeyValue = params.get(primaryKey);
        params.remove(primaryKey);

        if (!CollectionUtils.isEmpty(uniqueColumns)) {
            for (UniqueColumn uniqueColumn : uniqueColumns) {
                b:
                if (!CollectionUtils.isEmpty(uniqueColumn.getColumns())) {
                    Map<String,Object> uniqueParams = new LinkedHashMap<>();
                    for (String key : uniqueColumn.getColumns()) {
                        if (params.containsKey(key)) {
                            uniqueParams.put(key,params.get(key));
                        } else {
                            break b;
                        }
                    }
                    List<Map<String,Object>> list = webDao.selectUnique(schema, table, primaryKey, uniqueParams);
                    if (!CollectionUtils.isEmpty(list)) {
                        for (Map<String,Object> map : list) {
                            if (!String.valueOf(primaryKeyValue).equals(String.valueOf(map.get(primaryKey)))) {
                                error(HttpStatus.SYSTEM_EXCEPTION, uniqueColumn.getToast());
                            }
                        }
                    }
                }
            }
        }

        if (!CollectionUtils.isEmpty(specialColumnParams)) {
            for (SpecialColumnParam specialColumn : specialColumnParams) {
                if (AddColumnType.UPDATE_DATETIME.name().equals(specialColumn.getColumnType())) {
                    params.put(specialColumn.getColumn(), new Date());
                }
            }
        }
        return webDao.update(schema, table, primaryKey, primaryKeyValue, params);
    }

    @Override
    public void delete(String schema, String table, String primaryKey, List<Object> primaryKeyValues) {
        webDao.delete(schema, table, primaryKey, primaryKeyValues);
    }
}
