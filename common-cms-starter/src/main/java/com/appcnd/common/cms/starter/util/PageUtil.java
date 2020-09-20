package com.appcnd.common.cms.starter.util;

import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.alibaba.druid.util.Utils;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * created by nihao 2020/07/08
 */
public class PageUtil {

    public static String getPage(HttpServletRequest request, String commonCmsUrl, String page) throws IOException {
        String filePath = BasicConstant.resourcePath
                + request.getRequestURI().substring(request.getContextPath().length() + request.getServletPath().length())
                + "/htmls/" + page + ".html";
        String text = Utils.readFromResource(filePath);
        text = Parser.parse(text, "contextPath", request.getContextPath() + commonCmsUrl);
        return text;
    }

}
