package com.appcnd.common.cms.manager.service.impl;

import com.appcnd.common.cms.manager.dao.DbDao;
import com.appcnd.common.cms.manager.exception.CmsRuntimeException;
import com.appcnd.common.cms.manager.pojo.po.ColumnInfo;
import com.appcnd.common.cms.manager.pojo.vo.ColumnVo;
import com.appcnd.common.cms.manager.pojo.vo.HttpStatus;
import com.appcnd.common.cms.manager.pojo.vo.TableVo;
import com.appcnd.common.cms.manager.service.IDbService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author nihao 2020/12/16
 */
@Service
public class DbServiceImpl implements IDbService {
    @Autowired
    private DbDao dbDao;

    private Pattern patternColumn = Pattern.compile("`.+` [A-Za-z]+");
    private Pattern patternPri = Pattern.compile("PRIMARY KEY \\(`.+`\\)");

    @Override
    public TableVo getTable(String schema, String table) {
        List<ColumnInfo> list = dbDao.getTableInfo(schema, table);
        if (list == null || list.isEmpty()) {
            throw new CmsRuntimeException(HttpStatus.SYSTEM_ERROR, "表" + schema + "." + table + "不存在");
        }
        TableVo tableVo = new TableVo();
        List<ColumnVo> columnVoList = new ArrayList<>(list.size() - 1);
        for (ColumnInfo columnInfo : list) {
            if ("PRI".equalsIgnoreCase(columnInfo.getCOLUMN_KEY())) {
                if ("auto_increment".equalsIgnoreCase(columnInfo.getEXTRA())) {
                    tableVo.setPrimaryKeyExtra("auto_increment");
                }
            }
            ColumnVo columnVo = new ColumnVo();
            columnVo.setName(columnInfo.getCOLUMN_NAME());
            columnVo.setType(columnInfo.getDATA_TYPE());
            columnVoList.add(columnVo);
        }
        tableVo.setColumns(columnVoList);
        return tableVo;
    }

    @Override
    public TableVo getTableByShow(String schema, String table) {
        String sql = null;
        try {
            Map<String,String> map = dbDao.showTable(schema, table);
            sql = map.get("Create Table");
        } catch (BadSqlGrammarException e) {
            throw new CmsRuntimeException(HttpStatus.SYSTEM_ERROR, "表" + schema + "." + table + "不存在");
        }
        TableVo tableVo = new TableVo();
        List<ColumnVo> columnVoList = new ArrayList<>();
        Matcher matcherPri = patternPri.matcher(sql);
        if (matcherPri.find()) {
            String a = sql.substring(matcherPri.start(), matcherPri.end());
            String name = a.substring(a.indexOf("`") + 1, a.lastIndexOf("`"));
            tableVo.setPrimaryKey(name);
        }
        Matcher matcherColumn = patternColumn.matcher(sql);
        while (matcherColumn.find()) {
            String a = sql.substring(matcherColumn.start(), matcherColumn.end());
            String name = a.substring(1, a.indexOf("` "));
            if (name.equalsIgnoreCase(tableVo.getPrimaryKey())) {
                Pattern patternPriExtra = Pattern.compile("`" + tableVo.getPrimaryKey() + "`.*,");
                Matcher matcherPriExtra = patternPriExtra.matcher(sql);
                if (matcherPriExtra.find()) {
                    String aa = sql.substring(matcherPriExtra.start(), matcherPriExtra.end() - 1);
                    if (aa.lastIndexOf(" ") > 0) {
                        String extra = aa.substring(aa.lastIndexOf(" ") + 1);
                        tableVo.setPrimaryKeyExtra(extra);
                    }
                }
            }
            String type = a.substring(a.indexOf("` ") + 2);
            ColumnVo columnVo = new ColumnVo();
            columnVo.setName(name);
            columnVo.setType(type);
            columnVoList.add(columnVo);
        }
        tableVo.setColumns(columnVoList);
        return tableVo;
    }
}
