package com.appcnd.common.cms.entity.table;

import com.appcnd.common.cms.entity.bottom.Bottom;
import com.appcnd.common.cms.entity.constant.TableStyle;
import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.SelectLeftJoin;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.*;

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
    private List<Bottom> bottoms;
    private TableStyle style;
    private Integer optionWidth;

    public Table(Boolean pagination, String defaultSortColumn, String defaultOrder, Select select, List<Bottom> bottoms, TableStyle style, Integer optionWidth) {
        CommonAssert.notNull(select, "select 不能为空");
        this.style = style == null ? TableStyle.A : style;
        if (this.style == TableStyle.B) {
            this.optionWidth = optionWidth != null ? optionWidth : 180;
            if (this.optionWidth <= 0) {
                throw new IllegalArgumentException("操作列宽带不能低于1");
            }
        }
        this.pagination = pagination == null ? false : pagination;
        this.defaultSortColumn = defaultSortColumn;
        this.defaultOrder = defaultOrder;
        this.select = select;
        this.bottoms = bottoms;
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
        private List<Bottom> bottoms;
        private TableStyle style;
        private Integer optionWidth;

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

        public TableBuilder bottom(Bottom... bottoms) {
            if (bottoms != null && bottoms.length > 0) {
                this.bottoms = Arrays.asList(bottoms);
            }
            return this;
        }

        public TableBuilder style(TableStyle style) {
            this.style = style;
            return this;
        }

        public TableBuilder optionWidth(Integer optionWidth) {
            this.optionWidth = optionWidth;
            return this;
        }

        public Table build() {
            return new Table(pagination, defaultSortColumn, defaultOrder, select, bottoms, style, optionWidth);
        }
    }
}
