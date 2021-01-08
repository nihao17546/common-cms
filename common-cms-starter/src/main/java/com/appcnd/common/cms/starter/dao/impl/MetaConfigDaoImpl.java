package com.appcnd.common.cms.starter.dao.impl;

import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.pojo.po.ColumnInfo;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.util.DBUtil;
import com.appcnd.common.cms.starter.dao.IMetaConfigDao;
import com.appcnd.common.cms.starter.pojo.po.MetaConfigPo;
import com.appcnd.common.cms.starter.util.DBUtil;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Override
    public MetaConfigPo selectById(Integer id) {
        return dbUtil.selectOne("select * from tb_meta_config where `id`=?", MetaConfigPo.class, Arrays.asList(id));
    }

    @Override
    public int insert(MetaConfigPo metaConfigPo) {
        return dbUtil.insert("insert into tb_meta_config(`name`,`db_name`,`config`,`created_at`,`updated_at`) values(?,?,?,?,?)",
                Arrays.asList(metaConfigPo.getName(), "1", metaConfigPo.getConfig(), metaConfigPo.getCreated_at(), metaConfigPo.getCreated_at()));
    }

    @Override
    public int update(MetaConfigPo metaConfigPo) {
        return dbUtil.update("update tb_meta_config set `config`=?,`updated_at`=? where id=?",
                Arrays.asList(metaConfigPo.getConfig(), metaConfigPo.getUpdated_at(), metaConfigPo.getId()));
    }

    @Override
    public int delete(Integer id) {
        return dbUtil.delete("delete from tb_meta_config where id=?", Arrays.asList(id));
    }

    @Override
    public List<MetaConfigPo> selectAll() {
        return dbUtil.selectList("select * from tb_meta_config order by id desc", MetaConfigPo.class, null);
    }

    @Override
    public Map<String, String> showTable(String tableSchema, String tableName) {
        Map<String, Object> map = dbUtil.selectOne("show create table " + tableSchema + "." + tableName, null);
        Map<String,String> result = new HashMap<>(map.size());
        for(Map.Entry<String, Object> entry : map.entrySet()){
            result.put(entry.getKey(), entry.getValue().toString());
        }
        return result;
    }

    @Override
    public List<ColumnInfo> getTableInfo(String tableSchema, String tableName) {
        return dbUtil.selectList("select * from INFORMATION_SCHEMA.columns where table_name = ? and table_schema = ?",
                ColumnInfo.class, Arrays.asList(tableName, tableSchema));
    }
}
