package com.appcnd.common.cms.manager.pojo.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @author nihao 2021/01/06
 */
@Data
public class LeftDbConfig implements Serializable {
    private String schema;
    private String table;
    private String primaryKey;
    private boolean checked = true;
    private List<ColumnVo> columns;
    private String parentKey;
    private String relateKey;
}
