package com.appcnd.common.cms.entity.table.formatter;

import com.appcnd.common.cms.entity.constant.FormatterType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Arrays;

/**
 * @author nihao 2019/11/14
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class FormatterUrl extends Formatter {
    /**
     * _blank
     * _parent
     * _self
     * _top
     * framename
     */
    private String target = "_blank";
    private String text;

    @Builder
    public FormatterUrl(String target, String text) {
        super(FormatterType.URL);
        target = target == null ? "_blank" : target;
        CommonAssert.in(target, Arrays.asList("_blank","_parent", "_self", "_top"), "target 类型错误");
        this.target = target;
        this.text = text;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
