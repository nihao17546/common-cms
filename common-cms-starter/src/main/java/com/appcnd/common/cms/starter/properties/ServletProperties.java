package com.appcnd.common.cms.starter.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * created by nihao 2020/07/07
 */
@ConfigurationProperties("common.cms.web")
public class ServletProperties {
    private String url;
    private String[] configLocations;

    public String getUrl() {
        if (url == null) {
            throw new RuntimeException("配置 common.cms.web.url 缺失");
        }
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String[] getConfigLocations() {
        return configLocations;
    }

    public void setConfigLocations(String[] configLocations) {
        this.configLocations = configLocations;
    }
}
