package com.appcnd.common.cms.entity.table;

import com.appcnd.common.cms.entity.bottom.Bottom;
import com.appcnd.common.cms.entity.constant.TableStyle;
import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.SelectLeftJoin;
import com.appcnd.common.cms.entity.form.add.AddElement;
import com.appcnd.common.cms.entity.form.add.AddForm;
import com.appcnd.common.cms.entity.form.search.SearchElement;
import com.appcnd.common.cms.entity.util.CommonAssert;
import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.*;

/**
 * created by nihao 2020/1/15
 */
@Data
@NoArgsConstructor
public class FollowTable implements Serializable {
    private Boolean pagination;
    private String defaultSortColumn;
    private String defaultOrder;
    private Select select;
    private List<TableColumn> columns;
    /** 关联父表的column */
    private String relateKey;
    /** 当前表的外键column */
    private String parentKey;
    /** 按钮文案 */
    private String bottomName;

    @JSONField(name = "add_form")
    private AddForm addForm;

    @JSONField(name = "add_btn")
    private Boolean addBtn;

    @JSONField(name = "edit_btn")
    private Boolean editBtn;

    @JSONField(name = "delete_btn")
    private Boolean deleteBtn;

    @JSONField(name = "limit_size")
    private Integer limitSize;

    @JSONField(name = "cascading_delete")
    private Boolean cascadingDelete;

    private List<Bottom> bottoms;

    private TableStyle style;

    private Integer optionWidth;

    public FollowTable(Boolean pagination, String defaultSortColumn, String defaultOrder, Select select, String relateKey, String parentKey,
                       String bottomName, AddForm addForm, Boolean deleteBtn, Boolean addBtn, Boolean editBtn, Integer limitSize, List<Bottom> bottoms,
                       Boolean cascadingDelete, TableStyle style, Integer optionWidth) {
        CommonAssert.notNull(select, "select 不能为空");
        CommonAssert.notNull(relateKey, "relateKey 不能为空");
        CommonAssert.notNull(parentKey, "parentKey 不能为空");
        CommonAssert.notNull(bottomName, "bottomName 不能为空");
        if (limitSize != null && limitSize <= 0) {
            throw new IllegalArgumentException("limitSize 须大于0");
        }
        this.limitSize = limitSize;
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
        this.relateKey = relateKey;
        this.parentKey = parentKey;
        this.bottomName = bottomName;
        this.addForm = addForm;
        this.deleteBtn = deleteBtn == null ? false : deleteBtn;
        this.addBtn = addBtn == null ? false : addBtn;
        this.editBtn = editBtn == null ? false : editBtn;
        this.cascadingDelete = cascadingDelete == null ? true : cascadingDelete;
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
        if (this.select.getSearchElements() == null) {
            this.select.setSearchElements(new ArrayList<>());
        }
        boolean b = false;
        for (int i = this.select.getSearchElements().size() - 1; i >= 0; i --) {
            if (this.select.getSearchElements().get(i).getKey().equalsIgnoreCase(this.parentKey)) {
                this.select.getSearchElements().get(i).setShow(false);
                b = true;
            }
        }
        if (!b) {
            SearchElement searchElement = SearchElement.inputEq().key(this.parentKey).label(this.parentKey).build();
            searchElement.setAlias(select.getAlias());
            searchElement.setShow(false);
            select.getSearchElements().add(searchElement);
        }
        if (this.addForm != null) {
            if (this.addForm.getElements() == null) {
                this.addForm.setElements(new ArrayList<>());
            }
            b = false;
            for (AddElement addElement : this.addForm.getElements()) {
                if (addElement.getKey().equalsIgnoreCase(this.parentKey)) {
                    addElement.setShow(false);
                    addElement.setRule(null);
                    b = true;
                }
            }
            if (!b) {
                AddElement addElement = AddElement.input().key(this.parentKey).label(this.parentKey).build();
                addElement.setShow(false);
                this.addForm.getElements().add(addElement);
            }
        }
    }

    public static FollowTableBuilder builder() {
        return new FollowTableBuilder();
    }

    public static class FollowTableBuilder {
        private Boolean pagination;
        private String defaultSortColumn;
        private String defaultOrder;
        private Select select;
        private String relateKey;
        private String parentKey;
        private String bottomName;
        private AddForm addForm;
        private Boolean deleteBtn;
        private Boolean addBtn;
        private Boolean editBtn;
        private Integer limitSize;
        private Boolean cascadingDelete;
        private List<Bottom> bottoms;
        private TableStyle style;
        private Integer optionWidth;

        public FollowTableBuilder pagination(Boolean pagination) {
            this.pagination = pagination;
            return this;
        }

        public FollowTableBuilder defaultSortColumn(String defaultSortColumn) {
            this.defaultSortColumn = defaultSortColumn;
            return this;
        }

        public FollowTableBuilder defaultOrder(String defaultOrder) {
            this.defaultOrder = defaultOrder;
            return this;
        }

        public FollowTableBuilder select(Select select) {
            this.select = select;
            return this;
        }

        public FollowTableBuilder relateKey(String relateKey) {
            this.relateKey = relateKey;
            return this;
        }

        public FollowTableBuilder parentKey(String parentKey) {
            this.parentKey = parentKey;
            return this;
        }

        public FollowTableBuilder bottomName(String bottomName) {
            this.bottomName = bottomName;
            return this;
        }

        public FollowTableBuilder addForm(AddForm addForm) {
            this.addForm = addForm;
            return this;
        }

        public FollowTableBuilder deleteBtn(Boolean deleteBtn) {
            this.deleteBtn = deleteBtn;
            return this;
        }

        public FollowTableBuilder addBtn(Boolean addBtn) {
            this.addBtn = addBtn;
            return this;
        }

        public FollowTableBuilder editBtn(Boolean editBtn) {
            this.editBtn = editBtn;
            return this;
        }

        public FollowTableBuilder limitSize(Integer limitSize) {
            this.limitSize = limitSize;
            return this;
        }

        public FollowTableBuilder cascadingDelete(Boolean cascadingDelete) {
            this.cascadingDelete = cascadingDelete;
            return this;
        }

        public FollowTableBuilder bottom(Bottom... bottoms) {
            if (bottoms != null && bottoms.length > 0) {
                this.bottoms = Arrays.asList(bottoms);
            }
            return this;
        }

        public FollowTableBuilder style(TableStyle style) {
            this.style = style;
            return this;
        }

        public FollowTableBuilder optionWidth(Integer optionWidth) {
            this.optionWidth = optionWidth;
            return this;
        }

        public FollowTable build() {
            return new FollowTable(pagination, defaultSortColumn, defaultOrder, select, relateKey, parentKey, bottomName,
                    addForm, deleteBtn, addBtn, editBtn, limitSize, bottoms, cascadingDelete, style, optionWidth);
        }
    }


}
