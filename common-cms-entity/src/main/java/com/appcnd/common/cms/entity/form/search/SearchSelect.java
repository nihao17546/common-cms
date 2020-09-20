package com.appcnd.common.cms.entity.form.search;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.constant.JudgeType;
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
public class SearchSelect extends SearchElement {
    private List<Option> options;

    SearchSelect(String key, String label, String placeholder, Boolean clearable, String size, Integer width, Object defaultValue, List<Option> options) {
        super(key, label, placeholder, clearable, size, width, defaultValue, ElType.SELECT, JudgeType.eq);
        CommonAssert.notEmpty(options, "options 不能为空");
        this.options = options;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    public static SearchSelectBuilder builder() {
        return new SearchSelectBuilder();
    }

    public static class SearchSelectBuilder {
        private String key;
        private String label;
        private String placeholder;
        private Boolean clearable;
        private String size;
        private Integer width;
        private Object defaultValue;
        private List<Option> options;

        public SearchSelectBuilder key(String key) {
            this.key = key;
            return this;
        }

        public SearchSelectBuilder label(String label) {
            this.label = label;
            return this;
        }

        public SearchSelectBuilder placeholder(String placeholder) {
            this.placeholder = placeholder;
            return this;
        }

        public SearchSelectBuilder clearable(Boolean clearable) {
            this.clearable = clearable;
            return this;
        }

        public SearchSelectBuilder size(String size) {
            this.size = size;
            return this;
        }

        public SearchSelectBuilder width(Integer width) {
            this.width = width;
            return this;
        }

        public SearchSelectBuilder defaultValue(Object defaultValue) {
            this.defaultValue = defaultValue;
            return this;
        }

        public SearchSelectBuilder options(Option... options) {
            if (this.options == null) {
                this.options = new ArrayList<>();
            }
            for (Option option : options) {
                this.options.add(option);
            }
            return this;
        }

        public SearchSelectBuilder option(String value, String label) {
            Option option = Option.builder().value(value).label(label).build();
            options(option);
            return this;
        }

        public SearchSelect build() {
            return new SearchSelect(key, label, placeholder, clearable, size, width, defaultValue, options);
        }
    }
}
