package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

import java.util.List;

/**
 * @author nihao 2019/10/22
 */
@Data
public class InfoParam {
    private String addJson;
    private List<String> columns;
    private Object primaryKeyValue;
}
