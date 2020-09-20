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
@Deprecated
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class AddCheckBox extends AddElement {
    private List<Option> checkBoxes;
    private Integer min;
    private Integer max;

    public AddCheckBox(String key, String label, String size, FormRule rule, List<Option> checkBoxes, Integer min, Integer max, Boolean canEdit) {
        super(key, label, null, null, size, null, ElType.CHECKBOX, rule, null, canEdit);
        CommonAssert.notEmpty(checkBoxes, "checkBoxes 不能为空");
        this.checkBoxes = checkBoxes;
        this.min = min;
        this.max = max;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    public static AddCheckBoxBuilder builder() {
        return new AddCheckBoxBuilder();
    }

    public static class AddCheckBoxBuilder {
        private String key;
        private String label;
        private String size;
        private FormRule rule;
        private List<Option> checkBoxes;
        private Integer min;
        private Integer max;
        private Boolean canEdit;

        public AddCheckBoxBuilder key(String key) {
            this.key = key;
            return this;
        }

        public AddCheckBoxBuilder label(String label) {
            this.label = label;
            return this;
        }

        public AddCheckBoxBuilder size(String size) {
            this.size = size;
            return this;
        }

        public AddCheckBoxBuilder rule(FormRule rule) {
            this.rule = rule;
            return this;
        }

        public AddCheckBoxBuilder checkBoxes(Option... checkBoxes) {
            if (this.checkBoxes == null) {
                this.checkBoxes = new ArrayList<>();
            }
            for (Option option : checkBoxes) {
                this.checkBoxes.add(option);
            }
            return this;
        }

        public AddCheckBoxBuilder checkBox(String value, String label) {
            Option option = Option.builder().value(value).label(label).build();
            checkBoxes(option);
            return this;
        }

        public AddCheckBoxBuilder min(Integer min) {
            this.min = min;
            return this;
        }

        public AddCheckBoxBuilder max(Integer max) {
            this.max = max;
            return this;
        }

        public AddCheckBoxBuilder canEdit(Boolean canEdit) {
            this.canEdit = canEdit;
            return this;
        }

        public AddCheckBox build() {
            return new AddCheckBox(key, label, size, rule, checkBoxes, min, max, canEdit);
        }
    }
}
