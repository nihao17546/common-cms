package com.appcnd.common.cms.entity.table.formatter;

import com.appcnd.common.cms.entity.constant.FormatterType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @author nihao 2019/11/14
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class FormatterPic extends Formatter {
    private Integer width;
    private Integer height;

    @Builder
    public FormatterPic(Integer width, Integer height) {
        super(FormatterType.PIC);
        if (width == null && height == null) {
            width = 50;
            height = 50;
        }
        this.width = width;
        this.height = height;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
