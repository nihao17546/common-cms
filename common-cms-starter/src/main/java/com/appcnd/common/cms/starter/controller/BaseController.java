package com.appcnd.common.cms.starter.controller;

import com.appcnd.common.cms.starter.pojo.HttpResult;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.util.CommonUtils;
import com.appcnd.common.cms.starter.pojo.HttpResult;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.util.CommonUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

/**
 * @author nihao 2018/11/22
 */
public abstract class BaseController {
    protected HttpResult fail(String message){
        return HttpResult.fail(message);
    }
    protected HttpResult fail(String... messages){
        StringBuilder sb = new StringBuilder();
        for (String message : messages) {
            sb.append(message);
        }
        return HttpResult.fail(sb.toString());
    }
    protected HttpResult ok(String message){
        return HttpResult.success(message);
    }
    protected HttpResult fail(){
        return HttpResult.fail();
    }
    protected HttpResult ok(){
        return HttpResult.success();
    }
    protected HttpResult build(HttpStatus.Status status) {
        return HttpResult.build(status);
    }
    protected HttpResult build(HttpStatus.Status status, String msg) {
        HttpResult result = HttpResult.build(status);
        result.setMsg(msg);
        return result;
    }
    protected String forwardToError(HttpServletRequest request, String msg) {
        if (request == null) {
            request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        }
        CommonUtils.buildErrorTip(request, msg);
        return "error";
    }
    protected String forwardToError(String msg) {
        return forwardToError(null, msg);
    }
}
