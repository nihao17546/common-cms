package com.appcnd.common.cms.starter.exception;


import com.appcnd.common.cms.starter.pojo.HttpStatus;

/**
 * @author nihao 2019/07/03
 */
public class CmsRuntimeException extends RuntimeException {
    private HttpStatus.Status status;

    public HttpStatus.Status getStatus() {
        return status;
    }

    public void setStatus(HttpStatus.Status status) {
        this.status = status;
    }

    public CmsRuntimeException(HttpStatus.Status status) {
        super(status.getName());
        this.status = status;
    }

    public CmsRuntimeException(int code, String msg) {
        super(msg);
        this.status = new HttpStatus.Status(code, msg);
    }
}
