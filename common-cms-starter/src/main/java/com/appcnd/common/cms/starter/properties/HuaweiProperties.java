package com.appcnd.common.cms.starter.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * created by nihao 2020/07/07
 */
@ConfigurationProperties("common.cms.huawei")
public class HuaweiProperties {
    private String ak;
    private String sk;
    private String bucket;
    private String host;
    private String region;

    public String getAk() {
        if (ak == null) {
            throw new RuntimeException("配置 common.cms.huawei.ak 缺失");
        }
        return ak;
    }

    public void setAk(String ak) {
        this.ak = ak;
    }

    public String getSk() {
        if (sk == null) {
            throw new RuntimeException("配置 common.cms.huawei.sk 缺失");
        }
        return sk;
    }

    public void setSk(String sk) {
        this.sk = sk;
    }

    public String getBucket() {
        if (bucket == null) {
            throw new RuntimeException("配置 common.cms.huawei.bucket 缺失");
        }
        return bucket;
    }

    public void setBucket(String bucket) {
        this.bucket = bucket;
    }

    public String getHost() {
        if (host == null) {
            throw new RuntimeException("配置 common.cms.huawei.host 缺失");
        }
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getRegion() {
        if (region == null) {
            throw new RuntimeException("配置 common.cms.huawei.region 缺失");
        }
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }
}
