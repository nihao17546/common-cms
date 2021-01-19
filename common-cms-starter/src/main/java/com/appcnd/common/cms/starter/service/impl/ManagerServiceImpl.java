package com.appcnd.common.cms.starter.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.appcnd.common.cms.entity.util.DesUtil;
import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.pojo.config.DbConfig;
import com.appcnd.common.cms.starter.pojo.config.FollowDbConfig;
import com.appcnd.common.cms.starter.pojo.config.LeftDbConfig;
import com.appcnd.common.cms.starter.pojo.config.MainDbConfig;
import com.appcnd.common.cms.starter.pojo.po.ColumnInfo;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.pojo.vo.ColumnVo;
import com.appcnd.common.cms.starter.pojo.vo.MetaConfigVo;
import com.appcnd.common.cms.starter.pojo.vo.TableVo;
import com.appcnd.common.cms.starter.service.BaseService;
import com.appcnd.common.cms.starter.service.IManagerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Timestamp;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * @author nihao 2021/01/07
 */
@Slf4j
public class ManagerServiceImpl extends BaseService implements IManagerService {
    @Autowired
    private IMetaConfigDao metaConfigDao;

    private Pattern patternColumn = Pattern.compile("`.+` [A-Za-z]+");
    private Pattern patternPri = Pattern.compile("PRIMARY KEY \\(`.+`\\)");

    @Override
    public TableVo getTable(String schema, String table) {
        List<ColumnInfo> list = metaConfigDao.getTableInfo(schema, table);
        if (list == null || list.isEmpty()) {
            error(HttpStatus.SYSTEM_ERROR, "表" + schema + "." + table + "不存在");
        }
        TableVo tableVo = new TableVo();
        List<ColumnVo> columnVoList = new ArrayList<>(list.size() - 1);
        for (ColumnInfo columnInfo : list) {
            if ("PRI".equalsIgnoreCase(columnInfo.getCOLUMN_KEY())) {
                if ("auto_increment".equalsIgnoreCase(columnInfo.getEXTRA())) {
                    tableVo.setPrimaryKeyExtra("auto_increment");
                }
            }
            ColumnVo columnVo = new ColumnVo();
            columnVo.setName(columnInfo.getCOLUMN_NAME());
            columnVo.setType(columnInfo.getDATA_TYPE());
            columnVoList.add(columnVo);
        }
        tableVo.setColumns(columnVoList);
        return tableVo;
    }

    @Override
    public TableVo getTableByShow(String schema, String table) {
        String sql = null;
        try {
            Map<String,String> map = metaConfigDao.showTable(schema, table);
            sql = map.get("Create Table");
        } catch (Exception e) {
            error(HttpStatus.SYSTEM_ERROR, "表" + schema + "." + table + "不存在");
        }
        TableVo tableVo = new TableVo();
        List<ColumnVo> columnVoList = new ArrayList<>();
        Matcher matcherPri = patternPri.matcher(sql);
        if (matcherPri.find()) {
            String a = sql.substring(matcherPri.start(), matcherPri.end());
            String name = a.substring(a.indexOf("`") + 1, a.lastIndexOf("`"));
            tableVo.setPrimaryKey(name);
        }
        Matcher matcherColumn = patternColumn.matcher(sql);
        while (matcherColumn.find()) {
            String a = sql.substring(matcherColumn.start(), matcherColumn.end());
            String name = a.substring(1, a.indexOf("` "));
            if (name.equalsIgnoreCase(tableVo.getPrimaryKey())) {
                Pattern patternPriExtra = Pattern.compile("`" + tableVo.getPrimaryKey() + "`.*,");
                Matcher matcherPriExtra = patternPriExtra.matcher(sql);
                if (matcherPriExtra.find()) {
                    String aa = sql.substring(matcherPriExtra.start(), matcherPriExtra.end() - 1);
                    if (aa.contains("AUTO_INCREMENT")
                            || aa.contains("AUTO_INCREMENT".toLowerCase())) {
                        tableVo.setPrimaryKeyExtra("AUTO_INCREMENT");
                    }
                }
            }
            String type = a.substring(a.indexOf("` ") + 2);
            ColumnVo columnVo = new ColumnVo();
            columnVo.setName(name);
            columnVo.setType(type);
            columnVoList.add(columnVo);
        }
        tableVo.setColumns(columnVoList);
        return tableVo;
    }

    @Override
    public DbConfig getConfig(Integer configId) {
        MetaConfigPo db = metaConfigDao.selectById(configId);
        if (db != null) {
            String configJson = db.getConfig();
            if (configJson != null && !configJson.isEmpty()) {
                JSONObject jsonObject = JSON.parseObject(configJson);
                DbConfig dbConfig = new DbConfig();
                MainDbConfig mainDbConfig = new MainDbConfig();
                dbConfig.setMain(mainDbConfig);
                if (jsonObject.containsKey("table")) {
                    JSONObject table = jsonObject.getJSONObject("table");
                    if (table.containsKey("select")) {
                        JSONObject select = table.getJSONObject("select");
                        mainDbConfig.setSchema(select.getString("schema"));
                        mainDbConfig.setTable(select.getString("table"));
                        TableVo mainTable = getTableByShow(mainDbConfig.getSchema(), mainDbConfig.getTable());
                        mainDbConfig.setPrimaryKey(mainTable.getPrimaryKey());
                        mainDbConfig.setColumns(mainTable.getColumns());
                        if (select.containsKey("leftJoins")) {
                            JSONArray leftJoins = select.getJSONArray("leftJoins");
                            for (int i = 0; i < leftJoins.size(); i ++) {
                                JSONObject leftJoin = leftJoins.getJSONObject(i);
                                LeftDbConfig leftDbConfig = new LeftDbConfig();
                                leftDbConfig.setSchema(leftJoin.getString("schema"));
                                leftDbConfig.setTable(leftJoin.getString("table"));
                                leftDbConfig.setRelateKey(leftJoin.getString("relateKey"));
                                leftDbConfig.setParentKey(leftJoin.getString("parentKey"));
                                TableVo leftTable = getTableByShow(leftDbConfig.getSchema(), leftDbConfig.getTable());
                                leftDbConfig.setPrimaryKey(leftTable.getPrimaryKey());
                                leftDbConfig.setColumns(leftTable.getColumns());
                                if (mainDbConfig.getFollows() == null) {
                                    mainDbConfig.setFollows(new ArrayList<>());
                                }
                                mainDbConfig.getFollows().add(leftDbConfig);
                            }
                        }
                    }
                }
                if (jsonObject.containsKey("follow_tables")) {
                    JSONArray followTables = jsonObject.getJSONArray("follow_tables");
                    List<FollowDbConfig> followDbConfigList = new ArrayList<>();
                    dbConfig.setFollows(followDbConfigList);
                    for (int i = 0; i < followTables.size(); i ++) {
                        FollowDbConfig followDbConfig = new FollowDbConfig();
                        JSONObject followTable = followTables.getJSONObject(i);
                        if (followTable.containsKey("select")) {
                            JSONObject select = followTable.getJSONObject("select");
                            followDbConfig.setSchema(select.getString("schema"));
                            followDbConfig.setTable(select.getString("table"));
                            TableVo mainTable = getTableByShow(followDbConfig.getSchema(), followDbConfig.getTable());
                            followDbConfig.setPrimaryKey(mainTable.getPrimaryKey());
                            followDbConfig.setColumns(mainTable.getColumns());
                            followDbConfig.setParentKey(followTable.getString("parentKey"));
                            followDbConfig.setRelateKey(followTable.getString("relateKey"));
                            if (select.containsKey("leftJoins")) {
                                JSONArray leftJoins = select.getJSONArray("leftJoins");
                                for (int j = 0; j < leftJoins.size(); j ++) {
                                    JSONObject leftJoin = leftJoins.getJSONObject(j);
                                    LeftDbConfig leftDbConfig = new LeftDbConfig();
                                    leftDbConfig.setSchema(leftJoin.getString("schema"));
                                    leftDbConfig.setTable(leftJoin.getString("table"));
                                    leftDbConfig.setRelateKey(leftJoin.getString("relateKey"));
                                    leftDbConfig.setParentKey(leftJoin.getString("parentKey"));
                                    TableVo leftTable = getTableByShow(leftDbConfig.getSchema(), leftDbConfig.getTable());
                                    leftDbConfig.setPrimaryKey(leftTable.getPrimaryKey());
                                    leftDbConfig.setColumns(leftTable.getColumns());
                                    if (followDbConfig.getFollows() == null) {
                                        followDbConfig.setFollows(new ArrayList<>());
                                    }
                                    followDbConfig.getFollows().add(leftDbConfig);
                                }
                            }
                        }
                        followDbConfigList.add(followDbConfig);
                    }
                }
                return dbConfig;
            }
        }
        return null;
    }

    @Override
    public JSONObject getJsonConfig(Integer configId) {
        MetaConfigPo db = metaConfigDao.selectById(configId);
        if (db != null) {
            return JSON.parseObject(db.getConfig());
        }
        return null;
    }

    @Override
    public void deleteConfig(Integer configId) {
        metaConfigDao.delete(configId);
    }

    @Override
    public void saveConfig(JSONObject param) {
        fillTableColumn(param.getJSONObject("table"));
        if (param.containsKey("follow_tables")) {
            JSONArray followTables = param.getJSONArray("follow_tables");
            for (int i = 0; i < followTables.size(); i ++) {
                JSONObject followTable = followTables.getJSONObject(i);
                fillTableColumn(followTable);
            }
        }
        if (param.containsKey("id")) {
            Long id = param.getLong("id");
            param.remove("id");
            MetaConfigPo metaConfigPo = new MetaConfigPo();
            metaConfigPo.setId(id);
            metaConfigPo.setConfig(JSON.toJSONString(param, SerializerFeature.DisableCircularReferenceDetect));
            metaConfigPo.setUpdated_at(new Timestamp(System.currentTimeMillis()));
            metaConfigDao.update(metaConfigPo);
        } else {
            String name = param.getString("name");
            if (name == null) {
                error(HttpStatus.SYSTEM_ERROR, "配置名称不能为空");
            }
            if (metaConfigDao.selectByName(name) != null) {
                error(HttpStatus.SYSTEM_ERROR, "该配置名称已存在");
            }
            param.remove("name");
            MetaConfigPo metaConfigPo = new MetaConfigPo();
            metaConfigPo.setName(name);
            metaConfigPo.setConfig(JSON.toJSONString(param, SerializerFeature.DisableCircularReferenceDetect));
            metaConfigPo.setCreated_at(new Timestamp(System.currentTimeMillis()));
            metaConfigDao.insert(metaConfigPo);
        }
    }

    @Override
    public List<MetaConfigVo> getAllConfig() {
        List<MetaConfigPo> poList = metaConfigDao.selectAll();
        return poList.stream().map(po -> {
            MetaConfigVo vo = new MetaConfigVo();
            BeanUtils.copyProperties(po, vo);
            try {
                vo.setUrl(DesUtil.encrypt(po.getName()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            return vo;
        }).collect(Collectors.toList());
    }

    private void fillTableColumn(JSONObject jsonObject) {
        if (jsonObject != null && jsonObject.containsKey("columns") && jsonObject.containsKey("select")) {
            JSONArray columns = jsonObject.getJSONArray("columns");
            Map<String,List<JSONObject>> map = new HashMap<>();
            for (int i = 0;i < columns.size(); i ++) {
                JSONObject column = columns.getJSONObject(i);
                String prop = column.getString("prop");
                String alias = prop.split("_")[0];
                List<JSONObject> list = null;
                if (!map.containsKey(alias)) {
                    list = new ArrayList<>();
                    map.put(alias, list);
                } else {
                    list = map.get(alias);
                }
                list.add(column);
            }
            JSONObject select = jsonObject.getJSONObject("select");
            if (map.containsKey(select.getString("alias"))) {
                select.put("tableColumns", map.get(select.getString("alias")));
            } else {
                if (select.containsKey("leftJoins")) {
                    JSONArray leftJoins = select.getJSONArray("leftJoins");
                    for (int i = 0; i < leftJoins.size(); i ++) {
                        JSONObject leftJoin = leftJoins.getJSONObject(i);
                        if (map.containsKey(leftJoin.getString("alias"))) {
                            leftJoin.put("tableColumns", map.get(leftJoin.getString("alias")));
                            break;
                        }
                    }
                }
            }
        }
    }
}
