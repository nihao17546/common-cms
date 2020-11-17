package com.appcnd.common.cms.starter.cache;

/**
 * @author nihao 2020/11/17
 */
public interface ResourceCache<K,V> {
    V get(K k);
    void set(K k, V v);
}
