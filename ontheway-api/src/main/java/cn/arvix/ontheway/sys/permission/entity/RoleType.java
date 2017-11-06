/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package cn.arvix.ontheway.sys.permission.entity;

/**
 * 授权类型
 */
public enum RoleType {

    saas("saas"), normal("普通");

    private final String info;

    private RoleType(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
