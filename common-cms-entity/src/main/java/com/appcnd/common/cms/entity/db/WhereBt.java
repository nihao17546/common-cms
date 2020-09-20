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
public class WhereBt extends Where {
    private Object begin;
    private Object end;

    @Builder
    public WhereBt(String key, Object begin, Object end) {
        super(key, JudgeType.bt);
        CommonAssert.notNull(begin, "begin 不能为空");
        CommonAssert.notNull(end, "end 不能为空");
        this.begin = begin;
        this.end = end;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
