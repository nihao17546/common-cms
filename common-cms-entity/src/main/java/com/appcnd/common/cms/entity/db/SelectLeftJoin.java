package com.appcnd.common.cms.entity.db;

import com.appcnd.common.cms.entity.form.search.SearchElement;
import com.appcnd.common.cms.entity.table.TableColumn;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author nihao 2019/11/14
 */
@Data
@NoArgsConstructor
public class SelectLeftJoin implements Serializable {
    private String schema;
    private String table;
    private String alias;
    private List<String> columns;
    private List<TableColumn> tableColumns;
    private List<Where> wheres;
    /** 关联父表的column */
    private String relateKey;
    /** 当前表的外键column */
    private String parentKey;
    private List<SearchElement> searchElements;

    public SelectLeftJoin addWhere(Where where) {
        if (this.wheres == null) {
            this.wheres = new ArrayList<>();
        }
        this.wheres.add(where);
        return this;
    }

    public SelectLeftJoin addSearch(SearchElement searchElement) {
        if (this.searchElements == null) {
            this.searchElements = new ArrayList<>();
        }
        searchElement.setAlias(this.alias);
        this.searchElements.add(searchElement);
        return this;
    }

    SelectLeftJoin(String schema, String table, List<TableColumn> tableColumns, List<Where> wheres, String relateKey, String parentKey, List<SearchElement> searchElements) {
        CommonAssert.hasText(table, "table 不能为空");
        CommonAssert.hasText(relateKey, "relateKey 不能为空");
        CommonAssert.hasText(parentKey, "parentKey 不能为空");
        CommonAssert.notEmpty(tableColumns, "tableColumns 不能为空");
        this.schema = schema;
        this.table = table;
        this.tableColumns = tableColumns;
        this.wheres = wheres;
        this.relateKey = relateKey;
        this.parentKey = parentKey;
        this.searchElements = searchElements;
    }

    public static SelectLeftJoinBuilder builder() {
        return new SelectLeftJoinBuilder();
    }

    public static class SelectLeftJoinBuilder {
        private String schema;
        private String table;
        private List<TableColumn> tableColumns;
        private List<Where> wheres;
        private String relateKey;
        private String parentKey;
        private List<SearchElement> searchElements;

        public SelectLeftJoinBuilder schema(String schema) {
            this.schema = schema;
            return this;
        }

        public SelectLeftJoinBuilder table(String table) {
            this.table = table;
            return this;
        }

        public SelectLeftJoinBuilder tableColumns(TableColumn... tableColumns) {
            if (this.tableColumns == null) {
                this.tableColumns = new ArrayList<>();
            }
            for (TableColumn tableColumn : tableColumns) {
                this.tableColumns.add(tableColumn);
            }
            return this;
        }

        public SelectLeftJoinBuilder wheres(Where... wheres) {
            if (this.wheres == null) {
                this.wheres = new ArrayList<>();
            }
            for (Where where : wheres) {
                this.wheres.add(where);
            }
            return this;
        }

        public SelectLeftJoinBuilder relateKey(String relateKey) {
            this.relateKey = relateKey;
            return this;
        }

        public SelectLeftJoinBuilder parentKey(String parentKey) {
            this.parentKey = parentKey;
            return this;
        }

        public SelectLeftJoinBuilder searchElements(SearchElement... searchElements) {
            if (this.searchElements == null) {
                this.searchElements = new ArrayList<>();
            }
            for (SearchElement searchElement : searchElements) {
                this.searchElements.add(searchElement);
            }
            return this;
        }

        public SelectLeftJoin build() {
            return new SelectLeftJoin(schema, table, tableColumns, wheres, relateKey, parentKey, searchElements);
        }
    }
}
