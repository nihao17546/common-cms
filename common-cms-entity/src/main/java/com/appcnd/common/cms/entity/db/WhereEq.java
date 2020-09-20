package com.appcnd.common.cms.entity.db;

import com.appcnd.common.cms.entity.constant.JudgeType;
import com.appcnd.common.cms.entity.util.CommonAssert;
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
public class WhereEq extends Where {
    private Object value;

    @Builder
    public WhereEq(String key, Object value) {
        super(key, JudgeType.eq);
        CommonAssert.notNull(value, "value 不能为空");
        this.value = value;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
