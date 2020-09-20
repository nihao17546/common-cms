package com.appcnd.common.cms.starter.pojo.po;

import lombok.Data;

import java.sql.Timestamp;

/**
 * @author nihao 2019/10/17
 */
@Data
public class MetaConfigPo {
    private Long id;
    private String name;
    private String config;
    private Timestamp created_at;
    private Timestamp updated_at;
}
