package com.appcnd.common.cms.entity.table;

import com.appcnd.common.cms.entity.table.formatter.Formatter;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author nihao 2019/11/14
 */
@Data
@NoArgsConstructor
public class TableColumn {
    private Integer index;
    private String key;
    private String prop;
    private String label;
    private Integer width;
    private Formatter formatter;
    private Boolean sortable;

    @Builder
    public TableColumn(String prop, String label, Integer width, Formatter formatter, Boolean sortable, Integer index, String key) {
        sortable = sortable == null ? false : sortable;
        CommonAssert.hasText(label, "label  不能为空");
        CommonAssert.notNull(key, "key  不能为空");
        this.prop = prop == null ? key : prop;
        this.label = label;
        this.width = width;
        this.formatter = formatter;
        this.sortable = sortable;
        this.index = index == null ? 999 : index;
        this.key = key;
    }
}
