package com.appcnd.common.cms.entity.bottom;

import com.appcnd.common.cms.entity.constant.BottomType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Arrays;

/**
 * created by nihao 2020/12/10
 */
@Data
@NoArgsConstructor
public abstract class Bottom implements Serializable {
    private BottomType type;
    private String name;
    private String style;

    public abstract String getClassName();

    public Bottom(BottomType type, String name, String style) {
        CommonAssert.notNull(type, "type 不能为空");
        CommonAssert.hasText(name, "name 不能为空");
        if (style == null) {
            style = "primary";
        }
        CommonAssert.in(style, Arrays.asList("primary","success","info","warning","danger"));
        this.type = type;
        this.name = name;
        this.style = style;
    }

    public static ExternalLinksBottom.ExternalLinksBottomBuilder externalLinks() {
        return ExternalLinksBottom.builder();
    }
}
