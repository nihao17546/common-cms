package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * @author nihao 2019/10/21
 */
@Data
public class UpdateParam {
    private String addJson;
    private Map<String,Object> params;
    private List<SpecialColumnParam> specialColumnParams;
}
