package com.appcnd.common.cms.starter.dao;

import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;


/**
 * @author nihao 2019/10/19
 */
public interface IMetaConfigDao {
    MetaConfigPo selectByName(String name);
}
