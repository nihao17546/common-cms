package com.appcnd.common.cms.starter.util;

import com.appcnd.common.cms.starter.properties.DbProperties;
import com.alibaba.druid.pool.DruidDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.*;
import java.util.List;
import java.util.Map;

/**
 * created by nihao 2020/07/09
 */
@Slf4j
public class DBUtil implements ApplicationContextAware {
    private ApplicationContext applicationContext;

    @Autowired
    private DbProperties dbProperties;

    DataSource dataSource;

    @PostConstruct
    public void init() {
        if (dbProperties.getUrl() == null || dbProperties.getUrl().isEmpty()) {
            log.info("使用自带数据源");
            try {
                dataSource = applicationContext.getAutowireCapableBeanFactory().getBean(DataSource.class);
                log.info("自带数据源装配成功");
            } catch (Exception e) {
                log.error("自动装配数据源异常", e);
                throw e;
            }
        } else {
            log.info("创建数据源");
            DruidDataSource druidDataSource = new DruidDataSource();
            druidDataSource.setUrl(dbProperties.getUrl());
            druidDataSource.setUsername(dbProperties.getUsername());
            druidDataSource.setPassword(dbProperties.getPassword());
            if (dbProperties.getInitialSize() != null) {
                druidDataSource.setInitialSize(dbProperties.getInitialSize());
            }
            if (dbProperties.getMinIdle() != null) {
                druidDataSource.setMinIdle(dbProperties.getMinIdle());
            }
            if (dbProperties.getMaxActive() != null) {
                druidDataSource.setMaxActive(dbProperties.getMaxActive());
            }
            if (dbProperties.getMaxWait() != null) {
                druidDataSource.setMaxWait(dbProperties.getMaxWait());
            }
            if (dbProperties.getTimeBetweenEvictionRunsMillis() != null) {
                druidDataSource.setTimeBetweenEvictionRunsMillis(dbProperties.getTimeBetweenEvictionRunsMillis());
            }
            if (dbProperties.getMinEvictableIdleTimeMillis() != null) {
                druidDataSource.setMinEvictableIdleTimeMillis(dbProperties.getMinEvictableIdleTimeMillis());
            }
            if (dbProperties.getValidationQuery() != null) {
                druidDataSource.setValidationQuery(dbProperties.getValidationQuery());
            }
            if (dbProperties.getTestWhileIdle() != null) {
                druidDataSource.setTestWhileIdle(dbProperties.getTestWhileIdle());
            }
            if (dbProperties.getTestOnBorrow() != null) {
                druidDataSource.setTestOnBorrow(dbProperties.getTestOnBorrow());
            }
            if (dbProperties.getTestOnReturn() != null) {
                druidDataSource.setTestOnReturn(dbProperties.getTestOnReturn());
            }
            if (dbProperties.getPoolPreparedStatements() != null) {
                druidDataSource.setPoolPreparedStatements(dbProperties.getPoolPreparedStatements());
            }
            if (dbProperties.getMaxPoolPreparedStatementPerConnectionSize() != null) {
                druidDataSource.setMaxPoolPreparedStatementPerConnectionSize(dbProperties.getMaxPoolPreparedStatementPerConnectionSize());
            }
            dataSource = druidDataSource;
            log.info("数据源创建成功");
        }
    }

    private Connection getConnection() {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void closeAll(ResultSet resultSet, Statement statement, Connection connection){
        if(resultSet != null){
            try {
                resultSet.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(statement != null){
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(connection != null){
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String getParamString(List<Object> params) {
        StringBuilder sb = new StringBuilder();
        if (params != null) {
            for (Object obj : params) {
                if (obj == null) {
                    sb.append("|null|");
                } else {
                    sb.append("|").append(obj).append("(").append(obj.getClass().getSimpleName()).append(")|");
                }
            }
        }
        return sb.toString();
    }

    public Long selectCount(String sql, List<Object> params) {
        log.debug("Preparing: {}", sql);
        log.debug("Parameters: {}", getParamString(params));
        Connection conn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            st = conn.prepareStatement(sql);
            rs = executeQuery(st, params);
            rs.next();
            return rs.getLong(1);
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            closeAll(rs, st, conn);
        }
    }

    private ResultSet executeQuery(PreparedStatement st, List<Object> params) throws SQLException {
        if (params != null && !params.isEmpty()) {
            for (int i = 0; i < params.size(); i ++) {
                st.setObject(i+1, params.get(i));
            }
        }
        ResultSet rs = st.executeQuery();
        return rs;
    }

    public List<Map<String,Object>> selectList(String sql, List<Object> params) {
        log.debug("Preparing: {}", sql);
        log.debug("Parameters: {}", getParamString(params));
        Connection conn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            st = conn.prepareStatement(sql);
            rs = executeQuery(st, params);
            return new ResultSetMapper().toMap(rs);
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            closeAll(rs, st, conn);
        }
    }

    public <T> List<T> selectList(String sql, Class<T> clazz, List<Object> params) {
        log.debug("Preparing: {}", sql);
        log.debug("Parameters: {}", getParamString(params));
        Connection conn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            st = conn.prepareStatement(sql);
            rs = executeQuery(st, params);
            List<T> list = new ResultSetMapper<T>().toObject(rs, clazz);
            return list;
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            closeAll(rs, st, conn);
        }
    }

    public <T> T selectOne(String sql, Class<T> clazz, List<Object> params) {
        log.debug("Preparing: {}", sql);
        log.debug("Parameters: {}", getParamString(params));
        List<T> list = selectList(sql, clazz, params);
        if (list == null || list.isEmpty()) {
            return null;
        } else if (list.size() > 1) {
            throw new RuntimeException("查询结果" + list.size());
        }
        return list.get(0);
    }

    public Map<String,Object> selectOne(String sql, List<Object> params) {
        List<Map<String,Object>> list = selectList(sql, params);
        if (list == null || list.isEmpty()) {
            return null;
        } else if (list.size() > 1) {
            throw new RuntimeException("查询结果" + list.size());
        }
        return list.get(0);
    }

    public int update(String sql, List<Object> params) {
        log.debug("Preparing: {}", sql);
        log.debug("Parameters: {}", getParamString(params));
        Connection conn = null;
        PreparedStatement st = null;
        try {
            conn = getConnection();
            st = conn.prepareStatement(sql);
            if (params != null && !params.isEmpty()) {
                for (int i = 0; i < params.size(); i ++) {
                    st.setObject(i+1, params.get(i));
                }
            }
            return st.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            closeAll(null, st, conn);
        }
    }

    public int batchUpdate(List<DbExecute> executes) {
        if (executes == null || executes.isEmpty()) {
            return 0;
        }
        int result = 0;
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            for (DbExecute dbExecute : executes) {
                log.debug("Preparing: {}", dbExecute.getSql());
                log.debug("Parameters: {}", getParamString(dbExecute.getParams()));
                PreparedStatement st = conn.prepareStatement(dbExecute.getSql());
                if (dbExecute.getParams() != null && !dbExecute.getParams().isEmpty()) {
                    for (int i = 0; i < dbExecute.getParams().size(); i ++) {
                        st.setObject(i+1, dbExecute.getParams().get(i));
                    }
                }
                result = result + st.executeUpdate();
                if (st != null) {
                    try {
                        st.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
            conn.commit();
            return result;
        } catch (Exception e) {
            try {
                conn.rollback();
            } catch (SQLException e1) {}
            throw new RuntimeException(e);
        } finally {
            if(conn != null){
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public int insert(String sql, List<Object> params) {
        return update(sql, params);
    }

    public int delete(String sql, List<Object> params) {
        return update(sql, params);
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
}
