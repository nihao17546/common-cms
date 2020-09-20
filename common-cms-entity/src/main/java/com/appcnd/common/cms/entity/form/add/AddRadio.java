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
public class AddRadio extends AddElement {
    private List<Option> radios;

    public AddRadio(String key, String label, String size, FormRule rule, List<Option> radios, Boolean canEdit) {
        super(key, label, null, null, size, null, ElType.RADIO, rule, null, canEdit);
        CommonAssert.notEmpty(radios, "radios 不能为空");
        this.radios = radios;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    public static AddRadioBuilder builder() {
        return new AddRadioBuilder();
    }

    public static class AddRadioBuilder {
        private String key;
        private String label;
        private String size;
        private FormRule rule;
        private List<Option> radios;
        private Boolean canEdit;

        public AddRadioBuilder key(String key) {
            this.key = key;
            return this;
        }

        public AddRadioBuilder label(String label) {
            this.label = label;
            return this;
        }

        public AddRadioBuilder size(String size) {
            this.size = size;
            return this;
        }

        public AddRadioBuilder rule(FormRule rule) {
            this.rule = rule;
            return this;
        }

        public AddRadioBuilder radios(Option... radios) {
            if (this.radios == null) {
                this.radios = new ArrayList<>();
            }
            for (Option option : radios) {
                this.radios.add(option);
            }
            return this;
        }

        public AddRadioBuilder radio(String value, String label) {
            Option option = Option.builder().value(value).label(label).build();
            radios(option);
            return this;
        }

        public AddRadioBuilder canEdit(Boolean canEdit) {
            this.canEdit = canEdit;
            return this;
        }

        public AddRadio build() {
            return new AddRadio(key, label, size, rule, radios, canEdit);
        }
    }
}
