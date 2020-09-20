package com.appcnd.common.cms.starter.controller;

import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.service.IWebService;
import com.appcnd.common.cms.starter.util.CommonUtils;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import com.appcnd.common.cms.starter.util.DesUtil;
import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.util.CommonUtils;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import com.appcnd.common.cms.starter.util.DesUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;


/**
 * @author nihao 2019/10/19
 */
@RequestMapping("/config")
@Slf4j
public class ConfigController extends BaseController {
    @Autowired
    private ConfigJsonUtil configJsonUtil;
    @Autowired
    private IWebService webService;
    @Autowired
    private ServletProperties servletProperties;

    private Map<String,ConfigEntity> configEntityMap = new HashMap<>();

    @PostConstruct
    public void init() {
        if (servletProperties.getConfigLocations() != null) {
            for (String location : servletProperties.getConfigLocations()) {
                InputStream inputStream = null;
                StringBuilder sb = new StringBuilder();
                BufferedReader reader = null;
                try {
                    Resource resource = new DefaultResourceLoader().getResource(location);
                    if (resource == null) {
                        throw new IllegalArgumentException("配置文件" + location + " 不存在");
                    }
                    inputStream = resource.getInputStream();
                    reader = new BufferedReader(new InputStreamReader(inputStream));
                    String tempString = null;
                    while ((tempString = reader.readLine()) != null) {
                        sb.append(tempString);
                    }
                    ConfigEntity configEntity = configJsonUtil.parse(sb.toString());
                    String key = location;
                    if (key.contains("classpath:")) {
                        key = key.replaceAll("classpath:", "");
                    }
                    if (key.contains("/")) {
                        key = key.substring(key.lastIndexOf("/") + 1);
                    }
                    if (key.contains(".")) {
                        key = key.substring(0, key.indexOf("."));
                    }
                    configEntityMap.put(key, configEntity);
                    log.info("配置文件 {} 读取成功", location);
                } catch (Exception e) {
                    throw new IllegalArgumentException("配置文件" + location + " 读取异常，异常信息：" + e.getMessage());
                } finally {
                    if (reader != null) {
                        try {
                            reader.close();
                        } catch (IOException e) {
                            log.error("close error");
                        }
                    }
                    if (inputStream != null) {
                        try {
                            inputStream.close();
                        } catch (IOException e) {
                            log.error("close error");
                        }
                    }
                }
            }
        }

    }

    @RequestMapping(value = "/api/query", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String query() {
        String key = CommonUtils.getCookieValue("config_key");
        if (key == null) {
            throw  new CmsRuntimeException(HttpStatus.SYSTEM_ERROR.getCode(), "地址错误");
        }
        ConfigEntity configEntity = configEntityMap.get(key);
        if (configEntity == null) {
            String name = null;
            try {
                name = DesUtil.decrypt(key);
            } catch (Exception e) {
                throw  new CmsRuntimeException(HttpStatus.SYSTEM_ERROR.getCode(), "地址错误");
            }
            MetaConfigPo metaConfigPo = null;
            try {
                metaConfigPo = webService.getMetaConfigByName(name);
            } catch (Exception e) {
                log.error("{}", e);
                throw  new CmsRuntimeException(HttpStatus.SYSTEM_ERROR.getCode(), "读取数据库配置信息异常:" + e.getMessage());
            }
            if (metaConfigPo == null) {
                throw  new CmsRuntimeException(HttpStatus.SYSTEM_ERROR.getCode(), "配置不存在");
            }
            try {
                configEntity = configJsonUtil.parse(metaConfigPo.getConfig());
            } catch (Exception e) {
                throw  new CmsRuntimeException(HttpStatus.SYSTEM_ERROR.getCode(), "配置解析异常");
            }
        }
        return ok().pull(configEntity).json();
    }
}
