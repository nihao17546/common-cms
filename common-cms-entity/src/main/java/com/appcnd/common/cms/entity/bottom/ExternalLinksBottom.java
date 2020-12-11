package com.appcnd.common.cms.entity.bottom;

import com.appcnd.common.cms.entity.constant.BottomType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Arrays;
import java.util.List;

/**
 * created by nihao 2020/12/10
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class ExternalLinksBottom extends Bottom {
    private String url;
    private List<String> params;
    private Boolean paramFormDb;

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    public ExternalLinksBottom(String url, String name, List<String> params, String style, Boolean paramFormDb) {
        super(BottomType.EXTERNAL_LINKS, name, style);
        CommonAssert.hasText(name, "name 不能为空");
        if (paramFormDb == null) {
            paramFormDb = false;
        }
        this.paramFormDb = paramFormDb;
        this.url = url;
        this.params = params;
    }

    public static ExternalLinksBottomBuilder builder() {
        return new ExternalLinksBottomBuilder();
    }

    public static class ExternalLinksBottomBuilder {
        private String url;
        private String name;
        private List<String> params;
        private String style;
        private Boolean paramFormDb;

        public ExternalLinksBottomBuilder paramFormDb(Boolean paramFormDb) {
            this.paramFormDb = paramFormDb;
            return this;
        }

        public ExternalLinksBottomBuilder style(String style) {
            this.style = style;
            return this;
        }

        public ExternalLinksBottomBuilder url(String url) {
            this.url = url;
            return this;
        }

        public ExternalLinksBottomBuilder name(String name) {
            this.name = name;
            return this;
        }

        public ExternalLinksBottomBuilder param(String... params) {
            if (params != null && params.length > 0) {
                this.params = Arrays.asList(params);
            }
            return this;
        }

        public ExternalLinksBottom build() {
            return new ExternalLinksBottom(url, name, params, style, paramFormDb);
        }
    }
}
