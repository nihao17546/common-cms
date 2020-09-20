package com.appcnd.common.cms.starter.dao.impl;

import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.util.DBUtil;
import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.util.DBUtil;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Arrays;

/**
 * created by nihao 2020/07/09
 */
public class MetaConfigDaoImpl implements IMetaConfigDao {

    @Autowired
    private DBUtil dbUtil;

    @Override
    public MetaConfigPo selectByName(String name) {
        return dbUtil.selectOne("select * from tb_meta_config where `name`=?", MetaConfigPo.class, Arrays.asList(name));
    }
}
