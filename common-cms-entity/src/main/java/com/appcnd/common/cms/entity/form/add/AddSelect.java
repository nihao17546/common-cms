package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.form.Option;
import com.appcnd.common.cms.entity.util.CommonAssert;
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
public class AddSelect extends AddElement {
    private List<Option> options;

    public AddSelect(String key, String label, String placeholder, Boolean clearable, String size, Integer width,
                     FormRule rule, List<Option> options, Boolean canEdit) {
        super(key, label, placeholder, clearable, size, width, ElType.SELECT, rule, null, canEdit);
        CommonAssert.notEmpty(options, "options 不能为空");
        this.options = options;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    public static AddSelectBuilder builder() {
        return new AddSelectBuilder();
    }

    public static class AddSelectBuilder {
        private String key;
        private String label;
        private String placeholder;
        private Boolean clearable;
        private String size;
        private Integer width;
        private FormRule rule;
        private List<Option> options;
        private Boolean canEdit;

        public AddSelectBuilder key(String key) {
            this.key = key;
            return this;
        }

        public AddSelectBuilder label(String label) {
            this.label = label;
            return this;
        }

        public AddSelectBuilder placeholder(String placeholder) {
            this.placeholder = placeholder;
            return this;
        }

        public AddSelectBuilder clearable(Boolean clearable) {
            this.clearable = clearable;
            return this;
        }

        public AddSelectBuilder size(String size) {
            this.size = size;
            return this;
        }

        public AddSelectBuilder width(Integer width) {
            this.width = width;
            return this;
        }

        public AddSelectBuilder rule(FormRule rule) {
            this.rule = rule;
            return this;
        }

        public AddSelectBuilder options(Option... options) {
            if (this.options == null) {
                this.options = new ArrayList<>();
            }
            for (Option option : options) {
                this.options.add(option);
            }
            return this;
        }

        public AddSelectBuilder option(String value, String label) {
            Option option = Option.builder().value(value).label(label).build();
            options(option);
            return this;
        }

        public AddSelectBuilder canEdit(Boolean canEdit) {
            this.canEdit = canEdit;
            return this;
        }

        public AddSelect build() {
            return new AddSelect(key, label, placeholder, clearable, size, width, rule, options, canEdit);
        }
    }
}
