# 快速开始
#### 添加配置表
~~~sql
CREATE TABLE `tb_meta_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '配置名称',
  `db_name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '忽略',
  `config` text COLLATE utf8_unicode_ci NOT NULL COMMENT '配置数据',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='项目元配置';
~~~
#### 引入
在Springboot项目中引入依赖
~~~xml
<dependency>
  <groupId>com.appcnd</groupId>
  <artifactId>common-cms-starter</artifactId>
  <version>1.0.0-SNAPSHOT</version>
</dependency>
~~~
#### Springboot配置
~~~properties
# 指定访问路径前缀（必须配置）
common.cms.web.url=/cms

# 配置管理后台登录账号，默认root
common.cms.manager.loginname=root
# 配置管理后台登录密码，默认123456
common.cms.manager.password=123456

# 数据源相关配置，不配默认使用Spring上下文中的数据源
# 数据源连接池等相关配置参考druid
common.cms.db.url=jdbc:mysql://127.0.0.1:3306/test?allowMultiQueries=true&useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull&serverTimezone=Asia/Shanghai&allowMultiQueries=true
common.cms.db.username=root
common.cms.db.password=123456

# 如涉及文件上传需设置七牛相关配置，目前暂支持七牛
# 七牛ak
common.cms.qi.niu.ak=ak
# 七牛sk
common.cms.qi.niu.sk=sk
# 七牛桶名称
common.cms.qi.niu.bucket=bucket
# 七牛桶绑定的域名
common.cms.qi.niu.host=host

~~~
#### 项目配置
有两种配置方式，编码方式和可视化配置方式
* 编码配置  
参见编码配置
* 可视化配置  
可视化配置需登录管理后台，以以上配置为例，若项目访问路径为：
http://127.0.0.1:8080/demo，那么后台管理访问路径为：
http://127.0.0.1:8080/demo/cms/manager/index.html