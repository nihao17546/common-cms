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
public class WhereIsnull extends Where {

    @Builder
    public WhereIsnull(String key) {
        super(key, JudgeType.isnull);
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
