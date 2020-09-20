package com.appcnd.common.cms.entity.util;

import java.util.Collection;
import java.util.Map;

/**
 * created by nihao 2020/2/15
 */
public class CommonAssert {
    public static boolean isEmpty(Collection<?> collection) {
        return collection == null || collection.isEmpty();
    }

    public static boolean isEmpty(Map<?, ?> map) {
        return map == null || map.isEmpty();
    }

    public static boolean isEmpty(Object[] array) {
        return array == null || array.length == 0;
    }

    private static boolean containsText(CharSequence str) {
        int strLen = str.length();
        for(int i = 0; i < strLen; ++i) {
            if (!Character.isWhitespace(str.charAt(i))) {
                return true;
            }
        }
        return false;
    }

    public static void notEmpty(Map<?, ?> map, String message) {
        if (isEmpty(map)) {
            throw new IllegalArgumentException(message);
        }
    }

    public static boolean hasText(String str) {
        return str != null && !str.isEmpty() && containsText(str);
    }

    public static void hasText(String text, String message) {
        if (!hasText(text)) {
            throw new IllegalArgumentException(message);
        }
    }

    public static void notNull(Object object, String message) {
        if (object == null) {
            throw new IllegalArgumentException(message);
        }
    }

    public static void notEmpty(Object[] array, String message) {
        if (isEmpty(array)) {
            throw new IllegalArgumentException(message);
        }
    }

    public static void notEmpty(Collection<?> collection, String message) {
        if (isEmpty(collection)) {
            throw new IllegalArgumentException(message);
        }
    }

    public static void in(Object object, Collection<?> collection, String message) {
        if (object != null && collection != null && !collection.contains(object)) {
            throw new IllegalArgumentException(message);
        }
    }

    public static void in(Object object, Collection<?> collection) {
        StringBuilder sb = new StringBuilder(object.toString())
                .append(" 类型错误，类型要求[");
        int index = 0;
        for (Object obj : collection) {
            sb.append(obj.toString());
            if (++ index < collection.size()) {
                sb.append(" | ");
            }
            else {
                sb.append("]");
            }
        }
        in(object, collection, sb.toString());
    }
}
