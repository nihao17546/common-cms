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
public class AddDateTimePicker extends AddElement {
    private String format;
    private Class to;

    @Builder
    public AddDateTimePicker(String key, String label, String placeholder, Boolean clearable, String size, Integer width, FormRule rule, Boolean canEdit, Class to) {
        super(key, label, placeholder, clearable, size, width, ElType.DATETIME_PICKER, rule, null, canEdit);
        CommonAssert.notNull(to, "to 不能为空");
        CommonAssert.in(to, Arrays.asList(String.class, Long.class, java.util.Date.class, java.sql.Timestamp.class));
        this.format = "yyyy-MM-dd HH:mm:ss";
        this.to = to;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
