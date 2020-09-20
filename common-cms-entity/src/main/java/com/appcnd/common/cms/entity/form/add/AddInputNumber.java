package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.ElType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @author nihao 2019/11/16
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class AddInputNumber extends AddElement {
    private Number max;
    private Number min;
    private Number precision;
    private Number step;

    @Builder
    public AddInputNumber(String key, String label, String size, Integer width, FormRule rule, Number max, Number min, Boolean canEdit,
                          Number precision, Number step) {
        super(key, label, null, null, size, width, ElType.INPUT_NUMBER, rule, null, canEdit);
        this.max = max;
        this.min = min;
        this.precision = precision;
        this.step = step;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
