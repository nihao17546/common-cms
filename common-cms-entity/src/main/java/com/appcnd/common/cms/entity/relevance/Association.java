package com.appcnd.common.cms.entity.relevance;

import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.table.TableColumn;
import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * created by nihao 2020/1/19
 */
@Data
@NoArgsConstructor
public class Association implements Serializable {
    private String key;

    @JSONField(name = "bottom_name")
    private String bottomName;

    @JSONField(name = "relevance_schema")
    private String relevanceSchema;

    @JSONField(name = "relevance_table")
    private String relevanceTable;

    @JSONField(name = "relevance_current_key")
    private String relevanceCurrentKey;

    @JSONField(name = "relevance_target_key")
    private String relevanceTargetKey;

    private Boolean pagination;

    private String defaultSortColumn;

    private String defaultOrder;

    private Select select;

    private List<TableColumn> columns;
}
