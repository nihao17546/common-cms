package com.appcnd.common.cms.manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * @author nihao 2020/12/16
 */
@Controller
public class PageController {

    @RequestMapping("/index.html")
    public String index(HttpServletRequest request) {
        request.setAttribute("contextPath", request.getContextPath());
        return "index";
    }

}
