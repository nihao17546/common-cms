package com.appcnd.common.cms.starter.config;

import com.appcnd.common.cms.starter.aop.ExceptionHandlerAop;
import com.appcnd.common.cms.starter.controller.ConfigController;
import com.appcnd.common.cms.starter.controller.UploadController;
import com.appcnd.common.cms.starter.controller.WebController;
import com.appcnd.common.cms.starter.dao.impl.MetaConfigDaoImpl;
import com.appcnd.common.cms.starter.dao.impl.WebDaoImpl;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.properties.DbProperties;
import com.appcnd.common.cms.starter.properties.QiniuProperties;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.service.impl.WebServiceImpl;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import com.appcnd.common.cms.starter.util.DBUtil;
import com.appcnd.common.cms.starter.util.SpringContextUtil;
import com.appcnd.common.cms.starter.aop.ExceptionHandlerAop;
import com.appcnd.common.cms.starter.controller.UploadController;
import com.appcnd.common.cms.starter.controller.WebController;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import com.appcnd.common.cms.starter.util.DBUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
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
@EnableConfigurationProperties({QiniuProperties.class, DbProperties.class})
@Import({SpringContextUtil.class, ExceptionHandlerAop.class})
public class BeanConfig {
    @Autowired
    private SpringContextUtil springContextUtil;
    @Autowired
    private ServletProperties servletProperties;

    @PostConstruct
    public void init() throws Exception {
        springContextUtil.addBean(DBUtil.class, BasicConstant.beanNamePrefix + "dBUtil");

        springContextUtil.addBean(MetaConfigDaoImpl.class, BasicConstant.beanNamePrefix + "metaConfigDao");

        springContextUtil.addBean(WebDaoImpl.class, BasicConstant.beanNamePrefix + "webDao");

        springContextUtil.addBean(ConfigJsonUtil.class, BasicConstant.beanNamePrefix + "configJsonUtil");

        springContextUtil.addBean(WebServiceImpl.class, BasicConstant.beanNamePrefix + "webService");

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
                "                                                 0.0.2-SNAPSHOT");
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
