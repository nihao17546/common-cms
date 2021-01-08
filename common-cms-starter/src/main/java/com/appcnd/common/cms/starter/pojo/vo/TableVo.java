package com.appcnd.common.cms.starter.pojo.vo;

import lombok.Data;

import java.util.List;

/**
 * @author nihao 2020/12/16
 */
@Data
public class TableVo {
    private String primaryKey;
    private String primaryKeyExtra;
    private List<ColumnVo> columns;
}
