package com.appcnd.common.cms.starter.util;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * @author nihao 2021/01/16
 */
@Data
@NoArgsConstructor
public class DbExecute implements Serializable {
    private String sql;
    private List<Object> params;


    @Builder
    public DbExecute(String sql, List<Object> params) {
        this.sql = sql;
        this.params = params;
    }
}
