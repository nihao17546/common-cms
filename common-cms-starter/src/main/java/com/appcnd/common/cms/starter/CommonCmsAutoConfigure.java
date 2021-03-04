package com.appcnd.common.cms.starter;

import com.appcnd.common.cms.starter.condition.AutoCondition;
import com.appcnd.common.cms.starter.config.BeanConfig;
import org.springframework.context.annotation.Conditional;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * created by nihao 2020/07/07
 */
@Configuration
@Import({BeanConfig.class})
@Conditional(AutoCondition.class)
public class CommonCmsAutoConfigure {
}
