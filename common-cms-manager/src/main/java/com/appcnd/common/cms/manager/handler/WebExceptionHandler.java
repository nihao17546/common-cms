package com.appcnd.common.cms.manager.handler;
import com.appcnd.common.cms.manager.exception.CmsRuntimeException;
import com.appcnd.common.cms.manager.pojo.vo.HttpResult;
import com.appcnd.common.cms.manager.pojo.vo.HttpStatus;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author nihao 2018/11/23
 */
@RestControllerAdvice
@Slf4j
public class WebExceptionHandler {

    @ExceptionHandler(value = Exception.class)
    public void errorHandler(HttpServletRequest request, HttpServletResponse response, Exception e) {
        if (e instanceof CmsRuntimeException) {
            CmsRuntimeException cmsRuntimeException = (CmsRuntimeException) e;
            responseOutWithJson(response, HttpResult.build(cmsRuntimeException.getStatus()));
        } else if (e instanceof HttpRequestMethodNotSupportedException) {
            HttpRequestMethodNotSupportedException me = (HttpRequestMethodNotSupportedException) e;
            responseOutWithJson(response, HttpResult.fail("不支持" + me.getMethod()));
        } else if (e instanceof MissingServletRequestParameterException) {
            MissingServletRequestParameterException me = (MissingServletRequestParameterException) e;
            responseOutWithJson(response, HttpResult.fail("参数缺失[" + me.getParameterName() + "]"));
        } else if (e instanceof HttpMessageNotReadableException) {
            responseOutWithJson(response, HttpResult.fail("request body is missing"));
        } else {
            log.error("RequestURL:{}", request.getRequestURL(), e);
            responseOutWithJson(response, HttpResult.build(HttpStatus.SYSTEM_ERROR));
        }
    }

    private static void responseOutWithJson(HttpServletResponse response,
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
}
