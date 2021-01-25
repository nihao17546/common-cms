package com.appcnd.common.cms.starter.pojo.db;

import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.starter.pojo.param.SearchParam;
import lombok.Data;

import java.util.List;

/**
 * @author nihao 2019/11/18
 */
@Data
public class ListParam extends Select {
    private List<SearchParam> params;
    private String sortColumn;
    private String order;
    private String orderAlias;
}
