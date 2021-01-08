package com.appcnd.common.cms.starter.service;

import com.alibaba.fastjson.JSONObject;
import com.appcnd.common.cms.starter.pojo.config.DbConfig;
import com.appcnd.common.cms.starter.pojo.vo.MetaConfigVo;
import com.appcnd.common.cms.starter.pojo.vo.TableVo;

import java.util.List;

/**
 * @author nihao 2021/01/07
 */
public interface IManagerService {
    TableVo getTable(String schema, String table);
    TableVo getTableByShow(String schema, String table);
    DbConfig getConfig(Integer configId);
    JSONObject getJsonConfig(Integer configId);
    void deleteConfig(Integer configId);
    void saveConfig(JSONObject param);
    List<MetaConfigVo> getAllConfig();
}
