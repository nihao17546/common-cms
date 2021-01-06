package com.appcnd.common.cms.manager.pojo.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @author nihao 2021/01/06
 */
@Data
public class DbConfig implements Serializable {
    private MainDbConfig main;
    private List<FollowDbConfig> follows;
}
