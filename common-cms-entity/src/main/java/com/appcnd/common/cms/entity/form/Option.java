package com.appcnd.common.cms.entity.form;

import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @author nihao 2019/11/16
 */
@Data
@Builder
@NoArgsConstructor
public class Option implements Serializable {
    private String value;
    private String label;

    public Option(String value, String label) {
        CommonAssert.hasText(value, "value 不能为空");
        CommonAssert.hasText(label, "label 不能为空");
        this.value = value;
        this.label = label;
    }
}
