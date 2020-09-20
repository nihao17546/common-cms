package com.appcnd.common.cms.entity.table;

import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.SelectLeftJoin;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * created by nihao 2020/1/2
 */
@Data
@NoArgsConstructor
public class Table implements Serializable {
    private Boolean pagination;
    private String defaultSortColumn;
    private String defaultOrder;
    private Select select;
    private List<TableColumn> columns;

    public Table(Boolean pagination, String defaultSortColumn, String defaultOrder, Select select) {
        CommonAssert.notNull(select, "select 不能为空");
        this.pagination = pagination == null ? false : pagination;
        this.defaultSortColumn = defaultSortColumn;
        this.defaultOrder = defaultOrder;
        this.select = select;
        this.columns = new ArrayList<>();
        this.columns.addAll(select.getTableColumns());
        if (select.getLeftJoins() != null) {
            for (SelectLeftJoin leftJoin : select.getLeftJoins()) {
                this.columns.addAll(leftJoin.getTableColumns());
            }
        }
        Collections.sort(this.columns, new Comparator<TableColumn>() {
            @Override
            public int compare(TableColumn o1, TableColumn o2) {
                return o1.getIndex() -  o2.getIndex();
            }
        });
    }

    public static TableBuilder builder() {
        return new TableBuilder();
    }

    public static class TableBuilder {
        private Boolean pagination;
        private String defaultSortColumn;
        private String defaultOrder;
        private Select select;

        public TableBuilder pagination(Boolean pagination) {
            this.pagination = pagination;
            return this;
        }

        public TableBuilder defaultSortColumn(String defaultSortColumn) {
            this.defaultSortColumn = defaultSortColumn;
            return this;
        }

        public TableBuilder defaultOrder(String defaultOrder) {
            this.defaultOrder = defaultOrder;
            return this;
        }

        public TableBuilder select(Select select) {
            this.select = select;
            return this;
        }

        public Table build() {
            return new Table(pagination, defaultSortColumn, defaultOrder, select);
        }
    }
}
