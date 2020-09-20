package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * created by nihao 2019/12/31
 */
@Data
@NoArgsConstructor
public class UniqueColumn implements Serializable {
    private String toast;
    private List<String> columns;

    @Builder
    public UniqueColumn(String toast, List<String> columns) {
        CommonAssert.hasText(toast, "toast提示不能为空");
        CommonAssert.notEmpty(columns, "columns 不能为空");
        this.toast = toast;
        this.columns = columns;
    }
}
