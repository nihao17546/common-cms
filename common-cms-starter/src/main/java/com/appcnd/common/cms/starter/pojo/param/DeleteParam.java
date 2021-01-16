package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

import java.util.List;

/**
 * @author nihao 2019/10/22
 */
@Data
public class DeleteParam {
    private String addJson;
    private List<Object> primaryKeyValues;
    private List<CascadingDeleteParam> cascadingDeletes;
}
