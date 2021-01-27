package com.appcnd.common.cms.starter.pojo.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * created by nihao 2021/01/27
 */
@Data
public class UeditorImage implements Serializable {
    private String state;
    private String url;
    private String title;
    private String original;
}
