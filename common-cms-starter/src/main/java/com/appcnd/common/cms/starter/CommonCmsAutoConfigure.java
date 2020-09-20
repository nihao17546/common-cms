package com.appcnd.common.cms.starter;

import com.appcnd.common.cms.starter.config.BeanConfig;
import com.appcnd.common.cms.starter.config.ServletConfig;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * created by nihao 2020/07/07
 */
@Configuration
@Import({ServletConfig.class, BeanConfig.class})
public class CommonCmsAutoConfigure {
}
