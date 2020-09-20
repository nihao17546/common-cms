package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

import java.util.List;

/**
 * created by nihao 2020/1/2
 */
@Data
public class UpdateSwitchParam {
    private String selectJson;
    private String column;
    private Object columnVal;
    private Object primaryKeyValue;
    private List<SpecialColumnParam> specialColumnParams;
}
