package com.appcnd.common.cms.entity.db;

import com.appcnd.common.cms.entity.constant.JudgeType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

/**
 * @author nihao 2019/11/14
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class WhereIn extends Where {
    private List<Object> values;

    @Builder
    public WhereIn(String key, List<Object> values) {
        super(key, JudgeType.in);
        CommonAssert.notEmpty(values, "values 不能为空");
        this.values = values;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
