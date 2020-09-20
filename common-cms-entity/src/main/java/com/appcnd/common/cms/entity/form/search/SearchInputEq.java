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
public class SearchInputEq extends SearchElement {

    @Builder
    public SearchInputEq(String key, String label, String placeholder, Boolean clearable, String size, Integer width, Object defaultValue) {
        super(key, label, placeholder, clearable, size, width, defaultValue, ElType.INPUT, JudgeType.eq);
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
