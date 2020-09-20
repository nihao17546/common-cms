package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.ElType;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * created by nihao 2020/1/13
 */
@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class AddUploadPic extends AddElement {
    private String acceptType;
    private Long limitSize;

    @Builder
    public AddUploadPic(String key, String label, String placeholder, FormRule rule, Boolean canEdit, String acceptType, Long limitSize) {
        super(key, label, placeholder, null, null, null, ElType.UPLOAD_PIC, rule, null, canEdit);
        this.acceptType = acceptType;
        this.limitSize = limitSize;
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }
}
