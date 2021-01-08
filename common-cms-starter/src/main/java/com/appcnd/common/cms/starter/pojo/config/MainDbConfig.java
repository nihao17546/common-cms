package com.appcnd.common.cms.starter.pojo.config;

import com.appcnd.common.cms.starter.pojo.vo.ColumnVo;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @author nihao 2021/01/06
 */
@Data
public class MainDbConfig implements Serializable {
    private String schema;
    private String table;
    private String primaryKey;
    private boolean checked = true;
    private List<ColumnVo> columns;
    private List<LeftDbConfig> follows;
}
