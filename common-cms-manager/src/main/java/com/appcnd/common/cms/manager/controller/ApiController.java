package com.appcnd.common.cms.manager.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.appcnd.common.cms.entity.util.DesUtil;
import com.appcnd.common.cms.manager.dao.DbDao;
import com.appcnd.common.cms.manager.pojo.vo.*;
import com.appcnd.common.cms.manager.service.IDbService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author nihao 2019/10/19
 */
@RestController
@RequestMapping("/api")
public class ApiController {
    @Autowired
    private IDbService dbService;
    @Autowired
    private DbDao dbDao;

    @RequestMapping(value = "/login", produces = "application/json;charset=UTF-8")
    public String savePreview(@RequestParam String loginname, @RequestParam String password,
                              HttpServletResponse response) throws Exception {
        if (!loginname.equals("root") || !password.equals("123456")) {
            return HttpResult.fail("账号或密码错误").json();
        }
        Cookie cookie = new Cookie("commoncmsmanager", DesUtil.encrypt(System.currentTimeMillis() + "#" + loginname));
        cookie.setPath("/");
        response.addCookie(cookie);
        return HttpResult.success().json();
    }

    @RequestMapping(value = "/getTable", produces = "application/json;charset=UTF-8")
    public String getTable(@RequestParam String schema, @RequestParam String table) {
        TableVo tableVo = dbService.getTableByShow(schema, table);
        if (!"AUTO_INCREMENT".equalsIgnoreCase(tableVo.getPrimaryKeyExtra())) {
            return HttpResult.fail("只支持配置自增主键").json();
        }
        return HttpResult.success().pull("table", tableVo).json();
    }

    @RequestMapping(value = "/getConfig", produces = "application/json;charset=UTF-8")
    public String getConfig(@RequestParam Integer id) {
        Map<String,Object> db = dbDao.selectConfigById(id);
        if (db != null || !db.isEmpty()) {
            String configJson = (String) db.get("config");
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
                        TableVo mainTable = dbService.getTableByShow(mainDbConfig.getSchema(), mainDbConfig.getTable());
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
                                TableVo leftTable = dbService.getTableByShow(leftDbConfig.getSchema(), leftDbConfig.getTable());
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
                            TableVo mainTable = dbService.getTableByShow(followDbConfig.getSchema(), followDbConfig.getTable());
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
                                    TableVo leftTable = dbService.getTableByShow(leftDbConfig.getSchema(), leftDbConfig.getTable());
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
                return HttpResult.success().pull("db", dbConfig).json();
            }
        }
        return HttpResult.fail("配置不存在").json();
    }

    @RequestMapping(value = "/getJson", produces = "application/json;charset=UTF-8")
    public String getJson(@RequestParam Integer id) {
        Map<String,Object> db = dbDao.selectConfigById(id);
        if (db != null || !db.isEmpty()) {
            String configJson = (String) db.get("config");
            return HttpResult.success().pull("json", JSON.parseObject(configJson)).json();
        }
        return HttpResult.fail("配置不存在").json();
    }

    @RequestMapping(value = "/save", produces = "application/json;charset=UTF-8")
    public String save(@RequestBody JSONObject param) {
        fillTableColumn(param.getJSONObject("table"));
        if (param.containsKey("follow_tables")) {
            JSONArray followTables = param.getJSONArray("follow_tables");
            for (int i = 0; i < followTables.size(); i ++) {
                JSONObject followTable = followTables.getJSONObject(i);
                fillTableColumn(followTable);
            }
        }
        System.out.println(param.toJSONString());
        return null;
    }

    @RequestMapping(value = "/getConfigs", produces = "application/json;charset=UTF-8")
    public String getConfigs() {
        return HttpResult.success().pull("list", dbDao.selectConfig()).json();
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

    private String getCookieValue(String key, HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(key)) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}
