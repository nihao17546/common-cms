package com.appcnd.common.cms.entity;

import com.appcnd.common.cms.entity.constant.ObjectStorageType;
import com.appcnd.common.cms.entity.form.add.AddForm;
import com.appcnd.common.cms.entity.table.FollowTable;
import com.appcnd.common.cms.entity.table.Table;
import com.appcnd.common.cms.entity.util.CommonAssert;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.serializer.SerializerFeature;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * created by nihao 2020/1/2
 */
@Data
@NoArgsConstructor
public class ConfigEntity implements Serializable {

    private String title;

    private Table table;

    @JSONField(name = "follow_tables")
    private List<FollowTable> followTables;

    @JSONField(name = "add_form")
    private AddForm addForm;

    @JSONField(name = "add_btn")
    private Boolean addBtn;

    @JSONField(name = "edit_btn")
    private Boolean editBtn;

    @JSONField(name = "delete_btn")
    private Boolean deleteBtn;

    private ObjectStorageType storage;

    public ConfigEntity(String title, Table table, AddForm addForm, Boolean addBtn, Boolean editBtn, Boolean deleteBtn, List<FollowTable> followTables, ObjectStorageType storage) {
        CommonAssert.hasText(title, "title 不能为空");
        CommonAssert.notNull(table, "table 不能为空");
        this.title = title;
        this.table = table;
        this.addForm = addForm;
        this.followTables = followTables;
        this.addBtn = addBtn == null ? false : addBtn;
        this.editBtn = editBtn == null ? false : editBtn;
        this.deleteBtn = deleteBtn == null ? false : deleteBtn;
        this.storage = storage;
        if (this.addBtn || this.editBtn || this.deleteBtn) {
            if (this.addForm == null) {
                throw new IllegalArgumentException("配置了操作按钮必须要配置AddForm");
            }
        }
    }

    public static ConfigEntityBuilder builder() {
        return new ConfigEntityBuilder();
    }

    public static class ConfigEntityBuilder {
        private String title;
        private Table table;
        private List<FollowTable> followTables;
        private AddForm addForm;
        private Boolean addBtn;
        private Boolean editBtn;
        private Boolean deleteBtn;
        private ObjectStorageType storage;

        public ConfigEntityBuilder storage(ObjectStorageType storage) {
            this.storage = storage;
            return this;
        }

        public ConfigEntityBuilder title(String title) {
            this.title = title;
            return this;
        }

        public ConfigEntityBuilder table(Table table) {
            this.table = table;
            return this;
        }

        public ConfigEntityBuilder followTables(FollowTable... followTables) {
            if (this.followTables == null) {
                this.followTables = new ArrayList<>();
            }
            for (FollowTable followTable : followTables) {
                this.followTables.add(followTable);
            }
            return this;
        }

        public ConfigEntityBuilder addForm(AddForm addForm) {
            this.addForm = addForm;
            return this;
        }

        public ConfigEntityBuilder addBtn(Boolean addBtn) {
            this.addBtn = addBtn;
            return this;
        }

        public ConfigEntityBuilder editBtn(Boolean editBtn) {
            this.editBtn = editBtn;
            return this;
        }

        public ConfigEntityBuilder deleteBtn(Boolean deleteBtn) {
            this.deleteBtn = deleteBtn;
            return this;
        }

        public ConfigEntity build() {
            return new ConfigEntity(title, table, addForm, addBtn, editBtn, deleteBtn, followTables, storage);
        }
    }

    public String json() {
        return JSON.toJSONString(this, SerializerFeature.DisableCircularReferenceDetect);
    }

    @Override
    public String toString() {
        return json();
    }
}
