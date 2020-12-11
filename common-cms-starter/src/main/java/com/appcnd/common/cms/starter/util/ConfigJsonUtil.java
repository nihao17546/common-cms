package com.appcnd.common.cms.starter.util;

import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.entity.bottom.ExternalLinksBottom;
import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.Where;
import com.appcnd.common.cms.entity.form.Option;
import com.appcnd.common.cms.entity.form.add.AddElement;
import com.appcnd.common.cms.entity.form.add.AddForm;
import com.appcnd.common.cms.entity.form.add.AddSelectRemote;
import com.appcnd.common.cms.entity.form.search.SearchElement;
import com.appcnd.common.cms.entity.form.search.SearchSelectRemote;
import com.appcnd.common.cms.entity.table.formatter.Formatter;
import com.appcnd.common.cms.starter.dao.IWebDao;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author nihao 2019/10/21
 */
@Slf4j
public class ConfigJsonUtil {

    @Autowired
    private IWebDao webDao;

    public ConfigEntity parse(String configJson) throws ClassNotFoundException {
        ConfigEntity entity = JSON.parseObject(configJson, ConfigEntity.class);
        JSONObject jsonObject = JSON.parseObject(configJson);
        if (jsonObject.containsKey("add_form")) {
            AddForm addForm = parseAddForm(jsonObject.getJSONObject("add_form").toJSONString());
            entity.setAddForm(addForm);
        }

        if (jsonObject.containsKey("table")) {
            JSONObject table = jsonObject.getJSONObject("table");
            if (table.containsKey("select")) {
                Select select = parseSelect(table.getJSONObject("select").toJSONString());
                entity.getTable().setSelect(select);
            }
            if (table.containsKey("columns")) {
                JSONArray columns = table.getJSONArray("columns");
                if (columns != null) {
                    for (int i = 0; i < columns.size(); i ++) {
                        JSONObject column = (JSONObject) columns.get(i);
                        JSONObject obj = column.getJSONObject("formatter");
                        if (obj != null) {
                            String className = obj.getString("className");
                            Class clazz = Class.forName(className);
                            Object formatter = JSON.parseObject(obj.toString(), clazz);
                            entity.getTable().getColumns().get(i).setFormatter((Formatter) formatter);
                        }
                    }
                }
            }
            if (table.containsKey("bottoms")) {
                JSONArray jsonArray = table.getJSONArray("bottoms");
                if (jsonArray.size() > 0) {
                    entity.getTable().setBottoms(new ArrayList<>());
                    for (int i = 0; i < jsonArray.size(); i ++) {
                        JSONObject obj = jsonArray.getJSONObject(i);
                        String className = obj.getString("className");
                        Class clazz = Class.forName(className);
                        Object bottomObj = JSON.parseObject(obj.toString(), clazz);
                        if (bottomObj instanceof ExternalLinksBottom) {
                            ExternalLinksBottom externalLinksBottom = (ExternalLinksBottom) bottomObj;
                            entity.getTable().getBottoms().add(externalLinksBottom);
                        }
                    }
                }
            }
        }

        if (jsonObject.containsKey("follow_tables")) {
            JSONArray follow_tables = jsonObject.getJSONArray("follow_tables");
            if (follow_tables != null) {
                for (int i = 0; i < follow_tables.size(); i ++) {
                    JSONObject table = (JSONObject) follow_tables.get(i);

                    if (table.containsKey("bottoms")) {
                        JSONArray jsonArray = table.getJSONArray("bottoms");
                        if (jsonArray.size() > 0) {
                            entity.getFollowTables().get(i).setBottoms(new ArrayList<>());
                            for (int j = 0; j < jsonArray.size(); j ++) {
                                JSONObject obj = jsonArray.getJSONObject(j);
                                String className = obj.getString("className");
                                Class clazz = Class.forName(className);
                                Object bottomObj = JSON.parseObject(obj.toString(), clazz);
                                if (bottomObj instanceof ExternalLinksBottom) {
                                    ExternalLinksBottom externalLinksBottom = (ExternalLinksBottom) bottomObj;
                                    entity.getFollowTables().get(i).getBottoms().add(externalLinksBottom);
                                }
                            }
                        }
                    }

                    if (table.containsKey("select")) {
                        Select select = parseSelect(table.getJSONObject("select").toJSONString());
                        entity.getFollowTables().get(i).setSelect(select);
                    }
                    if (table.containsKey("columns")) {
                        JSONArray columns = table.getJSONArray("columns");
                        if (columns != null) {
                            for (int j = 0; j < columns.size(); j ++) {
                                JSONObject column = (JSONObject) columns.get(j);
                                JSONObject obj = column.getJSONObject("formatter");
                                if (obj != null) {
                                    String className = obj.getString("className");
                                    Class clazz = Class.forName(className);
                                    Object formatter = JSON.parseObject(obj.toString(), clazz);
                                    entity.getFollowTables().get(i).getColumns().get(j).setFormatter((Formatter) formatter);
                                }
                            }
                        }
                    }
                    if (table.containsKey("add_form")) {
                        AddForm addForm = parseAddForm(table.getJSONObject("add_form").toJSONString());
                        entity.getFollowTables().get(i).setAddForm(addForm);
                    }
                }
            }
        }

        return entity;
    }

    public Select parseSelect(String json) throws ClassNotFoundException {
        Select result = JSON.parseObject(json, Select.class);
        JSONObject select = JSON.parseObject(json);
        if (select.containsKey("tableColumns")) {
            JSONArray tableColumns = select.getJSONArray("tableColumns");
            for (int i = 0; i < tableColumns.size(); i ++) {
                JSONObject column = (JSONObject) tableColumns.get(i);
                JSONObject obj = column.getJSONObject("formatter");
                if (obj != null) {
                    String className = obj.getString("className");
                    Class clazz = Class.forName(className);
                    Object formatter = JSON.parseObject(obj.toString(), clazz);
                    result.getTableColumns().get(i).setFormatter((Formatter) formatter);
                }
            }
        }
        if (select.containsKey("wheres")) {
            result.setWheres(null);
            JSONArray wheres = select.getJSONArray("wheres");
            for (int i = 0; i < wheres.size(); i ++) {
                JSONObject obj = (JSONObject) wheres.get(i);
                String className = obj.getString("className");
                Class clazz = Class.forName(className);
                Object where = JSON.parseObject(obj.toString(), clazz);
                result.addWhere((Where) where);
            }
        }
        if (select.containsKey("searchElements")) {
            JSONArray searchElements = select.getJSONArray("searchElements");
            result.setSearchElements(null);
            for (int i = 0; i < searchElements.size(); i ++) {
                JSONObject obj = (JSONObject) searchElements.get(i);
                String className = obj.getString("className");
                Class clazz = Class.forName(className);
                Object elementObj = JSON.parseObject(obj.toString(), clazz);
                if (elementObj instanceof SearchSelectRemote) {
                    SearchSelectRemote searchSelectRemote = (SearchSelectRemote) elementObj;
                    List<Map<String,Object>> list = webDao.selectKeyValue(searchSelectRemote.getSchema(), searchSelectRemote.getTable(),
                            searchSelectRemote.getKeyColumn(), searchSelectRemote.getValueColumn());
                    for (Map<String,Object> map : list) {
                        searchSelectRemote.addOption(
                                Option.builder().label(map.get(searchSelectRemote.getValueColumn()).toString())
                                        .value(map.get(searchSelectRemote.getKeyColumn()).toString())
                                        .build());
                    }
                }
                result.addSearch((SearchElement) elementObj);
            }
        }
        if (select.containsKey("leftJoins")) {
            JSONArray leftJoins = select.getJSONArray("leftJoins");
            for (int i = 0; i < leftJoins.size(); i ++) {
                JSONObject leftJoin = (JSONObject) leftJoins.get(i);
                if (leftJoin.containsKey("tableColumns")) {
                    JSONArray tableColumns = leftJoin.getJSONArray("tableColumns");
                    for (int j = 0; j < tableColumns.size(); j ++) {
                        JSONObject column = (JSONObject) tableColumns.get(j);
                        JSONObject obj = column.getJSONObject("formatter");
                        if (obj != null) {
                            String className = obj.getString("className");
                            Class clazz = Class.forName(className);
                            Object formatter = JSON.parseObject(obj.toString(), clazz);
                            result.getLeftJoins().get(i).getTableColumns().get(j).setFormatter((Formatter) formatter);
                        }
                    }
                }
                if (leftJoin.containsKey("wheres")) {
                    result.getLeftJoins().get(i).setWheres(null);
                    JSONArray wheres = leftJoin.getJSONArray("wheres");
                    for (int j = 0; j < wheres.size(); j ++) {
                        JSONObject obj = (JSONObject) wheres.get(j);
                        String className = obj.getString("className");
                        Class clazz = Class.forName(className);
                        Object where = JSON.parseObject(obj.toString(), clazz);
                        result.getLeftJoins().get(i).addWhere((Where) where);
                    }
                }
                if (leftJoin.containsKey("searchElements")) {
                    JSONArray searchElements = leftJoin.getJSONArray("searchElements");
                    result.getLeftJoins().get(i).setSearchElements(null);
                    for (int j = 0; j < searchElements.size(); j ++) {
                        JSONObject obj = (JSONObject) searchElements.get(i);
                        String className = obj.getString("className");
                        Class clazz = Class.forName(className);
                        Object elementObj = JSON.parseObject(obj.toString(), clazz);
                        if (elementObj instanceof SearchSelectRemote) {
                            SearchSelectRemote searchSelectRemote = (SearchSelectRemote) elementObj;
                            List<Map<String,Object>> list = webDao.selectKeyValue(searchSelectRemote.getSchema(), searchSelectRemote.getTable(),
                                    searchSelectRemote.getKeyColumn(), searchSelectRemote.getValueColumn());
                            for (Map<String,Object> map : list) {
                                searchSelectRemote.addOption(
                                        Option.builder().label(map.get(searchSelectRemote.getValueColumn()).toString())
                                                .value(map.get(searchSelectRemote.getKeyColumn()).toString())
                                                .build());
                            }
                        }
                        result.getLeftJoins().get(i).addSearch((SearchElement) elementObj);
                    }
                }
            }
        }
        return result;
    }

    public AddForm parseAddForm(String json) throws ClassNotFoundException {
        AddForm addForm = JSON.parseObject(json, AddForm.class);
        JSONObject jsonObject = JSON.parseObject(json);
        if (jsonObject.containsKey("elements")) {
            addForm.setElements(null);
            JSONArray elements = jsonObject.getJSONArray("elements");
            for (int i = 0; i < elements.size(); i ++) {
                JSONObject obj = (JSONObject) elements.get(i);
                String className = obj.getString("className");
                Class clazz = Class.forName(className);
                Object elementObj = JSON.parseObject(obj.toString(), clazz);
                if (elementObj instanceof AddSelectRemote) {
                    AddSelectRemote addSelectRemote = (AddSelectRemote) elementObj;
                    List<Map<String,Object>> list = webDao.selectKeyValue(addSelectRemote.getSchema(), addSelectRemote.getTable(),
                            addSelectRemote.getKeyColumn(), addSelectRemote.getValueColumn());
                    for (Map<String,Object> map : list) {
                        addSelectRemote.addOption(
                                Option.builder().label(map.get(addSelectRemote.getValueColumn()).toString())
                                        .value(map.get(addSelectRemote.getKeyColumn()).toString())
                                        .build());
                    }
                }
                addForm.addElement((AddElement) elementObj);
            }
        }
        return addForm;
    }

}
