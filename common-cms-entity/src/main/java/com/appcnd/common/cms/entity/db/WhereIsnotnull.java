package com.appcnd.common.cms.entity.db;

import com.appcnd.common.cms.entity.constant.JudgeType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @author nihao 2021/01/24
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class WhereIsnotnull extends Where {

    @Builder
    public WhereIsnotnull(String key) {
        super(key, JudgeType.isnotnull);
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
