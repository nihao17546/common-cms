package com.appcnd.common.cms.starter.pojo;

import lombok.Data;

/**
 * @author nihao 2019/07/02
 */
public class HttpStatus {

    public static final Status OK = new Status(0, "ok");
    public static final Status SYSTEM_ERROR = new Status(1, "系统异常");
    public static final Status NEED_LOGIN = new Status(403, "未登录");
    public static final Status NOT_FOUND = new Status(404, "未找到");
    public static final Status SYSTEM_EXCEPTION = new Status(500, "系统异常");

    @Data
    public static class Status {
        private int code;
        private String name;

        public Status(int code, String name) {
            this.code = code;
            this.name = name;
        }
    }
}
