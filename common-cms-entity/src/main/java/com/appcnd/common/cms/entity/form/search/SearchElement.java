package com.appcnd.common.cms.entity.form.search;

import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.constant.JudgeType;
import com.appcnd.common.cms.entity.form.Element;
import com.appcnd.common.cms.entity.util.CommonAssert;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author nihao 2019/11/16
 */
@Data
@NoArgsConstructor
public abstract class SearchElement extends Element {
    private String alias;
    private JudgeType judgeType;
    private Object defaultValue;
    private Boolean show = true;

    public SearchElement(String key, String label, String placeholder, Boolean clearable, String size, Integer width, Object defaultValue, ElType elType, JudgeType judgeType) {
        super(key, label, placeholder, clearable, size, width == null ? 150 : width, elType);
        CommonAssert.notNull(judgeType, "judgeType 不能为空");
        this.judgeType = judgeType;
        this.defaultValue = defaultValue;
    }

    public static SearchDatePickerBt.SearchDatePickerBtBuilder datePickerBt() {
        return SearchDatePickerBt.builder();
    }

    public static SearchDatetimePickerBt.SearchDatetimePickerBtBuilder datetimePickerBt() {
        return SearchDatetimePickerBt.builder();
    }

    public static SearchInputEq.SearchInputEqBuilder inputEq() {
        return SearchInputEq.builder();
    }

    public static SearchInputLike.SearchInputLikeBuilder inputLike() {
        return SearchInputLike.builder();
    }

    public static SearchSelect.SearchSelectBuilder select() {
        return SearchSelect.builder();
    }

    public static SearchSelectRemote.SearchSelectRemoteBuilder selectRemote() {
        return SearchSelectRemote.builder();
    }
}
