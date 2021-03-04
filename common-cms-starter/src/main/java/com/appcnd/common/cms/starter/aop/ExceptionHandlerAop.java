package com.appcnd.common.cms.starter.aop;

import com.appcnd.common.cms.entity.util.DesUtil;
import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import com.appcnd.common.cms.starter.pojo.HttpResult;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.properties.ManagerProperties;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.util.CommonUtils;
import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * controller异常捕获
 * created by nihao 2020/07/08
 */
@Aspect
@Slf4j
public class ExceptionHandlerAop {

    @Autowired
    private ServletProperties servletProperties;
    @Autowired
    private ManagerProperties managerProperties;

    @Pointcut("execution(public * com.appcnd.common.cms.starter.controller.*.*(..))")
    public void pointcut() {
    }

    @Around("pointcut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
        HttpServletResponse response = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getResponse();
        // 管理相关判断登录
        String servletPath = request.getServletPath();
        if (servletPath.startsWith(servletProperties.getUrl() + "/manager")) {
            if (managerProperties.getLoginname() == null || managerProperties.getPassword() == null
                    || managerProperties.getLoginname().isEmpty() || managerProperties.getPassword().isEmpty()) {
                if (servletPath.endsWith(".html")) {
                    CommonUtils.buildErrorTip(request, 404, "not found");
                    request.getRequestDispatcher(servletProperties.getUrl() + "/static/htmls/error.html").forward(request, response);
                    return null;
                } else {
                    return HttpResult.build(HttpStatus.NOT_FOUND);
                }
            }
            if (!servletPath.equals(servletProperties.getUrl() + "/manager/index.html")
                    && !servletPath.equals(servletProperties.getUrl() + "/manager/login")) {
                // 是否拦截
                boolean forbidden = false;
                String str = CommonUtils.getCookieValue("commoncmsmanager");
                if (str != null) {
                    String token = null;
                    try {
                        token = DesUtil.decrypt(str);
                        String[] ss = token.split("#");
                        Long time = Long.parseLong(ss[0]);
                        if (time - System.currentTimeMillis() > 1000L * 60 * 24) {
                            forbidden = true;
                        }
                    } catch (Exception e) {
                        forbidden = true;
                    }
                } else {
                    forbidden = true;
                }
                if (forbidden) {
                    if (servletPath.endsWith(".html")) {
                        response.setStatus(302);
                        response.setHeader("location", servletProperties.getUrl() + "/manager/index.html");
                        return null;
                    } else {
                        return HttpResult.build(HttpStatus.NEED_LOGIN);
                    }
                }
            }
        }
        try {
            Object proceed = point.proceed();
            return proceed;
        } catch (Throwable e) {
            if (CommonUtils.isAjax(request)) {
                if (e instanceof CmsRuntimeException) {
                    CmsRuntimeException cmsRuntimeException = (CmsRuntimeException) e;
                    CommonUtils.responseOutWithJson(response, HttpResult.build(cmsRuntimeException.getStatus()));
                } else if (e instanceof HttpRequestMethodNotSupportedException) {
                    HttpRequestMethodNotSupportedException me = (HttpRequestMethodNotSupportedException) e;
                    CommonUtils.responseOutWithJson(response, HttpResult.fail("不支持" + me.getMethod()));
                } else if (e instanceof MissingServletRequestParameterException) {
                    MissingServletRequestParameterException me = (MissingServletRequestParameterException) e;
                    CommonUtils.responseOutWithJson(response, HttpResult.fail("参数缺失[" + me.getParameterName() + "]"));
                } else if (e instanceof HttpMessageNotReadableException) {
                    CommonUtils.responseOutWithJson(response, HttpResult.fail("request body is missing"));
                } else {
                    log.error("RequestURL:{}", request.getRequestURL(), e);
                    CommonUtils.responseOutWithJson(response, HttpResult.build(HttpStatus.SYSTEM_ERROR));
                }
            } else {
                if (e instanceof MissingServletRequestParameterException) {
                    MissingServletRequestParameterException me = (MissingServletRequestParameterException) e;
                    CommonUtils.buildErrorTip(request, "参数缺失[" + me.getParameterName() + "]");
                } else {
                    log.error("RequestURL:{}", request.getRequestURL(), e);
                    CommonUtils.buildErrorTip(request, e.getMessage());
                }
                request.getRequestDispatcher(servletProperties.getUrl() + "/static/htmls/error.html").forward(request, response);
            }
            return null;
        }
    }

}
