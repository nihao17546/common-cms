package com.appcnd.common.cms.entity.table.formatter;

import com.appcnd.common.cms.entity.constant.FormatterType;
import com.appcnd.common.cms.entity.form.Option;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * created by nihao 2020/1/2
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class FormatterSwitch extends Formatter {
    private Option active;
    private Option inactive;

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    public FormatterSwitch(Option active, Option inactive) {
        super(FormatterType.SWITCH);
        CommonAssert.notNull(active, "active 不能为空");
        CommonAssert.notNull(inactive, "inactive 不能为空");
        this.active = active;
        this.inactive = inactive;
    }

    public static FormatterSwitchBuilder builder() {
        return new FormatterSwitchBuilder();
    }

    public static class FormatterSwitchBuilder {
        private Option active;
        private Option inactive;

        public FormatterSwitchBuilder active(String label, String value) {
            this.active = Option.builder().value(value).label(label).build();
            return this;
        }

        public FormatterSwitchBuilder inactive(String label, String value) {
            this.inactive = Option.builder().value(value).label(label).build();
            return this;
        }

        public FormatterSwitch build() {
            return new FormatterSwitch(active, inactive);
        }
    }
}
