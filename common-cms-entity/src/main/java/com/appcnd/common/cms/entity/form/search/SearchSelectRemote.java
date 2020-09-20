package com.appcnd.common.cms.entity.form.search;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.constant.JudgeType;
import com.appcnd.common.cms.entity.form.Option;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

/**
 * @author nihao 2019/11/16
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class SearchSelectRemote extends SearchElement {
    private String schema;
    private String table;
    private String keyColumn;
    private String valueColumn;
    private List<Option> options;

    public SearchSelectRemote addOption(Option option) {
        if (this.options == null) {
            this.options = new ArrayList<>();
        }
        this.options.add(option);
        return this;
    }

    @Builder
    public SearchSelectRemote(String key, String label, String placeholder, Boolean clearable, String size, Integer width, Object defaultValue, String schema, String table, String keyColumn, String valueColumn) {
        super(key, label, placeholder, clearable, size, width, defaultValue, ElType.SELECT, JudgeType.eq);
        CommonAssert.hasText(schema, "schema 不能为空");
        CommonAssert.hasText(table, "table 不能为空");
        CommonAssert.hasText(keyColumn, "keyColumn 不能为空");
        CommonAssert.hasText(valueColumn, "valueColumn 不能为空");
        this.schema = schema;
        this.table = table;
        this.keyColumn = keyColumn;
        this.valueColumn = valueColumn;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
