package com.appcnd.common.cms.entity.form;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Arrays;

/**
 * @author nihao 2019/10/20
 */
@Data
@NoArgsConstructor
public abstract class Element implements Serializable {
    private String key;
    private String label;
    private String placeholder;
    private Boolean clearable;
    /**
     * medium/small/mini
     */
    private String size;
    private Integer width;
    private ElType elType;

    public abstract String getClassName();

    public Element(String key, String label, String placeholder, Boolean clearable, String size, Integer width, ElType elType) {
        placeholder = placeholder == null ? "" : placeholder;
        size = size == null ? "small" : size;
        clearable = clearable == null ? true : clearable;
        CommonAssert.hasText(key, "key 不能为空");
        CommonAssert.hasText(label, "label 不能为空");
        CommonAssert.in(size, Arrays.asList("medium","small","mini"));
        CommonAssert.notNull(elType, "elType 不能为空");
        this.key = key;
        this.label = label;
        this.placeholder = placeholder;
        this.clearable = clearable;
        this.size = size;
        this.width = width;
        this.elType = elType;
    }
}
