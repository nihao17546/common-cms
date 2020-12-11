package com.appcnd.common.cms.starter.config;

import com.appcnd.common.cms.starter.aop.ExceptionHandlerAop;
import com.appcnd.common.cms.starter.controller.ConfigController;
import com.appcnd.common.cms.starter.controller.UploadController;
import com.appcnd.common.cms.starter.controller.WebController;
import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.dao.IWebDao;
import com.appcnd.common.cms.starter.dao.impl.MetaConfigDaoImpl;
import com.appcnd.common.cms.starter.dao.impl.WebDaoImpl;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.properties.DbProperties;
import com.appcnd.common.cms.starter.properties.QiniuProperties;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.service.IWebService;
import com.appcnd.common.cms.starter.service.impl.WebServiceImpl;
import com.appcnd.common.cms.starter.servlet.ResourceServlet;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import com.appcnd.common.cms.starter.util.DBUtil;
import com.appcnd.common.cms.starter.util.SpringContextUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.PostConstruct;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;
import java.util.Map;

/**
 * created by nihao 2020/07/07
 */
@EnableConfigurationProperties({ServletProperties.class, QiniuProperties.class, DbProperties.class})
@Import({SpringContextUtil.class, ExceptionHandlerAop.class})
public class BeanConfig {
    @Autowired
    private SpringContextUtil springContextUtil;
    @Autowired
    private ServletProperties servletProperties;

    @Bean(BasicConstant.beanNamePrefix + "servletRegistrationBean")
    public ServletRegistrationBean registrationBean(@Autowired ServletProperties servletProperties) {
        return new ServletRegistrationBean(new ResourceServlet(BasicConstant.resourcePath, servletProperties.getUrl()), servletProperties.getUrl() + "/static/*");
    }

    @Bean(name = BasicConstant.beanNamePrefix + "dBUtil")
    public DBUtil dbUtil() {
        return new DBUtil();
    }

    @Bean(name = BasicConstant.beanNamePrefix + "metaConfigDao")
    public IMetaConfigDao metaConfigDao() {
        return new MetaConfigDaoImpl();
    }

    @Bean(name = BasicConstant.beanNamePrefix + "webDao")
    public IWebDao webDao() {
        return new WebDaoImpl();
    }

    @Bean(name = BasicConstant.beanNamePrefix + "configJsonUtil")
    public ConfigJsonUtil configJsonUtil() {
        return new ConfigJsonUtil();
    }

    @Bean(name = BasicConstant.beanNamePrefix + "webService")
    public IWebService webService() {
        return new WebServiceImpl();
    }

    @PostConstruct
    public void init() throws Exception {
        modify(ConfigController.class);
        springContextUtil.addBean(ConfigController.class, BasicConstant.beanNamePrefix + "configController");
        springContextUtil.registerController(BasicConstant.beanNamePrefix + "configController");

        modify(UploadController.class);
        springContextUtil.addBean(UploadController.class, BasicConstant.beanNamePrefix + "uploadController");
        springContextUtil.registerController(BasicConstant.beanNamePrefix + "uploadController");

        modify(WebController.class);
        springContextUtil.addBean(WebController.class, BasicConstant.beanNamePrefix + "webController");
        springContextUtil.registerController(BasicConstant.beanNamePrefix + "webController");

        System.out.println(" ____  ____  _      _      ____  _            ____  _      ____\n" +
                "/   _\\/  _ \\/ \\__/|/ \\__/|/  _ \\/ \\  /|      /   _\\/ \\__/|/ ___\\\n" +
                "|  /  | / \\|| |\\/||| |\\/||| / \\|| |\\ ||_____ |  /  | |\\/|||    \\\n" +
                "|  \\__| \\_/|| |  ||| |  ||| \\_/|| | \\||\\____\\|  \\__| |  ||\\___ |\n" +
                "\\____/\\____/\\_/  \\|\\_/  \\|\\____/\\_/  \\|      \\____/\\_/  \\|\\____/\n" +
                "                                                 0.0.4-SNAPSHOT");
    }

    /**
     * 修改RequestMapping path值，统一加前缀
     * @param clazz controller类
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    private void modify(Class clazz) throws NoSuchFieldException, IllegalAccessException {
        RequestMapping requestMapping = (RequestMapping) clazz.getAnnotation(RequestMapping.class);
        String[] paths = requestMapping.value();
        String[] newPaths = new String[paths.length];
        for (int i = 0; i < paths.length; i ++) {
            newPaths[i] = servletProperties.getUrl() + paths[i];
        }
        InvocationHandler invocationHandler = Proxy.getInvocationHandler(requestMapping);
        Field field = invocationHandler.getClass().getDeclaredField("memberValues");
        field.setAccessible(true);
        Map<String, Object> memberValues = (Map<String, Object>) field.get(invocationHandler);
        memberValues.put("value", newPaths);
    }
}
