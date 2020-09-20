package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Arrays;

/**
 * @author nihao 2019/11/16
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class AddInput extends AddElement {
    /**
     * text/textarea
     */
    private String type;
    private Integer maxlength;
    private Integer minlength;

    @Builder
    public AddInput(String key, String label, String placeholder, Boolean clearable, String size, Integer width, FormRule rule, String type, Integer maxlength, Integer minlength, Boolean canEdit) {
        super(key, label, placeholder, clearable, size, width, ElType.INPUT, rule, null, canEdit);
        type = type == null ? "text" : type;
        CommonAssert.in(type, Arrays.asList("text","textarea"));
        this.type = type;
        this.maxlength = maxlength;
        this.minlength = minlength;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
