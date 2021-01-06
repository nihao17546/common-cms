package com.appcnd.common.cms.manager.controller;

import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.entity.util.DesUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * @author nihao 2020/12/16
 */
@Controller
public class PageController {

    @RequestMapping("/{page}.html")
    public String main(HttpServletRequest request, @PathVariable String page) {
        request.setAttribute("contextPath", request.getContextPath());
        request.setAttribute("random", new Random().nextInt(6) + 1);
        if ("index".equals(page)) {
            return page;
        }
        String str = getCookieValue("commoncmsmanager", request);
        if (str != null) {
            String token = null;
            try {
                token = DesUtil.decrypt(str);
                String[] ss = token.split("#");
                Long time = Long.parseLong(ss[0]);
                if (time - System.currentTimeMillis() > 1000L * 60 * 24) {
                    return "index";
                }
                return page;
            } catch (Exception e) {
                return "index";
            }
        }
        return "index";
    }

    @RequestMapping("/pages/{page}.html")
    public String config(HttpServletRequest request,
                         @PathVariable String page) {
        request.setAttribute("contextPath", request.getContextPath());
        request.setAttribute("basePackage",
                ConfigEntity.class.getName().replace("ConfigEntity", ""));
        return "pages/" + page;
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
