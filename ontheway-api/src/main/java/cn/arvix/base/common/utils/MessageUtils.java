/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package cn.arvix.base.common.utils;

import org.springframework.context.MessageSource;

public class MessageUtils {

    private static MessageSource messageSource;

    /**
     * 根据消息键和参数 获取消息
     * 委托给spring messageSource
     *
     * @param code 消息键
     * @param args 参数
     * @return
     */
    public static String message(String code, Object... args) {
        if (messageSource == null) {
            messageSource = SpringUtils.getBean(MessageSource.class);
        }
        //目前未增加国际化消息提示
        return messageSource.getMessage(code, args, null);
    }

    /**
     * 根据消息键和参数 获取消息
     * 委托给spring messageSource
     *
     * @param code 消息键
     * @param args 参数
     * @return
     */
    public static String message(String code, Object[] args, String defaultMessage) {
        if (messageSource == null) {
            messageSource = SpringUtils.getBean(MessageSource.class);
        }
        //目前未增加国际化消息提示
        return messageSource.getMessage(code, args, defaultMessage, null);
    }

}
