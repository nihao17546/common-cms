package com.appcnd.common.cms.entity.constant;

/**
 * 判断方式
 * Created by nihao on 16/12/20.
 */
public enum JudgeType {
    /*
    相等
     */
    eq,

    /*
    大于
     */
    gt,

    /*
    小于
     */
    lt,

    /*
    大于等于
     */
    gteq,

    /*
    小于等于
     */
    lteq,

    /*
    in
     */
    in,

    /*
    like模糊查询
     */
    like,

    /*
    在...区间
     */
    bt,

    /*
    为空
     */
    isnull,

    /*
    不为空
     */
    isnotnull
}
