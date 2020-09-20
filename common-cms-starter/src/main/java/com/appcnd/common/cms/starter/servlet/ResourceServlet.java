package com.appcnd.common.cms.starter.servlet;

import com.appcnd.common.cms.starter.util.Parser;
import com.alibaba.druid.util.Utils;
import org.springframework.http.HttpStatus;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * created by nihao 2020/07/07
 */
public class ResourceServlet extends HttpServlet {

    protected final String resourcePath;
    protected final String contextPath;

    public ResourceServlet(String resourcePath, String contextPath) {
        this.resourcePath = resourcePath;
        this.contextPath = contextPath;
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();
        String requestURI = request.getRequestURI();

        response.setCharacterEncoding("utf-8");

        if (contextPath == null) { // root context
            contextPath = "";
        }
        String uri = contextPath + servletPath;
        String path = requestURI.substring(contextPath.length() + servletPath.length());
        returnResourceFile(path, uri, request, response);
    }

    protected String getFilePath(String fileName) {
        return resourcePath + fileName;
    }

    protected void returnResourceFile(String fileName, String uri, HttpServletRequest request, HttpServletResponse response)
            throws ServletException,
            IOException {

        String filePath = getFilePath(fileName);

        if (filePath.endsWith(".html")) {
            response.setContentType("text/html; charset=utf-8");
        } else if (fileName.endsWith(".css")) {
            response.setContentType("text/css;charset=utf-8");
        } else if (fileName.endsWith(".js")) {
            response.setContentType("text/javascript;charset=utf-8");
        } else {
            byte[] bytes = Utils.readByteArrayFromResource(filePath);
            if (bytes == null) {
                response.sendError(HttpStatus.NOT_FOUND.value(), "资源不存在");
            } else {
                response.getOutputStream().write(bytes);
            }
            return;
        }
        String text = Utils.readFromResource(filePath);
        if (text == null) {
            if (filePath.endsWith(".html")) {
                request.setAttribute("code", 404);
                request.setAttribute("msg", "错误信息：不存在");
                request.getRequestDispatcher(contextPath + "/static/htmls/error.html").forward(request, response);
            } else {
                response.sendError(HttpStatus.NOT_FOUND.value(), "资源不存在");
            }
            return;
        }
        if (filePath.endsWith(".html")) {
            text = Parser.parse(text, "contextPath", request.getContextPath() + contextPath);
            text = Parser.parse(text, "code", request.getAttribute("code"));
            text = Parser.parse(text, "msg", request.getAttribute("code"));
        }
        response.getWriter().write(text);
    }
}
