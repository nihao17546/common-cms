package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

/**
 * @author nihao 2019/10/20
 */
@Data
public class SearchParam {
    private String key;
    private Object value;
    private String type;
    private String alias;
}
