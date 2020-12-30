package com.appcnd.common.cms.manager.controller;

import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.entity.db.Where;
import com.appcnd.common.cms.entity.form.add.AddElement;
import com.appcnd.common.cms.entity.form.search.SearchElement;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.UUID;

/**
 * @author nihao 2020/12/16
 */
@Controller
public class PageController {

    @RequestMapping("/index.html")
    public String index(HttpServletRequest request) {
        request.setAttribute("contextPath", request.getContextPath());
        request.setAttribute("uuid", UUID.randomUUID().toString());
        request.setAttribute("searchElementPackage",
                SearchElement.class.getName().replace("SearchElement", ""));
        request.setAttribute("wherePackage",
                Where.class.getName().replace("Where", ""));
        request.setAttribute("addElementPackage",
                AddElement.class.getName().replace("AddElement", ""));
        return "index";
    }

    @RequestMapping("/main.html")
    public String main(HttpServletRequest request) {
        request.setAttribute("contextPath", request.getContextPath());
        return "main";
    }

    @RequestMapping("/config.html")
    public String config(HttpServletRequest request) {
        request.setAttribute("contextPath", request.getContextPath());
        request.setAttribute("searchElementPackage",
                SearchElement.class.getName().replace("SearchElement", ""));
        request.setAttribute("wherePackage",
                Where.class.getName().replace("Where", ""));
        request.setAttribute("addElementPackage",
                AddElement.class.getName().replace("AddElement", ""));
        return "config";
    }

    @RequestMapping("/pages/{page}.html")
    public String config(HttpServletRequest request,
                         @PathVariable String page) {
        request.setAttribute("contextPath", request.getContextPath());
        request.setAttribute("basePackage",
                ConfigEntity.class.getName().replace("ConfigEntity", ""));
        return "pages/" + page;
    }

}
