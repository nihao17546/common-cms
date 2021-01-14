<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>文档</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <link rel="stylesheet" href="${contextPath}/drake.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <script src="${contextPath}/showdown.min.js"></script>
    <style>
        #app {
            padding-left: 60px;
            padding-right: 60px;
            padding-top: 30px;
            padding-bottom: 30px;
        }
    </style>
</head>
<body>

<div id="app">
    <el-tabs tab-position="left" v-model="active">
        <el-tab-pane label="快速开始" name="start">
            <div v-html="start"></div>
        </el-tab-pane>
        <el-tab-pane label="编码配置" name="code">
            <div v-html="code"></div>
        </el-tab-pane>
    </el-tabs>
</div>

<script>
    function getParam(name) {
        var reg = new RegExp("[^\?&]?" + encodeURI(name) + "=[^&]+");
        var arr = window.location.search.match(reg);
        if (arr != null) {
            return decodeURI(arr[0].substring(arr[0].search("=") + 1));
        }
        return "";
    }
    new Vue({
        name: 'demo',
        el: '#app',
        data() {
            return {
                active: null,
                start: '',
                code: ''
            }
        },
        methods: {

        },
        mounted() {
            let actives = ['start','code','show']
            let active = getParam('active')
            if (active && actives.indexOf(active) > -1) {
                this.active = active
            } else {
                this.active = 'start'
            }
            this.start = new showdown.Converter().makeHtml('# 快速开始\n' +
                    '#### 添加配置表\n' +
                    '~~~sql\n' +
                    'CREATE TABLE `tb_meta_config` (\n' +
                    '  `id` bigint(20) NOT NULL AUTO_INCREMENT,\n' +
                    '  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT \'\' COMMENT \'配置名称\',\n' +
                    '  `db_name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT \'忽略\',\n' +
                    '  `config` text COLLATE utf8_unicode_ci NOT NULL COMMENT \'配置数据\',\n' +
                    '  `created_at` datetime DEFAULT NULL,\n' +
                    '  `updated_at` datetime DEFAULT NULL,\n' +
                    '  PRIMARY KEY (`id`),\n' +
                    '  UNIQUE KEY `unique_name` (`name`)\n' +
                    ') ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT=\'项目元配置\';\n' +
                    '~~~\n' +
                    '#### 引入\n' +
                    '在Springboot项目中引入依赖\n' +
                    '~~~xml\n' +
                    '<dependency>\n' +
                    '  <groupId>com.appcnd</groupId>\n' +
                    '  <artifactId>common-cms-starter</artifactId>\n' +
                    '  <version>1.0.0-SNAPSHOT</version>\n' +
                    '</dependency>\n' +
                    '~~~\n' +
                    '#### Springboot配置\n' +
                    '~~~properties\n' +
                    '# 指定访问路径前缀（必须配置）\n' +
                    'common.cms.web.url=/cms\n' +
                    '\n' +
                    '# 配置管理后台登录账号，默认root\n' +
                    'common.cms.manager.loginname=root\n' +
                    '# 配置管理后台登录密码，默认123456\n' +
                    'common.cms.manager.password=123456\n' +
                    '\n' +
                    '# 数据源相关配置，不配默认使用Spring上下文中的数据源\n' +
                    '# 数据源连接池等相关配置参考druid\n' +
                    'common.cms.db.url=jdbc:mysql://127.0.0.1:3306/test?allowMultiQueries=true&useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull&serverTimezone=Asia/Shanghai&allowMultiQueries=true\n' +
                    'common.cms.db.username=root\n' +
                    'common.cms.db.password=123456\n' +
                    '\n' +
                    '# 如涉及文件上传需设置七牛相关配置，目前暂支持七牛\n' +
                    '# 七牛ak\n' +
                    'common.cms.qi.niu.ak=ak\n' +
                    '# 七牛sk\n' +
                    'common.cms.qi.niu.sk=sk\n' +
                    '# 七牛桶名称\n' +
                    'common.cms.qi.niu.bucket=bucket\n' +
                    '# 七牛桶绑定的域名\n' +
                    'common.cms.qi.niu.host=host\n' +
                    '\n' +
                    '~~~\n' +
                    '#### 项目配置\n' +
                    '有两种配置方式，编码方式和可视化配置方式\n' +
                    '* 编码配置  \n' +
                    '参见编码配置\n' +
                    '* 可视化配置  \n' +
                    '可视化配置需登录管理后台，以以上配置为例，若项目访问路径为：\n' +
                    'http://127.0.0.1:8080/demo，那么后台管理访问路径为：\n' +
                    'http://127.0.0.1:8080/demo/cms/manager/index.html')
            this.code = new showdown.Converter().makeHtml('# 编码配置\n ' +
                    '---\n' +
                    '## 目录\n' +
                    '1. [总配置](#h1)\n' +
                    '2. [新增/编辑表单](#h2)\n' +
                    '3. [主表配置](#h3)\n' +
                    '4. [从表配置](#h4)\n' +
                    '\n' +
                    '---\n' +
                    'Demo  \n' +
                    '~~~sql\n' +
                    'CREATE TABLE `test`.`tb_main` (\n' +
                    '  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,\n' +
                    '  `name` varchar(50) DEFAULT NULL,\n' +
                    '  `type` int(1) DEFAULT NULL,\n' +
                    '  `pic` varchar(200) DEFAULT NULL,\n' +
                    '  `status` int(1) DEFAULT NULL,\n' +
                    '  `city_id` int(1) DEFAULT NULL,\n' +
                    '  `time` datetime DEFAULT NULL,\n' +
                    '  `is_disable` tinyint(1) NOT NULL DEFAULT \'0\',\n' +
                    '  PRIMARY KEY (`id`)\n' +
                    ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n' +
                    'CREATE TABLE `test`.`tb_city` (\n' +
                    '  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,\n' +
                    '  `name` varchar(50) DEFAULT NULL,\n' +
                    '  PRIMARY KEY (`id`)\n' +
                    ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n' +
                    'CREATE TABLE `test`.`tb_follow` (\n' +
                    '  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,\n' +
                    '  `main_id` int(11) DEFAULT NULL,\n' +
                    '  `f_name` varchar(200) DEFAULT NULL,\n' +
                    '  `url` varchar(300) DEFAULT NULL,\n' +
                    '  `time` datetime DEFAULT NULL,\n' +
                    '  `status` int(2) DEFAULT NULL,\n' +
                    '  PRIMARY KEY (`id`)\n' +
                    ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n' +
                    '~~~\n' +
                    '\n' +
                    '~~~Java\n' +
                    'class Test {\n' +
                    '        @Test\n' +
                    '        public void test01() {\n' +
                    '            /** 配置从表tb_follow */\n' +
                    '            FollowTable followTable = FollowTable.builder().bottomName("从表").relateKey("id").parentKey("main_id").deleteBtn(true).addBtn(true).editBtn(true)\n' +
                    '                    .select(\n' +
                    '                            Select.builder().schema("test").table("tb_follow").primaryKey("id")\n' +
                    '                                    .tableColumns(\n' +
                    '                                            TableColumn.builder().key("f_name").label("从表f_name").build(),\n' +
                    '                                            TableColumn.builder().key("url").label("从表链接")\n' +
                    '                                                    .formatter(\n' +
                    '                                                            Formatter.url().build()\n' +
                    '                                                    )\n' +
                    '                                                    .build(),\n' +
                    '                                            TableColumn.builder().key("time").label("从表时间").build(), \n' +
                    '                                            TableColumn.builder().key("status").label("从表状态")\n' +
                    '                                                    .formatter(\n' +
                    '                                                            Formatter.text().kv("0","无效").kv("1","有效").build()\n' +
                    '                                                    )\n' +
                    '                                                    .build()\n' +
                    '                                    )\n' +
                    '                                    .build()\n' +
                    '                    )\n' +
                    '                    .addForm(\n' +
                    '                            AddForm.builder().schema("test").table("tb_follow").primaryKey("id")\n' +
                    '                                    .elements(\n' +
                    '                                            AddElement.input().key("f_name").label("从表f_name").maxlength(10)\n' +
                    '                                                    .rule(\n' +
                    '                                                            FormRule.builder().required(true).build()\n' +
                    '                                                    )\n' +
                    '                                                    .build(),\n' +
                    '                                            AddElement.input().key("url").label("链接").placeholder("请输入url链接")\n' +
                    '                                                    .rule(\n' +
                    '                                                            FormRule.builder().message("请输入正确链接")\n' +
                    '                                                                    .regular("^(?:([A-Za-z]+):)?(\\\\/{0,3})([0-9.\\\\-A-Za-z]+)(?::(\\\\d+))?(?:\\\\/([^?#]*))?(?:\\\\?([^#]*))?(?:#(.*))?$").build()\n' +
                    '                                                    )\n' +
                    '                                                    .build(),\n' +
                    '                                            AddElement.datetime().key("time").label("时间").to(java.util.Date.class).build(),\n' +
                    '                                            AddElement.radio().key("status").label("状态").radio("0","无效").radio("1","有效").build()\n' +
                    '                                    )\n' +
                    '                                    .build()\n' +
                    '                    )\n' +
                    '                    .build();\n' +
                    '            /** 配置主表tb_main */\n' +
                    '            Table table = Table.builder().pagination(true).defaultSortColumn("time").defaultOrder("desc")\n' +
                    '                    .select(\n' +
                    '                            Select.builder().schema("test").table("tb_main").primaryKey("id")\n' +
                    '                                    .tableColumns(\n' +
                    '                                            TableColumn.builder().key("name").label("主表name").build(),\n' +
                    '                                            TableColumn.builder().key("type").label("类型")\n' +
                    '                                                    .formatter(\n' +
                    '                                                            Formatter.text().kv("0","类型0").kv("1","类型1").kv("2","类型2").kv("3","类型3").build()\n' +
                    '                                                    )\n' +
                    '                                                    .build(),\n' +
                    '                                            TableColumn.builder().key("pic").label("图片").formatter(Formatter.pic().build()).build(),\n' +
                    '                                            TableColumn.builder().key("status").label("状态")\n' +
                    '                                                    .formatter(\n' +
                    '                                                            Formatter.switcher().active("开","1").inactive("关", "0").build()\n' +
                    '                                                    )\n' +
                    '                                                    .build(),\n' +
                    '                                            TableColumn.builder().key("time").label("创建时间").sortable(true).build()\n' +
                    '                                    )\n' +
                    '                                    .searchElements(\n' +
                    '                                            SearchElement.inputLike().key("name").label("主表name").build(),\n' +
                    '                                            SearchElement.select().key("type").label("类型").option("0","类型0")\n' +
                    '                                                    .option("1","类型1").option("2","类型2").option("3","类型3")\n' +
                    '                                                    .defaultValue(0)\n' +
                    '                                                    .build(),\n' +
                    '                                            SearchElement.selectRemote().key("city_id").label("城市").schema("test").table("tb_city").keyColumn("id").valueColumn("name").build(),\n' +
                    '                                            SearchElement.datetimePickerBt().key("time").label("创建时间").build()\n' +
                    '                                    )\n' +
                    '                                    .leftJoins(\n' +
                    '                                            SelectLeftJoin.builder().table("tb_city").relateKey("id").parentKey("city_id")\n' +
                    '                                                    .tableColumns(\n' +
                    '                                                            TableColumn.builder().key("name").label("城市").build()\n' +
                    '                                                    )\n' +
                    '                                                    .build()\n' +
                    '                                    )\n' +
                    '                                    .wheres(\n' +
                    '                                            Where.eq().key("is_disable").value(0).build()\n' +
                    '                                    )\n' +
                    '                                    .build()\n' +
                    '                    )\n' +
                    '                    .build();\n' +
                    '            /** 配置主表新增/编辑表单 */\n' +
                    '            AddForm addForm = AddForm.builder().schema("test").table("tb_main").primaryKey("id").width(80)\n' +
                    '                    .uniqueColumns(\n' +
                    '                            UniqueColumn.builder().toast("同一类型，名称不能重复").columns(Arrays.asList("name","type")).build()\n' +
                    '                    )\n' +
                    '                    .elements(\n' +
                    '                            AddElement.input().key("name").label("名称").rule(FormRule.builder().required(true).build()).build(),\n' +
                    '                            AddElement.select().key("type").label("类型").canEdit(false).option("0","类型0").option("1","类型1")\n' +
                    '                                    .option("2","类型2").option("3","类型3").rule(FormRule.builder().required(true).build()).build(),\n' +
                    '                            AddElement.uploadPic().key("pic").label("图片").acceptType(".png,.jpg").build(),\n' +
                    '                            AddElement.radio().key("status").label("状态").radio("0","关").radio("1","开")\n' +
                    '                                    .rule(FormRule.builder().required(true).build()).build(),\n' +
                    '                            AddElement.selectRemote().key("city_id").label("城市").schema("test").table("tb_city").keyColumn("id").valueColumn("name").build(),\n' +
                    '                            AddElement.createDateTime().key("time").build()\n' +
                    '                    )\n' +
                    '                    .build();\n' +
                    '            /** 总配置 */\n' +
                    '            ConfigEntity configEntity = ConfigEntity.builder().title("测试demo").addBtn(true).deleteBtn(true).editBtn(true)\n' +
                    '                    .addForm(addForm)\n' +
                    '                    .table(table)\n' +
                    '                    .followTables(followTable)\n' +
                    '                    .build();\n' +
                    '            \n' +
                    '            /** 打印配置json */\n' +
                    '            /** 将此字符串添加到配置表tb_meta_config的config字段 */\n' +
                    '            System.out.println(configEntity);\n' +
                    '            /** 指定配置名称，将配置名称添加到tb_meta_config的name字段 */\n' +
                    '            String name = "配置名称";\n' +
                    '            /** 解析配置名称，例如解析结果是：12a7a9141ed033f86b50a74e6519787b，\n' +
                    '             *  项目的访问路径是：http://127.0.0.1:8080/demo\n' +
                    '             *  配置common.cms.web.url为：/cms\n' +
                    '             *  那么访问地址为：http://127.0.0.1:8080/demo/cms/web/12a7a9141ed033f86b50a74e6519787b.html\n' +
                    '            */\n' +
                    '            System.out.println(DesUtil.encrypt(name));\n' +
                    '        }\n' +
                    '}\n' +
                    '~~~\n' +
                    '\n' +
                    '---\n' +
                    '\n' +
                    '### <a name="h1">1 总配置</a>\n' +
                    'com.appcnd.common.cms.entity.ConfigEntity\n' +
                    '\n' +
                    '| 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '| :------| :------ | :------ | :------ | :------ |\n' +
                    '| title | String | 是 |  | 页面标题 |\n' +
                    '| addBtn | Boolean | 否 | false | 是否允许新增 |\n' +
                    '| editBtn | Boolean | 否 | false | 是否允许编辑 |\n' +
                    '| deleteBtn | Boolean | 否 | false | 是否允许删除 |\n' +
                    '| addForm | [AddForm](#h2) | 否 |  | 新增/编辑表单 |\n' +
                    '| table | [Table](#h3) | 否 |  | 主表配置 |\n' +
                    '| followTables | [[FollowTable](#h4)] | 否 |  | 从表配置 |\n' +
                    '\n' +
                    '### <a name="h2">2 新增/编辑表单</a>\n' +
                    'com.appcnd.common.cms.entity.form.add.AddForm\n' +
                    '\n' +
                    '| 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '| :------| :------ | :------ | :------ | :------ |\n' +
                    '| schema | String | 是 |  | 数据库 |\n' +
                    '| table | String | 是 |  | 数据库表 |\n' +
                    '| primaryKey | String | 是 |  | 主键（必须int且自增类型） |\n' +
                    '| width | Integer | 否 | 50 | 前端表单弹窗宽度（%） |\n' +
                    '| elements | [[AddElement](#aa)] | 是 |  | 表单字段|\n' +
                    '| uniqueColumns | [[UniqueColumn](#bb)] | 否 |  | 唯一键组合) |\n' +
                    ' \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '#### <a name="aa">2.1 新增/编辑表单字段</a>\n' +
                    '* [普通文本](#a)\n' +
                    '* [下拉选择框](#b)\n' +
                    '* [远程下拉选择框](#c)\n' +
                    '* [单选框](#e)\n' +
                    '* [计数器](#f)\n' +
                    '* [日期选择器（yyyy-MM-dd）](#g)\n' +
                    '* [日期时间选择器（yyyy-MM-dd HH:mm:ss）](#h)\n' +
                    '* [时间选择器](#i)\n' +
                    '* [图片上传](#j)\n' +
                    '* [创建时间](#k)\n' +
                    '* [更新时间](#l)\n' +
                    '* [富文本](#m)\n' +
                    '\n' +
                    '<a name="a">普通文本：com.appcnd.common.cms.entity.form.add.AddInput</a>\n' +
                    ' \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 输入框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | type | String | 否 | text | 类型（text：普通单行 / textarea：多行） |\n' +
                    '  | maxlength | Integer | 否 |  | 最大输入长度 |\n' +
                    '  | minlength | Integer | 否 |  | 最小输入长度 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    ' \n' +
                    '---------------------------------------\n' +
                    '<a name="b">下拉选择框：com.appcnd.common.cms.entity.form.add.AddSelect</a>\n' +
                    ' \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 输入框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | options | [[Option](#option)] | 是 |  | 选项 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    ' \n' +
                    '---------------------------------------\n' +
                    '<a name="c">远程下拉选择框（选项数据来源数据库） ：com.appcnd.common.cms.entity.form.add.AddSelectRemote</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | schema | String | 否 | AddForm.schema | 远程数据表所在库 |\n' +
                    '  | table | String | 是 |  | 远程数据表名 |\n' +
                    '  | keyColumn | String | 是 |  | 键字段|\n' +
                    '  | valueColumn | String | 是 |  | 值字段 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="e">单选框：com.appcnd.common.cms.entity.form.add.AddRadio</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | radios | [[Option](#option)] | 是 |  | 选项 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="f">计数器：com.appcnd.common.cms.entity.form.add.AddInputNumber</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | min | Number | 否 |  | 计数器允许的最小值 |\n' +
                    '  | max | Number | 否 |  | 计数器允许的最大值 |\n' +
                    '  | precision | Number | 否 |  | 数值精度 |\n' +
                    '  | step | Number | 否 |  | 计数器步长 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="g">日期选择器（yyyy-MM-dd）：com.appcnd.common.cms.entity.form.add.AddDatePicker</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | to | Class | 是 |  | 转换格式（String.class, java.sql.Date.class） |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="h">日期时间选择器（yyyy-MM-dd HH:mm:ss）：com.appcnd.common.cms.entity.form.add.AddDateTimePicker</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | to | Class | 是 |  | 转换格式（String.class, Long.class, java.util.Date.class, java.sql.Timestamp.class） |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="i">时间选择器：com.appcnd.common.cms.entity.form.add.AddTimePicker</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 100% | 宽度（单位：px） |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | start | String | 否 | 00:00 | 开始时间 |\n' +
                    '  | end | String | 否 | 23:59 | 结束时间 |\n' +
                    '  | step | String | 否 | 00:30 | 间隔时间 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="j">图片上传：com.appcnd.common.cms.entity.form.add.AddUploadPic</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | acceptType | String | 否 |  | 图片后缀类型(例：".jpg,.PNG"，多个使用逗号分隔) |\n' +
                    '  | limitSize | Long | 否 |  | 图片大小限制，单位：字节 |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  | canEdit | Boolean | 否 | true | 是否可以编辑 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="k">创建时间：com.appcnd.common.cms.entity.form.add.AddCreateDateTime</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="l">更新时间：com.appcnd.common.cms.entity.form.add.AddUpdateDateTime</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="m">富文本：com.appcnd.common.cms.entity.form.add.AddRich</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | maxlength | Integer | 否 |  | 最大输入长度 |\n' +
                    '  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="option">选项：com.appcnd.common.cms.entity.form.Option</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | value | String | 是 |  | 选项的值 |\n' +
                    '  | label | String | 是 |  | 选项的标签 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="FormRule">表单校验规则：com.appcnd.common.cms.entity.form.add.FormRule</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | required | Boolean | 否 | false | 是否必须 |\n' +
                    '  | regular | String | 否 |  | 正则表达式 |\n' +
                    '  | message | String | 否 |  | 校验失败提示 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '#### <a name="bb">2.2 唯一键组合</a>\n' +
                    'com.appcnd.common.cms.entity.form.add.UniqueColumn\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | toast | String | 是 |  | 唯一键冲突前端提示文案 |\n' +
                    '  | columns | [String] | 是 |  | 唯一字段组合 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '### <a name="h3">3 主表配置</a>\n' +
                    'com.appcnd.common.cms.entity.table.Table\n' +
                    '\n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | pagination | Boolean | 否 | false | 是否分页 |\n' +
                    '  | defaultSortColumn | String | 否 |  | 默认排序字段 |\n' +
                    '  | defaultOrder | String | 否 | asc | 正序or倒序（asc/desc） |\n' +
                    '  | select | [[Select](#select)] | 是 |  | 数据库查询配置 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '#### 3.1 数据库查询配置\n' +
                    '<a name="select">com.appcnd.common.cms.entity.db.Select</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | schema | String | 是 |  | 数据库 |\n' +
                    '  | table | String | 是 |  | 数据库表 |\n' +
                    '  | primaryKey | String | 是 |  | 主键（必须int且自增类型） |\n' +
                    '  | tableColumns | [[TableColumn](#table_column)] | 是 |  | 表格列配置 |\n' +
                    '  | wheres | [[Where](#where)] | 否 |  | 默认查询sql条件配置 |\n' +
                    '  | leftJoins | [[SelectLeftJoin](#SelectLeftJoin)] | 否 |  | 左连接查询从表 |\n' +
                    '  | searchElements | [[SearchElement](#SearchElement)] | 否 |  | 查询表单配置 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="table_column">com.appcnd.common.cms.entity.table.TableColumn</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | sql查询字段 |\n' +
                    '  | label | String | 是 |  | 前端列头文案 |\n' +
                    '  | width | Integer | 否 |  | 前端列宽度 |\n' +
                    '  | formatter | [Formatter](#formmatter) | 否 |  | 格式化配置 |\n' +
                    '  | sortable | Boolean | 否 | false | 是否可以排序 |\n' +
                    '  | index | Integer | 否 | 999 | 顺序 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="where">com.appcnd.common.cms.entity.db.Where</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | sql查询字段 |\n' +
                    '  | type | JudgeType | 是 |  | sql查询判断类型 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '<a name="SelectLeftJoin">com.appcnd.common.cms.entity.db.SelectLeftJoin</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | schema | String | 否 | Select.schema | 数据库 |\n' +
                    '  | table | String | 是 |  | 数据库表 |\n' +
                    '  | relateKey | String | 是 |  | 当前从表关联字段 |\n' +
                    '  | parentKey | String | 是 |  | 主表关联字段 |\n' +
                    '  | tableColumns | [[TableColumn](#table_column)] | 是 |  | 表格列配置 |\n' +
                    '  | wheres | [[Where](#where)] | 否 |  | 默认查询sql条件配置 |\n' +
                    '  | searchElements | [[SearchElement](#SearchElement)] | 否 |  | 查询表单配置 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '##### <a name="SearchElement">3.1.1 查询表单配置</a>\n' +
                    'com.appcnd.common.cms.entity.form.search.SearchElement\n' +
                    '* [完全匹配文本输入框](#SearchInputEq)\n' +
                    '* [模糊匹配文本输入框](#SearchInputLike)\n' +
                    '* [查询下拉菜单](#SearchSelect)\n' +
                    '* [远程查询下拉菜单](#SearchSelectRemote)\n' +
                    '* [查询日期选择器（yyyy-MM-dd）](#SearchDatePickerBt)\n' +
                    '* [查询日期时间选择器（yyyy-MM-dd HH:mm:ss）](#SearchDatetimePickerBt)\n' +
                    '\n' +
                    '\n' +
                    '<a name="SearchInputEq">完全匹配文本输入框：com.appcnd.common.cms.entity.form.search.SearchInputEq</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 150 | 宽度（单位：px） |\n' +
                    '  | defaultValue | Object | 否 |  | 默认值 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="SearchInputLike">模糊匹配文本输入框：com.appcnd.common.cms.entity.form.search.SearchInputLike</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 150 | 宽度（单位：px） |\n' +
                    '  | defaultValue | Object | 否 |  | 默认值 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="SearchSelect">查询下拉菜单：com.appcnd.common.cms.entity.form.search.SearchSelect</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 150 | 宽度（单位：px） |\n' +
                    '  | options | [[Option](#option)] | 是 |  | 选项 |\n' +
                    '  | defaultValue | Object | 否 |  | 默认值 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="SearchSelectRemote">远程查询下拉菜单：com.appcnd.common.cms.entity.form.search.SearchSelectRemote</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 150 | 宽度（单位：px） |\n' +
                    '  | schema | String | 是 |  | 远程数据表所在库 |\n' +
                    '  | table | String | 是 |  | 远程数据表名 |\n' +
                    '  | keyColumn | String | 是 |  | 键字段|\n' +
                    '  | valueColumn | String | 是 |  | 值字段 |\n' +
                    '  | defaultValue | Object | 否 |  | 默认值 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="SearchDatePickerBt">查询日期选择器（yyyy-MM-dd）：com.appcnd.common.cms.entity.form.search.SearchDatePickerBt</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 150 | 宽度（单位：px） |\n' +
                    '  | defaultValue | Object | 否 |  | 默认值 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="SearchDatetimePickerBt">查询日期时间选择器（yyyy-MM-dd HH:mm:ss）：com.appcnd.common.cms.entity.form.search.SearchDatetimePickerBt</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | key | String | 是 |  | 数据库字段名 |\n' +
                    '  | label | String | 是 |  | 表单文案 |\n' +
                    '  | placeholder | String | 否 |  | 提示文案 |\n' +
                    '  | clearable | String | 否 | true | 是否可清空 |\n' +
                    '  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |\n' +
                    '  | width | Integer | 否 | 150 | 宽度（单位：px） |\n' +
                    '  | defaultValue | Object | 否 |  | 默认值 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '##### <a name="formmatter">3.1.2 格式化配置</a>\n' +
                    'com.appcnd.common.cms.entity.table.formatter.Formatter\n' +
                    '* [图片格式化](#FormatterPic)\n' +
                    '* [开关格式化](#FormatterSwitch)\n' +
                    '* [文本格式化](#FormatterText)\n' +
                    '* [链接格式化](#FormatterUrl)\n' +
                    '\n' +
                    '<a name="FormatterPic">图片格式化：com.appcnd.common.cms.entity.table.formatter.FormatterPic</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | width | Integer | 是 | 50 | 图片展示宽度，单位：px |\n' +
                    '  | height | Integer | 是 | 50 | 图片展示高度，单位：px |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="FormatterSwitch">开关格式化：com.appcnd.common.cms.entity.table.formatter.FormatterSwitch</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | active | [[Option](#option)] | 是 |  | 选中选项配置 |\n' +
                    '  | inactive | [[Option](#option)] | 是 |  | 未选中选项配置 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="FormatterText">文本格式化：com.appcnd.common.cms.entity.table.formatter.FormatterText</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | map | Map<String, String> | 是 |  | key-value配置 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '<a name="FormatterUrl">链接格式化：com.appcnd.common.cms.entity.table.formatter.FormatterUrl</a>\n' +
                    '  \n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | target | String | 否 | _blank | 链接打开方式 |\n' +
                    '  | text | String | 否 |  | 链接文案 |\n' +
                    '  \n' +
                    '---------------------------------------\n' +
                    '\n' +
                    '### <a name="h4">4 从表配置</a>\n' +
                    'com.appcnd.common.cms.entity.table.FollowTable\n' +
                    '\n' +
                    '  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |\n' +
                    '  | :------| :------ | :------ | :------ | :------ |\n' +
                    '  | pagination | Boolean | 否 | false | 是否分页 |\n' +
                    '  | defaultSortColumn | String | 否 |  | 默认排序字段 |\n' +
                    '  | defaultOrder | String | 否 | asc | 正序or倒序（asc/desc） |\n' +
                    '  | select | [[Select](#select)] | 是 |  | 数据库查询配置 |\n' +
                    '  | relateKey | String | 是 |  | 当前从表关联字段 |\n' +
                    '  | parentKey | String | 是 |  | 主表关联字段 |\n' +
                    '  | bottomName | String | 是 |  | 按钮文案 |\n' +
                    '  | addForm | [AddForm](#h2) | 否 |  | 新增/编辑表单 |\n' +
                    '  | addBtn | Boolean | 否 | false | 是否允许新增 |\n' +
                    '  | editBtn | Boolean | 否 | false | 是否允许编辑 |\n' +
                    '  | deleteBtn | Boolean | 否 | false | 是否允许删除 |\n' +
                    '\n')
        },
        created() {
        }
    })
</script>
</body>
</html>