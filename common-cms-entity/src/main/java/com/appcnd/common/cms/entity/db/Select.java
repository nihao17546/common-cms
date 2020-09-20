package com.appcnd.common.cms.entity.db;

import com.appcnd.common.cms.entity.form.search.SearchElement;
import com.appcnd.common.cms.entity.table.TableColumn;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author nihao 2019/11/14
 */
@Data
@NoArgsConstructor
public class Select implements Serializable {
    private String schema;
    private String table;
    private String alias;
    private String primaryKey;
    private List<String> columns;
    private List<TableColumn> tableColumns;
    private List<Where> wheres;
    private List<SelectLeftJoin> leftJoins;
    private List<SearchElement> searchElements;

    public Select addWhere(Where where) {
        if (this.wheres == null) {
            this.wheres = new ArrayList<>();
        }
        this.wheres.add(where);
        return this;
    }

    public Select addSearch(SearchElement searchElement) {
        if (this.searchElements == null) {
            this.searchElements = new ArrayList<>();
        }
        searchElement.setAlias(this.alias);
        this.searchElements.add(searchElement);
        return this;
    }

    Select(String schema, String table, String primaryKey, List<TableColumn> tableColumns, List<Where> wheres, List<SelectLeftJoin> leftJoins, List<SearchElement> searchElements) {
        CommonAssert.hasText(schema, "schema must not be null");
        CommonAssert.hasText(table, "table must not be null");
        CommonAssert.hasText(primaryKey, "primaryKey must not be null");
        CommonAssert.notEmpty(tableColumns, "tableColumns 不能为空");
        char aliasA = 'a';
        int index = aliasA;
        Set<String> columnSet = new HashSet<>();
        this.columns = new ArrayList<>();
        for (TableColumn co : tableColumns) {
            if (columnSet.contains(co.getProp().toUpperCase())) {
                throw new IllegalArgumentException("查询字段[" + co.getProp() + "]重复");
            }
            columnSet.add(co.getProp().toUpperCase());
            this.columns.add(co.getKey() + " as " + co.getProp());
        }
        if (leftJoins != null && !leftJoins.isEmpty()) {
            for (SelectLeftJoin leftJoin : leftJoins) {
                if (leftJoin.getSchema() == null || leftJoin.getSchema().length() == 0) {
                    leftJoin.setSchema(schema);
                }
                leftJoin.setAlias(String.valueOf((char) ++ index));
                if (leftJoin.getSearchElements() != null && !leftJoin.getSearchElements().isEmpty()) {
                    if (searchElements != null && !searchElements.isEmpty()) {
                        for (SearchElement searchElement : leftJoin.getSearchElements()) {
                            searchElement.setAlias(leftJoin.getAlias());
                        }
                    }
                }
                leftJoin.setColumns(new ArrayList<>());
                for (TableColumn co : leftJoin.getTableColumns()) {
                    if (columnSet.contains(co.getProp().toUpperCase())) {
                        throw new IllegalArgumentException("查询字段[" + co.getProp() + "]重复");
                    }
                    columnSet.add(co.getProp().toUpperCase());
                    leftJoin.getColumns().add(co.getKey() + " as " + co.getProp());
                }
            }
        }
        this.schema = schema;
        this.table = table;
        this.alias = String.valueOf(aliasA);
        this.primaryKey = primaryKey;
        this.tableColumns = tableColumns;
        this.wheres = wheres;
        this.leftJoins = leftJoins;
        this.searchElements = searchElements;
        if (searchElements != null && !searchElements.isEmpty()) {
            for (SearchElement searchElement : searchElements) {
                searchElement.setAlias(this.alias);
            }
        }
    }

    public static SelectBuilder builder() {
        return new SelectBuilder();
    }

    public static class SelectBuilder {
        private String schema;
        private String table;
        private String primaryKey;
        private List<TableColumn> tableColumns;
        private List<Where> wheres;
        private List<SelectLeftJoin> leftJoins;
        private List<SearchElement> searchElements;

        public SelectBuilder schema(String schema) {
            this.schema = schema;
            return this;
        }

        public SelectBuilder table(String table) {
            this.table = table;
            return this;
        }

        public SelectBuilder primaryKey(String primaryKey) {
            this.primaryKey = primaryKey;
            return this;
        }

        public SelectBuilder tableColumns(TableColumn... tableColumns) {
            if (this.tableColumns == null) {
                this.tableColumns = new ArrayList<>();
            }
            for (TableColumn tableColumn : tableColumns) {
                this.tableColumns.add(tableColumn);
            }
            return this;
        }

        public SelectBuilder wheres(Where... wheres) {
            if (this.wheres == null) {
                this.wheres = new ArrayList<>();
            }
            for (Where where : wheres) {
                this.wheres.add(where);
            }
            return this;
        }

        public SelectBuilder leftJoins(SelectLeftJoin... leftJoins) {
            if (this.leftJoins == null) {
                this.leftJoins = new ArrayList<>();
            }
            for (SelectLeftJoin leftJoin : leftJoins) {
                this.leftJoins.add(leftJoin);
            }
            return this;
        }

        public SelectBuilder searchElements(SearchElement... searchElements) {
            if (this.searchElements == null) {
                this.searchElements = new ArrayList<>();
            }
            for (SearchElement searchElement : searchElements) {
                this.searchElements.add(searchElement);
            }
            return this;
        }

        public Select build() {
            return new Select(schema, table, primaryKey, tableColumns, wheres, leftJoins, searchElements);
        }
    }
}
