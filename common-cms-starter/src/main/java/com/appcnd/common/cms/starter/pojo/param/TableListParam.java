package com.appcnd.common.cms.starter.pojo.param;

import lombok.Data;

import java.util.List;

/**
 * @author nihao 2019/10/20
 */
@Data
public class TableListParam {
    private String listJson;
    private Integer curPage;
    private Integer pageSize;
    private String sortColumn;
    private String orderAlias;
    private String order;
    private List<SearchParam> params;
}
