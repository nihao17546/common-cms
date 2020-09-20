package com.appcnd.common.cms.starter.service;


import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import com.appcnd.common.cms.starter.pojo.HttpStatus;

/**
 * @author nihao 2019/10/19
 */
public class BaseService {
    protected void error(HttpStatus.Status status) {
        throw new CmsRuntimeException(status);
    }
    protected void error(HttpStatus.Status status, String msg) {
        throw new CmsRuntimeException(status.getCode(), msg);
    }
}
