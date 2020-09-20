package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.util.CommonAssert;
import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author nihao 2019/11/16
 */
@Data
@NoArgsConstructor
public class AddForm implements Serializable {
    private String schema;
    private String table;
    private String primaryKey;
    private List<AddElement> elements;
    @JSONField(name = "unique_columns")
    private List<UniqueColumn> uniqueColumns;
    private Integer width;

    public AddForm addElement(AddElement element) {
        if (this.elements == null) {
            this.elements = new ArrayList<>();
        }
        this.elements.add(element);
        return this;
    }

    AddForm(String schema, String table, String primaryKey, List<AddElement> elements, List<UniqueColumn> uniqueColumns, Integer width) {
        CommonAssert.hasText(schema, "schema 不能为空");
        CommonAssert.hasText(table, "table 不能为空");
        CommonAssert.hasText(primaryKey, "primaryKey 不能为空");
        CommonAssert.notEmpty(elements, "elements 不能为空");
        if (width != null && (width <=0 || width > 100)) {
            throw new IllegalArgumentException("表单宽度区间为0-100");
        }
        for (AddElement element : elements) {
            if (element instanceof AddSelectRemote) {
                AddSelectRemote addSelectRemote = (AddSelectRemote) element;
                if (addSelectRemote.getSchema() == null || addSelectRemote.getSchema().length() == 0) {
                    addSelectRemote.setSchema(schema);
                }
            }
        }
        this.schema = schema;
        this.table = table;
        this.primaryKey = primaryKey;
        this.elements = elements;
        this.uniqueColumns = uniqueColumns;
        this.width = width;
    }

    public static AddFormBuilder builder() {
        return new AddFormBuilder();
    }

    public static class AddFormBuilder {
        private String schema;
        private String table;
        private String primaryKey;
        private List<AddElement> elements;
        private List<UniqueColumn> uniqueColumns;
        private Integer width;

        public AddFormBuilder schema(String schema) {
            this.schema = schema;
            return this;
        }

        public AddFormBuilder table(String table) {
            this.table = table;
            return this;
        }

        public AddFormBuilder primaryKey(String primaryKey) {
            this.primaryKey = primaryKey;
            return this;
        }

        public AddFormBuilder elements(AddElement... elements) {
            if (this.elements == null) {
                this.elements = new ArrayList<>();
            }
            for (AddElement element : elements) {
                this.elements.add(element);
            }
            return this;
        }

        public AddFormBuilder uniqueColumns(UniqueColumn... uniqueColumns) {
            if (this.uniqueColumns == null) {
                this.uniqueColumns = new ArrayList<>();
            }
            for (UniqueColumn uniqueColumn : uniqueColumns) {
                this.uniqueColumns.add(uniqueColumn);
            }
            return this;
        }

        public AddFormBuilder width(Integer width) {
            this.width = width;
            return this;
        }

        public AddForm build() {
            return new AddForm(schema, table, primaryKey, elements, uniqueColumns, width);
        }
    }
}
