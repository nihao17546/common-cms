package com.appcnd.common.cms.entity.form.add;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author nihao 2019/10/21
 */
@Data
@NoArgsConstructor
public class FormRule {
    private boolean required;
    private String message;
    private String regular;

    @Builder
    public FormRule(boolean required, String message, String regular) {
        this.required = required;
        this.message = message;
        this.regular = regular;
    }
}
