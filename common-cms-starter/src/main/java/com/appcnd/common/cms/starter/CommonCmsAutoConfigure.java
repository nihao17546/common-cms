package com.appcnd.common.cms.starter;

import com.appcnd.common.cms.starter.config.BeanConfig;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * created by nihao 2020/07/07
 */
@Configuration
@Import({BeanConfig.class})
@ConditionalOnProperty("common.cms.web.url")
public class CommonCmsAutoConfigure {
}
