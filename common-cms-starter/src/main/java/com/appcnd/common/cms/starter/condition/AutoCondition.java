package com.appcnd.common.cms.starter.condition;

import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.type.AnnotatedTypeMetadata;

/**
 * created by nihao 2021/02/26
 */
public class AutoCondition implements Condition {
    @Override
    public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
        return conditionContext.getEnvironment().getProperty("common.cms.web.url") != null;
    }
}
