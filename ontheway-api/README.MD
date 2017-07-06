#OnTheWay-API

##开发工具

需要集成Gradle version: 3.2
可以使用eclipse 或者 idea <br>
Gradle下载地址：<a href="https://gradle.org/install" target="_blank">https://gradle.org/install</a>

##系统配置

环境主要有默认,dev,prod等.把默认设置为生产环境.
Spring不同环境配置处理.
在vm加入参数指定添加的Spring resources 配置文件.该配置文件会覆盖application.properties中对应配置.
参数名为: -Dspring.profiles.active
例如vm加入参数 -Dspring.profiles.active=dev
则对应的增加配置文件名为: application-dev.properties

##项目启动

1、可直接使用 bootRun 启动（spring boot内嵌jetty <font style="color:red"> 使用tomcat内嵌启动会和shiro 某个jar冲突，具体原因未找到！！！</font>）。<br/>
2、使用Idea构建项目时，可添加JRebel热启动，在启动配置中添加tomcat启动，默认使用tomcat8.5。

##数据库

mysql version 5.6

###数据库创建

mysql db ddl
```
CREATE USER 'ontheway_user'@'localhost'  IDENTIFIED BY '!@#8787aseerdsf878sd@#!23!';
CREATE DATABASE IF NOT EXISTS `ontheway_db` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
GRANT ALL PRIVILEGES ON ontheway_db.* TO 'ontheway_user'@'localhost';
FLUSH PRIVILEGES;
```
上面代码创建的用户只允许本机访问<br>
数据库创建成功，启动项目会自动生成表结构并初始化关键数据

##redis

版本：3.2.1 ，可使用高版本<br/>
session、认证、权限、hibernate二级缓存需要使用redis，请使用默认端口，允许本机访问，目前没有添加密码。

##API

使用swagger2集成，具体API说明可见<a href="https://www.cc520.me/article.html?c=5&index=84" target="_blank">https://www.cc520.me/article.html?c=5&index=84</a>

###API说明

####移动端（IOS、Andriod）

使用无状态方式，基于token进行认证。可配置使用https

##项目目录介绍

`cn.arvix.base`包下为公共开发包,包含公共方法和系统基础操作（用户、角色等管理接口）<br>
`cn.arvix.base.common`包下为公共方法、工具类等，包含Exception、Repository、Service、Controller、权限等公共组件

##编码规范

1、请遵循Java编码规范<br/>
2、每个方法或接口上请注明当前方法作用，需要注意的逻辑，如果方法内部逻辑较为复杂，请一定加上实现过程说明

##其他说明
使用的公共代码，系统初始化时，自动创建一个用户部门，所有注册的用户都直接放入当前用户部门，便于公共的权限模块使用

##错误信息代码定义 
错误信息使用6位代码，并按顺序定义，放入 CommonErrorCode类 中
登陆信息模块使用000100 作为起始错误代码 按顺序依次排序
认证错误由000200 作为起始代码

 



