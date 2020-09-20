package com.appcnd.common.cms.entity.db;

import com.appcnd.common.cms.entity.constant.JudgeType;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @author nihao 2019/11/14
 */
@Data
@NoArgsConstructor
public abstract class Where implements Serializable {
    private String key;
    private JudgeType type;

    public abstract String getClassName();

    public Where(String key, JudgeType type) {
        CommonAssert.hasText(key, "key 不能为空");
        CommonAssert.notNull(type, "type 不能为空");
        this.key = key;
        this.type = type;
    }

    public static WhereBt.WhereBtBuilder bt() {
        return WhereBt.builder();
    }

    public static WhereEq.WhereEqBuilder eq() {
        return WhereEq.builder();
    }

    public static WhereGt.WhereGtBuilder gt() {
        return WhereGt.builder();
    }

    public static WhereGteq.WhereGteqBuilder gteq() {
        return WhereGteq.builder();
    }

    public static WhereIn.WhereInBuilder in() {
        return WhereIn.builder();
    }

    public static WhereLike.WhereLikeBuilder like() {
        return WhereLike.builder();
    }

    public static WhereLt.WhereLtBuilder lt() {
        return WhereLt.builder();
    }

    public static WhereLteq.WhereLteqBuilder lteq() {
        return WhereLteq.builder();
    }
}
