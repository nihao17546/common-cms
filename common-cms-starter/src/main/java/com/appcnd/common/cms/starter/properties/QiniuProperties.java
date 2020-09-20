package com.appcnd.common.cms.starter.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * created by nihao 2020/07/07
 */
@ConfigurationProperties("common.cms.qi.niu")
public class QiniuProperties {
    private String ak;
    private String sk;
    private String bucket;
    private String host;

    public String getAk() {
        if (ak == null) {
            throw new RuntimeException("配置 common.cms.qi.niu.ak 缺失");
        }
        return ak;
    }

    public void setAk(String ak) {
        this.ak = ak;
    }

    public String getSk() {
        if (sk == null) {
            throw new RuntimeException("配置 common.cms.qi.niu.sk 缺失");
        }
        return sk;
    }

    public void setSk(String sk) {
        this.sk = sk;
    }

    public String getBucket() {
        if (bucket == null) {
            throw new RuntimeException("配置 common.cms.qi.niu.bucket 缺失");
        }
        return bucket;
    }

    public void setBucket(String bucket) {
        this.bucket = bucket;
    }

    public String getHost() {
        if (host == null) {
            throw new RuntimeException("配置 common.cms.qi.niu.host 缺失");
        }
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }
}
