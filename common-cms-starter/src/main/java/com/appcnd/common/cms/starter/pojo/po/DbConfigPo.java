package com.appcnd.common.cms.starter.pojo.po;

import lombok.Data;

import java.util.Date;

/**
 * created by nihao 2019/12/26
 */
@Data
public class DbConfigPo {
    private Integer id;
    private String name;
    private String host;
    private Integer port;
    private String username;
    private String password;
    private Date create_time;
    private Date update_time;
}
