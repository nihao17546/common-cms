package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.ElType;
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
public class AddSelectRemote extends AddElement {
    private String schema;
    private String table;
    private String keyColumn;
    private String valueColumn;
    private List<Option> options;

    public AddSelectRemote addOption(Option option) {
        if (this.options == null) {
            this.options = new ArrayList<>();
        }
        this.options.add(option);
        return this;
    }

    @Builder
    public AddSelectRemote(String key, String label, String placeholder, Boolean clearable, String size, Integer width, FormRule rule, String schema, String table,
                           String keyColumn, String valueColumn, Boolean canEdit) {
        super(key, label, placeholder, clearable, size, width, ElType.SELECT, rule, null, canEdit);
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
