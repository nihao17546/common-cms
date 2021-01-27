package com.appcnd.common.cms.starter.pojo.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * created by nihao 2021/01/27
 */
@Data
public class UeditorVideo implements Serializable {
    private String state;
    private String url;
    private String type;
    private String original;
}
