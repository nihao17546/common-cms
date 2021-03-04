package com.appcnd.common.cms.starter.util;

import com.appcnd.common.cms.starter.pojo.HttpResult;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author nihao 2019/10/19
 */
public class CommonUtils {

    public static String getCookieValue(String key) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
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

    public final static void responseOutWithJson(HttpServletResponse response,
                                           HttpResult result) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        PrintWriter out = null;
        try {
            out = response.getWriter();
            out.append(result.json());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    public static boolean isAjax(HttpServletRequest request) {
        String servletPath = request.getServletPath();
        if (servletPath.endsWith("/html") || servletPath.endsWith(".html")) {
            return false;
        }
        return true;
    }

    public static void buildErrorTip(HttpServletRequest request,
                                     Integer code, String msg) {
        if (code == null) {
            code = 500;
        }
        if (msg == null) {
            msg = "";
        }
        request.setAttribute("code", code);
        request.setAttribute("msg", msg);
    }

    public static void buildErrorTip(HttpServletRequest request) {
        buildErrorTip(request, null, null);
    }

    public static void buildErrorTip(HttpServletRequest request, int code) {
        buildErrorTip(request, code, null);
    }

    public static void buildErrorTip(HttpServletRequest request, String msg) {
        buildErrorTip(request, null, msg);
    }
}
