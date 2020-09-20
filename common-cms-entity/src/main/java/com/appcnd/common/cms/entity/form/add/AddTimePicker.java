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
public class AddTimePicker extends AddElement {
    private String start;
    private String end;
    private String step;

    @Builder
    public AddTimePicker(String key, String label, String placeholder, Boolean clearable, String size, Integer width,
                         FormRule rule, String start, String end, String step, Boolean canEdit) {
        super(key, label, placeholder, clearable, size, width, ElType.TIME_PICKER, rule, null, canEdit);
        start = start == null ? "00:00" : start;
        end = end == null ? "23:59" : end;
        step = step == null ? "00:30" : step;
        this.start = start;
        this.end = end;
        this.step = step;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
