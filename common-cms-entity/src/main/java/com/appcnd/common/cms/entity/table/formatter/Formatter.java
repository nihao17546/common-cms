package com.appcnd.common.cms.entity.table.formatter;

import com.appcnd.common.cms.entity.constant.FormatterType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @author nihao 2019/11/14
 */
@Data
@NoArgsConstructor
public abstract class Formatter implements Serializable {
    private FormatterType type;

    public abstract String getClassName();

    public Formatter(FormatterType type) {
        CommonAssert.notNull(type, "type 不能为空");
        this.type = type;
    }

    public static FormatterPic.FormatterPicBuilder pic() {
        return FormatterPic.builder();
    }

    public static FormatterUrl.FormatterUrlBuilder url() {
        return FormatterUrl.builder();
    }

    public static FormatterText.FormatterTextBuilder text() {
        return FormatterText.builder();
    }

    public static FormatterSwitch.FormatterSwitchBuilder switcher() {
        return FormatterSwitch.builder();
    }
}
