package com.appcnd.common.cms.entity.form.search;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.constant.JudgeType;
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
public class SearchDatetimePickerBt extends SearchElement {
    private String format;

    @Builder
    public SearchDatetimePickerBt(String key, String label, String placeholder, Boolean clearable, String size, Integer width, Object defaultValue) {
        super(key, label, placeholder, clearable, size, width, defaultValue, ElType.DATETIME_PICKER, JudgeType.bt);
        this.format = "yyyy-MM-dd HH:mm:ss";
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
