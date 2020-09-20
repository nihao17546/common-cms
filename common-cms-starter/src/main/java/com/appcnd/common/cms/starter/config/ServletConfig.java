package com.appcnd.common.cms.starter.config;

import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.servlet.ResourceServlet;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;

/**
 * created by nihao 2020/07/07
 */
@EnableConfigurationProperties({ServletProperties.class})
public class ServletConfig {

    @Bean(BasicConstant.beanNamePrefix + "servletRegistrationBean")
    public ServletRegistrationBean registrationBean(@Autowired ServletProperties servletProperties) {
        return new ServletRegistrationBean(new ResourceServlet(BasicConstant.resourcePath, servletProperties.getUrl()), servletProperties.getUrl() + "/static/*");
    }

}
