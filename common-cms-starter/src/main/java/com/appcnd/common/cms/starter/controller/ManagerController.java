package com.appcnd.common.cms.starter.controller;

import com.alibaba.fastjson.JSONObject;
import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.entity.util.DesUtil;
import com.appcnd.common.cms.starter.pojo.config.DbConfig;
import com.appcnd.common.cms.starter.pojo.vo.TableVo;
import com.appcnd.common.cms.starter.properties.ManagerProperties;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.service.IManagerService;
import com.appcnd.common.cms.starter.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * @author nihao 2021/01/07
 */
@RequestMapping("/manager")
public class ManagerController extends BaseController {

    @Autowired
    private IManagerService managerService;
    @Autowired
    private ManagerProperties managerProperties;
    @Autowired
    private ServletProperties servletProperties;

    @RequestMapping("/{page}.html")
    public void index(@PathVariable String page,
                      HttpServletResponse response,
                      HttpServletRequest request) throws IOException {
        response.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");
        Map<String,String> params = new HashMap<>();
        params.put("random", (new Random().nextInt(6) + 1) + "");
        params.put("basePackage", ConfigEntity.class.getName().replace("ConfigEntity", ""));
        String text = PageUtil.getPage(request, servletProperties.getUrl(), "manager/" + page, params);
        if (text == null) {
            params = new HashMap<>();
            params.put("code", "404");
            params.put("msg", "错误信息：不存在");
            text = PageUtil.getPage(request, servletProperties.getUrl(), "error");
        }
        response.getWriter().write(text);
    }

    @RequestMapping("/pages/{page}.html")
    public void config(HttpServletRequest request,
                         HttpServletResponse response,
                         @PathVariable String page) throws IOException {
        response.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");
        Map<String,String> params = new HashMap<>();
        params.put("basePackage", ConfigEntity.class.getName().replace("ConfigEntity", ""));
        String text = PageUtil.getPage(request, servletProperties.getUrl(), "manager/pages/" + page, params);
        if (text == null) {
            params = new HashMap<>();
            params.put("msg", "错误信息：不存在");
            params.put("code", "404");
            text = PageUtil.getPage(request, servletProperties.getUrl(), "error");
        }
        response.getWriter().write(text);
    }


    @RequestMapping(value = "/getTable", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getTable(@RequestParam String schema, @RequestParam String table) {
        TableVo tableVo = managerService.getTableByShow(schema, table);
        if (!"AUTO_INCREMENT".equalsIgnoreCase(tableVo.getPrimaryKeyExtra())) {
            return fail("只支持配置自增主键").json();
        }
        return ok().pull("table", tableVo).json();
    }

    @RequestMapping(value = "/getConfig", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getConfig(@RequestParam Integer id) {
        DbConfig dbConfig = managerService.getConfig(id);
        if (dbConfig == null) {
            return fail("配置不存在").json();
        }
        return ok().pull("db", dbConfig).json();
    }

    @RequestMapping(value = "/getJson", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getJson(@RequestParam Integer id) {
        JSONObject jsonObject = managerService.getJsonConfig(id);
        if (jsonObject == null) {
            return fail("配置不存在").json();
        }
        return ok().pull("json", jsonObject).json();
    }

    @RequestMapping(value = "/delete", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String delete(Integer id) {
        managerService.deleteConfig(id);
        return ok().json();
    }

    @RequestMapping(value = "/save", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String save(@RequestBody JSONObject param) {
        managerService.saveConfig(param);
        return ok().json();
    }

    @RequestMapping(value = "/getConfigs", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getConfigs() {
        return ok().pull("list", managerService.getAllConfig()).json();
    }

    @RequestMapping(value = "/login", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String savePreview(@RequestParam String loginname, @RequestParam String password,
                              HttpServletResponse response) throws Exception {
        if (!loginname.equals(managerProperties.getLoginname()) || !password.equals(managerProperties.getPassword())) {
            return fail("账号或密码错误").json();
        }
        Cookie cookie = new Cookie("commoncmsmanager", DesUtil.encrypt(System.currentTimeMillis() + "#" + loginname));
        cookie.setPath("/");
        response.addCookie(cookie);
        return ok().json();
    }

}
