package com.appcnd.common.cms.starter.util;

import org.apache.commons.beanutils.BeanUtils;

import java.lang.reflect.Field;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * created by nihao 2020/07/09
 *
 * @param <T>
 */
public class ResultSetMapper<T> {

    public List<Map<String,Object>> toMap(ResultSet rs) {
        try {
            if (rs != null) {
                List<Map<String,Object>> outputList = new ArrayList<>();
                ResultSetMetaData rsmd = rs.getMetaData();
                while (rs.next()) {
                    Map<String,Object> bean = new LinkedHashMap<>();
                    for (int _iterator = 0; _iterator < rsmd.getColumnCount(); _iterator++) {
                        String columnName = rsmd.getColumnLabel(_iterator + 1);
                        Object columnValue = rs.getObject(_iterator + 1);
                        bean.put(columnName, columnValue);
                    }
                    outputList.add(bean);
                }
                return outputList;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<T> toObject(ResultSet rs, Class<T> outputClass) {
        try {
            if (rs != null) {
                List<T> outputList = new ArrayList<T>();
                ResultSetMetaData rsmd = rs.getMetaData();
                Field[] fields = outputClass.getDeclaredFields();
                while (rs.next()) {
                    T bean = outputClass.newInstance();
                    for (int _iterator = 0; _iterator < rsmd.getColumnCount(); _iterator++) {
                        String columnName = rsmd.getColumnLabel(_iterator + 1);
                        Object columnValue = rs.getObject(_iterator + 1);
                        for (Field field : fields) {
                            if (field.getName().equalsIgnoreCase(columnName) && columnValue != null) {
                                BeanUtils.setProperty(bean, field.getName(), columnValue);
                                break;
                            }
                        }
                    }
                    outputList.add(bean);
                }
                return outputList;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}