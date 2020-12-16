package com.appcnd.common.cms.manager.service;

import com.appcnd.common.cms.manager.pojo.vo.TableVo;


/**
 * @author nihao 2020/12/16
 */
public interface IDbService {
    TableVo getTable(String schema, String table);
    TableVo getTableByShow(String schema, String table);
}
