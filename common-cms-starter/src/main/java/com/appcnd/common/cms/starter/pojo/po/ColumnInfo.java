package com.appcnd.common.cms.starter.pojo.po;

/**
 * 表结构信息
 * Created by nihao on 16/12/20.
 */
public class ColumnInfo {
    private String COLUMN_NAME;
    private String ORDINAL_POSITION;
    private String COLUMN_DEFAULT;
    //YES,NO
    private String IS_NULLABLE;
    //bigint,varchar,datetime,,int,tinyint,text,date,mediumtext,decimal,char,double,timestamp
    private String DATA_TYPE;
    private String COLUMN_TYPE;
    //PRI,MUL
    private String COLUMN_KEY;
    //auto_increment
    private String EXTRA;
    private String COLUMN_COMMENT;

    public String getCOLUMN_NAME() {
        return COLUMN_NAME;
    }

    public void setCOLUMN_NAME(String COLUMN_NAME) {
        this.COLUMN_NAME = COLUMN_NAME;
    }

    public String getORDINAL_POSITION() {
        return ORDINAL_POSITION;
    }

    public void setORDINAL_POSITION(String ORDINAL_POSITION) {
        this.ORDINAL_POSITION = ORDINAL_POSITION;
    }

    public String getCOLUMN_DEFAULT() {
        return COLUMN_DEFAULT;
    }

    public void setCOLUMN_DEFAULT(String COLUMN_DEFAULT) {
        this.COLUMN_DEFAULT = COLUMN_DEFAULT;
    }

    public String getIS_NULLABLE() {
        return IS_NULLABLE;
    }

    public void setIS_NULLABLE(String IS_NULLABLE) {
        this.IS_NULLABLE = IS_NULLABLE;
    }

    public String getDATA_TYPE() {
        return DATA_TYPE;
    }

    public void setDATA_TYPE(String DATA_TYPE) {
        this.DATA_TYPE = DATA_TYPE;
    }

    public String getCOLUMN_TYPE() {
        return COLUMN_TYPE;
    }

    public void setCOLUMN_TYPE(String COLUMN_TYPE) {
        this.COLUMN_TYPE = COLUMN_TYPE;
    }

    public String getCOLUMN_KEY() {
        return COLUMN_KEY;
    }

    public void setCOLUMN_KEY(String COLUMN_KEY) {
        this.COLUMN_KEY = COLUMN_KEY;
    }

    public String getEXTRA() {
        return EXTRA;
    }

    public void setEXTRA(String EXTRA) {
        this.EXTRA = EXTRA;
    }

    public String getCOLUMN_COMMENT() {
        return COLUMN_COMMENT;
    }

    public void setCOLUMN_COMMENT(String COLUMN_COMMENT) {
        this.COLUMN_COMMENT = COLUMN_COMMENT;
    }
}
