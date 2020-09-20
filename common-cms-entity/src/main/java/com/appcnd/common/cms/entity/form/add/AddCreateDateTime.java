package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.AddColumnType;
import com.appcnd.common.cms.entity.constant.ElType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @author nihao 2019/11/16
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class  AddCreateDateTime extends AddElement {

    @Builder
    public AddCreateDateTime(String key) {
        super(key, key, null, null, null, null, ElType.DATETIME_PICKER, null, AddColumnType.CREATE_DATETIME, null);
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
