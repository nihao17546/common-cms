package com.appcnd.common.cms.starter.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * created by nihao 2020/07/07
 */
@ConfigurationProperties("common.cms.manager")
public class ManagerProperties {
    private String loginname = "root";
    private String password = "123456";

    public String getLoginname() {
        return loginname;
    }

    public void setLoginname(String loginname) {
        this.loginname = loginname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
