package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

import java.io.Serializable;

/**
 * @author nihao 2021/01/16
 */
@Data
public class CascadingDeleteParam implements Serializable {
    private String schema;
    private String table;
    private String primaryKey;
    private String parentKey;
    private String relateKey;
}
