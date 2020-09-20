package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.ElType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * 富文本
 * created by nihao 2020/5/26
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class AddRich extends AddElement {

    private Integer maxlength;

    @Builder
    public AddRich(String key, String label, FormRule rule, Integer maxlength) {
        super(key, label, null, null, null, null, ElType.RICH, rule, null, null);
        this.maxlength = maxlength;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
