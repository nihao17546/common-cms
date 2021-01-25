package com.appcnd.common.cms.starter.dao.impl;

import com.appcnd.common.cms.entity.constant.JudgeType;
import com.appcnd.common.cms.starter.dao.IWebDao;
import com.appcnd.common.cms.starter.exception.CmsRuntimeException;
import com.appcnd.common.cms.starter.pojo.HttpStatus;
import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.CascadingDeleteParam;
import com.appcnd.common.cms.starter.pojo.param.SearchParam;
import com.appcnd.common.cms.starter.util.DBUtil;
import com.appcnd.common.cms.entity.db.*;
import com.appcnd.common.cms.starter.dao.IWebDao;
import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.SearchParam;
import com.appcnd.common.cms.starter.util.DBUtil;
import com.appcnd.common.cms.starter.util.DbExecute;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * created by nihao 2020/07/09
 */
public class WebDaoImpl implements IWebDao {

    @Autowired
    private DBUtil dbUtil;

    @Override
    public Long selectOneToOneCount(ListParam param) {
        List<Object> params = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("select count(1) from `")
                .append(param.getSchema()).append("`.`").append(param.getTable()).append("` ").append(param.getAlias());
        fillOneToOne(params, sb, param);
        String sql = sb.toString();
        return dbUtil.selectCount(sql, params);
    }

    private void fillOneToOne(List<Object> params, StringBuilder sb, ListParam param) {
        if (param.getLeftJoins() != null && !param.getLeftJoins().isEmpty()) {
            for (SelectLeftJoin selectLeftJoin : param.getLeftJoins()) {
                sb.append(" left join `").append(selectLeftJoin.getSchema()).append("`.`").append(selectLeftJoin.getTable()).append("` ").append(selectLeftJoin.getAlias())
                        .append(" on ").append(selectLeftJoin.getAlias()).append(".`").append(selectLeftJoin.getParentKey())
                        .append("` = ").append(param.getAlias()).append(".`").append(selectLeftJoin.getRelateKey()).append("`");
                if (selectLeftJoin.getWheres() != null && !selectLeftJoin.getWheres().isEmpty()) {
                    for (Where where : selectLeftJoin.getWheres()) {
                        sb.append(" and ").append(selectLeftJoin.getAlias()).append(".`").append(where.getKey()).append("`");
                        fillWhere(params, sb, where);
                    }
                }
            }
        }
        sb.append(" where 1=1 ");
        if (param.getWheres() != null && !param.getWheres().isEmpty()) {
            for (Where where : param.getWheres()) {
                sb.append(" and ").append(param.getAlias()).append(".`").append(where.getKey()).append("`");
                fillWhere(params, sb, where);
            }
        }
        if (param.getParams() != null && !param.getParams().isEmpty()) {
            for (SearchParam searchParam : param.getParams()) {
                sb.append(" and ").append(searchParam.getAlias()).append(".").append(searchParam.getKey());
                if (searchParam.getType().equals(JudgeType.eq.name())) {
                    sb.append(" = ? ");
                    params.add(searchParam.getValue());
                } else if (searchParam.getType().equals(JudgeType.like.name())) {
                    sb.append(" like ? ");
                    params.add("%" + searchParam.getValue() + "%");
                } else if (searchParam.getType().equals(JudgeType.gt.name())) {
                    sb.append(" > ? ");
                    params.add(searchParam.getValue());
                } else if (searchParam.getType().equals(JudgeType.gteq.name())) {
                    sb.append(" >= ? ");
                    params.add(searchParam.getValue());
                } else if (searchParam.getType().equals(JudgeType.lt.name())) {
                    sb.append(" < ? ");
                    params.add(searchParam.getValue());
                } else if (searchParam.getType().equals(JudgeType.lteq.name())) {
                    sb.append(" <= ? ");
                    params.add(searchParam.getValue());
                } else if (searchParam.getType().equals(JudgeType.bt.name())) {
                    sb.append(" between ? and ? ");
                    List list = (List) searchParam.getValue();
                    params.add(list.get(0));
                    params.add(list.get(list.size() - 1));
                } else if (searchParam.getType().equals(JudgeType.isnull.name())) {
                    sb.append(" is null ");
                } else if (searchParam.getType().equals(JudgeType.isnotnull.name())) {
                    sb.append(" is not null ");
                }
            }
        }
    }

    private void fillWhere(List<Object> params, StringBuilder sb, Where where) {
        if (where.getType() == JudgeType.eq) {
            sb.append(" = ? ");
            WhereEq whereEq = (WhereEq) where;
            params.add(whereEq.getValue());
        } else if (where.getType() == JudgeType.like) {
            sb.append(" like ? ");
            WhereLike whereLike = (WhereLike) where;
            params.add("%" + whereLike.getValue() + "%");
        } else if (where.getType() == JudgeType.gt) {
            sb.append(" > ? ");
            WhereGt whereGt = (WhereGt) where;
            params.add(whereGt.getValue());
        } else if (where.getType() == JudgeType.gteq) {
            sb.append(" >= ? ");
            WhereGteq whereGteq = (WhereGteq) where;
            params.add(whereGteq.getValue());
        } else if (where.getType() == JudgeType.lt) {
            sb.append(" < ? ");
            WhereLt whereLt = (WhereLt) where;
            params.add(whereLt.getValue());
        } else if (where.getType() == JudgeType.lteq) {
            sb.append(" <= ? ");
            WhereLteq whereLteq = (WhereLteq) where;
            params.add(whereLteq.getValue());
        } else if (where.getType() == JudgeType.in) {
            sb.append(" in (");
            WhereIn whereIn = (WhereIn) where;
            for (int i = 0; i < whereIn.getValues().size(); i ++) {
                if (i == 0) {
                    sb.append("?");
                } else {
                    sb.append(",?");
                }
                params.add(whereIn.getValues().get(i));
            }
            sb.append(") ");
        } else if (where.getType() == JudgeType.bt) {
            sb.append(" between ? and ? ");
            WhereBt whereBt = (WhereBt) where;
            params.add(whereBt.getBegin());
            params.add(whereBt.getEnd());
        } else if (where.getType() == JudgeType.isnull) {
            sb.append(" is null ");
        } else if (where.getType() == JudgeType.isnotnull) {
            sb.append(" is not null ");
        }
    }

    private void appendSelectColumns(String column, StringBuilder sb) {
        String[] columns = column.split(" ");
        if (columns.length == 3) {
            sb.append("`").append(columns[0]).append("`");
            sb.append(" as ");
            sb.append("`").append(columns[2]).append("`");
        } else if (columns.length == 1) {
            sb.append("`").append(columns[0]).append("`");
        } else {
            throw new CmsRuntimeException(HttpStatus.SYSTEM_ERROR.getCode(), "列表查询配置错误");
        }
    }

    @Override
    public List<Map<String, Object>> selectOneToOneList(ListParam param, Integer curPage, Integer pageSize) {
        List<Object> params = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("select ").append(param.getAlias()).append(".`").append(param.getPrimaryKey()).append("`");
        if (param.getColumns() != null && !param.getColumns().isEmpty()) {
            for (String column : param.getColumns()) {
                sb.append(",").append(param.getAlias()).append(".");
                appendSelectColumns(column, sb);
            }
        }
        if (param.getLeftJoins() != null && !param.getLeftJoins().isEmpty()) {
            for (SelectLeftJoin selectLeftJoin : param.getLeftJoins()) {
                if (selectLeftJoin.getColumns() != null && !selectLeftJoin.getColumns().isEmpty()) {
                    for (String column : selectLeftJoin.getColumns()) {
                        sb.append(",").append(selectLeftJoin.getAlias()).append(".");
                        appendSelectColumns(column, sb);
                    }
                }
            }
        }
        sb.append(" from `").append(param.getSchema()).append("`.`").append(param.getTable()).append("` ").append(param.getAlias());
        fillOneToOne(params, sb, param);
        if (param.getSortColumn() != null) {
            sb.append(" order by ").append(param.getAlias()).append(".`").append(param.getSortColumn()).append("`");
            if (param.getOrder() != null) {
                sb.append(" ").append(param.getOrder());
            }
        }
        if (curPage != null && pageSize != null) {
            sb.append(" limit ?,? ");
            params.add((curPage - 1) * pageSize);
            params.add(pageSize);
        }
        String sql = sb.toString();
        return dbUtil.selectList(sql, params);
    }

    @Override
    public List<Map<String, Object>> selectKeyValue(String schema, String table, String key, String value) {
        StringBuilder sb = new StringBuilder();
        sb.append("select `").append(key).append("`,`").append(value).append("` from `").append(schema).append("`.`").append(table).append("`");
        String sql = sb.toString();
        return dbUtil.selectList(sql, null);
    }

    @Override
    public int insert(String schema, String table, String pramaryKey, Map<String, Object> params) {
        StringBuilder sb = new StringBuilder();
        sb.append("insert into `").append(schema).append("`.`").append(table).append("`(");
        List<Object> paramValues = new ArrayList<>(params.size());
        for (String key : params.keySet()) {
            sb.append("`").append(key).append("`,");
            paramValues.add(params.get(key));
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(") values(");
        for (Object value : paramValues) {
            sb.append("?,");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(")");
        String sql = sb.toString();
        return dbUtil.insert(sql, paramValues);
    }

    @Override
    public Map<String, Object> selectByPrimaryKey(String schema, String table, String primaryKey, Object primaryKeyValue, List<String> columns) {
        StringBuilder sb = new StringBuilder();
        sb.append("select `").append(primaryKey).append("`");
        if (columns != null && !columns.isEmpty()) {
            for (String column : columns) {
                sb.append(",`").append(column).append("`");
            }
        }
        sb.append(" from `").append(schema).append("`.`").append(table)
                .append("` where `").append(primaryKey).append("`=?");
        String sql = sb.toString();
        return dbUtil.selectOne(sql, Arrays.asList(primaryKeyValue));
    }

    @Override
    public int update(String schema, String table, String primaryKey, Object primaryKeyValue, Map<String, Object> param) {
        StringBuilder sb = new StringBuilder();
        sb.append("update `").append(schema).append("`.`").append(table)
                .append("` set ");
        List<Object> paramValues = new ArrayList<>(param.size());
        for (String key : param.keySet()) {
            sb.append("`").append(key).append("`=?,");
            paramValues.add(param.get(key));
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(" where `").append(primaryKey).append("`=?");
        paramValues.add(primaryKeyValue);
        String sql = sb.toString();
        return dbUtil.update(sql, paramValues);
    }

    @Override
    public int delete(String schema, String table, String primaryKey, List<Object> primaryKeyValues, List<CascadingDeleteParam> cascadingDeleteParams) {
        StringBuilder sb = new StringBuilder();
        sb.append("delete from `").append(schema).append("`.`").append(table).append("` where `").append(primaryKey).append("` in (");
        for (Object primaryKeyValue : primaryKeyValues) {
            sb.append("?,");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(")");
        String sql = sb.toString();

        if (cascadingDeleteParams == null || cascadingDeleteParams.isEmpty()) {
            return dbUtil.delete(sql, primaryKeyValues);
        }

        List<DbExecute> dbExecutes = new ArrayList<>(cascadingDeleteParams.size() + 1);
        dbExecutes.add(DbExecute.builder().sql(sql).params(primaryKeyValues).build());
        for (CascadingDeleteParam cascadingDelete : cascadingDeleteParams) {
            StringBuilder sbs = new StringBuilder();
            sbs.append("delete from `").append(cascadingDelete.getSchema()).append("`.`").append(cascadingDelete.getTable())
                    .append("` where `").append(cascadingDelete.getParentKey()).append("` in (");
            for (Object primaryKeyValue : primaryKeyValues) {
                sbs.append("?,");
            }
            sbs.deleteCharAt(sbs.length() - 1);
            sbs.append(")");
            String sqlF = sbs.toString();
            dbExecutes.add(DbExecute.builder().sql(sqlF).params(primaryKeyValues).build());
        }
        return dbUtil.batchUpdate(dbExecutes);
    }

    @Override
    public List<Map<String, Object>> selectUnique(String schema, String table, String primaryKey, Map<String, Object> uniqueParams) {
        StringBuilder sb = new StringBuilder();
        sb.append("select `").append(primaryKey).append("`,");
        List<Object> paramValues = new ArrayList<>(uniqueParams.size());
        List<String> paramKeys = new ArrayList<>(uniqueParams.size());
        for (String key : uniqueParams.keySet()) {
            sb.append(key).append(" and ");
            paramValues.add(uniqueParams.get(key));
            paramKeys.add(key);
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.append(" from `").append(schema).append("`.`").append(table).append("` where ");
        for (String key : paramKeys) {
            sb.append(key).append("=? and ");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        String sql = sb.toString();
        return dbUtil.selectList(sql, paramValues);
    }
}
