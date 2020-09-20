package com.appcnd.common.cms.entity.table.formatter;

import com.appcnd.common.cms.entity.constant.FormatterType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * @author nihao 2019/11/14
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class FormatterText extends Formatter {
    private Map<String,String> map;

    FormatterText(Map<String, String> map) {
        super(FormatterType.TEXT);
        CommonAssert.notEmpty(map, "map 不能为空");
        this.map = map;
    }

    public static FormatterTextBuilder builder() {
        return new FormatterTextBuilder();
    }

    public static class FormatterTextBuilder {
        private Map<String,String> map;

        public FormatterTextBuilder kv(String key, String value) {
            CommonAssert.hasText(key, "key 不能为空");
            CommonAssert.hasText(value, "value 不能为空");
            if (this.map == null) {
                this.map = new LinkedHashMap<>();
            }
            this.map.put(key, value);
            return this;
        }

        public FormatterText build() {
            return new FormatterText(map);
        }
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
