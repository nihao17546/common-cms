# 编码配置

---
## 目录
1. [总配置](#h1)
2. [新增/编辑表单](#h2)
3. [主表配置](#h3)
4. [从表配置](#h4)

---
Demo  
~~~sql
CREATE TABLE `test`.`tb_main` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `pic` varchar(200) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `city_id` int(1) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `is_disable` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `test`.`tb_city` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `test`.`tb_follow` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `main_id` int(11) DEFAULT NULL,
  `f_name` varchar(200) DEFAULT NULL,
  `url` varchar(300) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
~~~

~~~Java
class Test {
        @Test
        public void test01() {
            /** 配置从表tb_follow */
            FollowTable followTable = FollowTable.builder().bottomName("从表").relateKey("id").parentKey("main_id").deleteBtn(true).addBtn(true).editBtn(true)
                    .select(
                            Select.builder().schema("test").table("tb_follow").primaryKey("id")
                                    .tableColumns(
                                            TableColumn.builder().key("f_name").label("从表f_name").build(),
                                            TableColumn.builder().key("url").label("从表链接")
                                                    .formatter(
                                                            Formatter.url().build()
                                                    )
                                                    .build(),
                                            TableColumn.builder().key("time").label("从表时间").build(), 
                                            TableColumn.builder().key("status").label("从表状态")
                                                    .formatter(
                                                            Formatter.text().kv("0","无效").kv("1","有效").build()
                                                    )
                                                    .build()
                                    )
                                    .build()
                    )
                    .addForm(
                            AddForm.builder().schema("test").table("tb_follow").primaryKey("id")
                                    .elements(
                                            AddElement.input().key("f_name").label("从表f_name").maxlength(10)
                                                    .rule(
                                                            FormRule.builder().required(true).build()
                                                    )
                                                    .build(),
                                            AddElement.input().key("url").label("链接").placeholder("请输入url链接")
                                                    .rule(
                                                            FormRule.builder().message("请输入正确链接")
                                                                    .regular("^(?:([A-Za-z]+):)?(\\/{0,3})([0-9.\\-A-Za-z]+)(?::(\\d+))?(?:\\/([^?#]*))?(?:\\?([^#]*))?(?:#(.*))?$").build()
                                                    )
                                                    .build(),
                                            AddElement.datetime().key("time").label("时间").to(java.util.Date.class).build(),
                                            AddElement.radio().key("status").label("状态").radio("0","无效").radio("1","有效").build()
                                    )
                                    .build()
                    )
                    .build();
            /** 配置主表tb_main */
            Table table = Table.builder().pagination(true).defaultSortColumn("time").defaultOrder("desc")
                    .select(
                            Select.builder().schema("test").table("tb_main").primaryKey("id")
                                    .tableColumns(
                                            TableColumn.builder().key("name").label("主表name").build(),
                                            TableColumn.builder().key("type").label("类型")
                                                    .formatter(
                                                            Formatter.text().kv("0","类型0").kv("1","类型1").kv("2","类型2").kv("3","类型3").build()
                                                    )
                                                    .build(),
                                            TableColumn.builder().key("pic").label("图片").formatter(Formatter.pic().build()).build(),
                                            TableColumn.builder().key("status").label("状态")
                                                    .formatter(
                                                            Formatter.switcher().active("开","1").inactive("关", "0").build()
                                                    )
                                                    .build(),
                                            TableColumn.builder().key("time").label("创建时间").sortable(true).build()
                                    )
                                    .searchElements(
                                            SearchElement.inputLike().key("name").label("主表name").build(),
                                            SearchElement.select().key("type").label("类型").option("0","类型0")
                                                    .option("1","类型1").option("2","类型2").option("3","类型3")
                                                    .defaultValue(0)
                                                    .build(),
                                            SearchElement.selectRemote().key("city_id").label("城市").schema("test").table("tb_city").keyColumn("id").valueColumn("name").build(),
                                            SearchElement.datetimePickerBt().key("time").label("创建时间").build()
                                    )
                                    .leftJoins(
                                            SelectLeftJoin.builder().table("tb_city").relateKey("id").parentKey("city_id")
                                                    .tableColumns(
                                                            TableColumn.builder().key("name").label("城市").build()
                                                    )
                                                    .build()
                                    )
                                    .wheres(
                                            Where.eq().key("is_disable").value(0).build()
                                    )
                                    .build()
                    )
                    .build();
            /** 配置主表新增/编辑表单 */
            AddForm addForm = AddForm.builder().schema("test").table("tb_main").primaryKey("id").width(80)
                    .uniqueColumns(
                            UniqueColumn.builder().toast("同一类型，名称不能重复").columns(Arrays.asList("name","type")).build()
                    )
                    .elements(
                            AddElement.input().key("name").label("名称").rule(FormRule.builder().required(true).build()).build(),
                            AddElement.select().key("type").label("类型").canEdit(false).option("0","类型0").option("1","类型1")
                                    .option("2","类型2").option("3","类型3").rule(FormRule.builder().required(true).build()).build(),
                            AddElement.uploadPic().key("pic").label("图片").acceptType(".png,.jpg").build(),
                            AddElement.radio().key("status").label("状态").radio("0","关").radio("1","开")
                                    .rule(FormRule.builder().required(true).build()).build(),
                            AddElement.selectRemote().key("city_id").label("城市").schema("test").table("tb_city").keyColumn("id").valueColumn("name").build(),
                            AddElement.createDateTime().key("time").build()
                    )
                    .build();
            /** 总配置 */
            ConfigEntity configEntity = ConfigEntity.builder().title("测试demo").addBtn(true).deleteBtn(true).editBtn(true)
                    .addForm(addForm)
                    .table(table)
                    .followTables(followTable)
                    .build();
            
            /** 打印配置json */
            /** 将此字符串添加到配置表tb_meta_config的config字段 */
            System.out.println(configEntity);
            /** 指定配置名称，将配置名称添加到tb_meta_config的name字段 */
            String name = "配置名称";
            /** 解析配置名称，例如解析结果是：12a7a9141ed033f86b50a74e6519787b，
             *  项目的访问路径是：http://127.0.0.1:8080/demo
             *  配置common.cms.web.url为：/cms
             *  那么访问地址为：http://127.0.0.1:8080/demo/cms/web/12a7a9141ed033f86b50a74e6519787b.html
            */
            System.out.println(DesUtil.encrypt(name));
        }
}
~~~

---

### <a name="h1">1 总配置</a>
com.appcnd.common.cms.entity.ConfigEntity

| 属性 | 类型 | 是否必须 | 默认值 | 说明 |
| :------| :------ | :------ | :------ | :------ |
| title | String | 是 |  | 页面标题 |
| addBtn | Boolean | 否 | false | 是否允许新增 |
| editBtn | Boolean | 否 | false | 是否允许编辑 |
| deleteBtn | Boolean | 否 | false | 是否允许删除 |
| addForm | [AddForm](#h2) | 否 |  | 新增/编辑表单 |
| table | [Table](#h3) | 否 |  | 主表配置 |
| followTables | [[FollowTable](#h4)] | 否 |  | 从表配置 |

### <a name="h2">2 新增/编辑表单</a>
com.appcnd.common.cms.entity.form.add.AddForm

| 属性 | 类型 | 是否必须 | 默认值 | 说明 |
| :------| :------ | :------ | :------ | :------ |
| schema | String | 是 |  | 数据库 |
| table | String | 是 |  | 数据库表 |
| primaryKey | String | 是 |  | 主键（必须int且自增类型） |
| width | Integer | 否 | 50 | 前端表单弹窗宽度（%） |
| elements | [[AddElement](#aa)] | 是 |  | 表单字段|
| uniqueColumns | [[UniqueColumn](#bb)] | 否 |  | 唯一键组合) |
 
---------------------------------------

#### <a name="aa">2.1 新增/编辑表单字段</a>
* [普通文本](#a)
* [下拉选择框](#b)
* [远程下拉选择框](#c)
* [单选框](#e)
* [计数器](#f)
* [日期选择器（yyyy-MM-dd）](#g)
* [日期时间选择器（yyyy-MM-dd HH:mm:ss）](#h)
* [时间选择器](#i)
* [图片上传](#j)
* [创建时间](#k)
* [更新时间](#l)
* [富文本](#m)

<a name="a">普通文本：com.appcnd.common.cms.entity.form.add.AddInput</a>
 
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 输入框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | type | String | 否 | text | 类型（text：普通单行 / textarea：多行） |
  | maxlength | Integer | 否 |  | 最大输入长度 |
  | minlength | Integer | 否 |  | 最小输入长度 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
 
---------------------------------------
<a name="b">下拉选择框：com.appcnd.common.cms.entity.form.add.AddSelect</a>
 
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 输入框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | options | [[Option](#option)] | 是 |  | 选项 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
 
---------------------------------------
<a name="c">远程下拉选择框（选项数据来源数据库） ：com.appcnd.common.cms.entity.form.add.AddSelectRemote</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | schema | String | 否 | AddForm.schema | 远程数据表所在库 |
  | table | String | 是 |  | 远程数据表名 |
  | keyColumn | String | 是 |  | 键字段|
  | valueColumn | String | 是 |  | 值字段 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="e">单选框：com.appcnd.common.cms.entity.form.add.AddRadio</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | radios | [[Option](#option)] | 是 |  | 选项 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="f">计数器：com.appcnd.common.cms.entity.form.add.AddInputNumber</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | min | Number | 否 |  | 计数器允许的最小值 |
  | max | Number | 否 |  | 计数器允许的最大值 |
  | precision | Number | 否 |  | 数值精度 |
  | step | Number | 否 |  | 计数器步长 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="g">日期选择器（yyyy-MM-dd）：com.appcnd.common.cms.entity.form.add.AddDatePicker</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | to | Class | 是 |  | 转换格式（String.class, java.sql.Date.class） |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="h">日期时间选择器（yyyy-MM-dd HH:mm:ss）：com.appcnd.common.cms.entity.form.add.AddDateTimePicker</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | to | Class | 是 |  | 转换格式（String.class, Long.class, java.util.Date.class, java.sql.Timestamp.class） |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="i">时间选择器：com.appcnd.common.cms.entity.form.add.AddTimePicker</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 100% | 宽度（单位：px） |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | start | String | 否 | 00:00 | 开始时间 |
  | end | String | 否 | 23:59 | 结束时间 |
  | step | String | 否 | 00:30 | 间隔时间 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="j">图片上传：com.appcnd.common.cms.entity.form.add.AddUploadPic</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | acceptType | String | 否 |  | 图片后缀类型(例：".jpg,.PNG"，多个使用逗号分隔) |
  | limitSize | Long | 否 |  | 图片大小限制，单位：字节 |
  | cut | Boolean | 否 | false | 是否裁剪 |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  | canEdit | Boolean | 否 | true | 是否可以编辑 |
  
---------------------------------------
<a name="k">创建时间：com.appcnd.common.cms.entity.form.add.AddCreateDateTime</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  
---------------------------------------
<a name="l">更新时间：com.appcnd.common.cms.entity.form.add.AddUpdateDateTime</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  
---------------------------------------
<a name="m">富文本：com.appcnd.common.cms.entity.form.add.AddRich</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | maxlength | Integer | 否 |  | 最大输入长度 |
  | rule | [FormRule](#FormRule) | 否 |  | 校验规则 |
  
---------------------------------------
<a name="option">选项：com.appcnd.common.cms.entity.form.Option</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | value | String | 是 |  | 选项的值 |
  | label | String | 是 |  | 选项的标签 |
  
---------------------------------------
<a name="FormRule">表单校验规则：com.appcnd.common.cms.entity.form.add.FormRule</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | required | Boolean | 否 | false | 是否必须 |
  | regular | String | 否 |  | 正则表达式 |
  | message | String | 否 |  | 校验失败提示 |
  
---------------------------------------

#### <a name="bb">2.2 唯一键组合</a>
com.appcnd.common.cms.entity.form.add.UniqueColumn
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | toast | String | 是 |  | 唯一键冲突前端提示文案 |
  | columns | [String] | 是 |  | 唯一字段组合 |
  
---------------------------------------

### <a name="h3">3 主表配置</a>
com.appcnd.common.cms.entity.table.Table

  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | pagination | Boolean | 否 | false | 是否分页 |
  | defaultSortColumn | String | 否 |  | 默认排序字段 |
  | defaultOrder | String | 否 | asc | 正序or倒序（asc/desc） |
  | select | [[Select](#select)] | 是 |  | 数据库查询配置 |
  | style | TableStyle | 否 | TableStyle.A | 展示样式（A-操作按钮在表格上方 B-操作按钮在表格中） |
  | optionWidth | Integer | 否 | 180 | 展示样式B时,操作列宽度 |
  
---------------------------------------

#### 3.1 数据库查询配置
<a name="select">com.appcnd.common.cms.entity.db.Select</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | schema | String | 是 |  | 数据库 |
  | table | String | 是 |  | 数据库表 |
  | primaryKey | String | 是 |  | 主键（必须int且自增类型） |
  | tableColumns | [[TableColumn](#table_column)] | 是 |  | 表格列配置 |
  | wheres | [[Where](#where)] | 否 |  | 默认查询sql条件配置 |
  | leftJoins | [[SelectLeftJoin](#SelectLeftJoin)] | 否 |  | 左连接查询从表 |
  | searchElements | [[SearchElement](#SearchElement)] | 否 |  | 查询表单配置 |
  
---------------------------------------
<a name="table_column">com.appcnd.common.cms.entity.table.TableColumn</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | sql查询字段 |
  | label | String | 是 |  | 前端列头文案 |
  | width | Integer | 否 |  | 前端列宽度 |
  | formatter | [Formatter](#formmatter) | 否 |  | 格式化配置 |
  | sortable | Boolean | 否 | false | 是否可以排序 |
  | index | Integer | 否 | 999 | 顺序 |
  
---------------------------------------
<a name="where">com.appcnd.common.cms.entity.db.Where</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | sql查询字段 |
  | type | JudgeType | 是 |  | sql查询判断类型 |
  
---------------------------------------
<a name="SelectLeftJoin">com.appcnd.common.cms.entity.db.SelectLeftJoin</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | schema | String | 否 | Select.schema | 数据库 |
  | table | String | 是 |  | 数据库表 |
  | relateKey | String | 是 |  | 当前从表关联字段 |
  | parentKey | String | 是 |  | 主表关联字段 |
  | tableColumns | [[TableColumn](#table_column)] | 是 |  | 表格列配置 |
  | wheres | [[Where](#where)] | 否 |  | 默认查询sql条件配置 |
  | searchElements | [[SearchElement](#SearchElement)] | 否 |  | 查询表单配置 |
  
---------------------------------------

##### <a name="SearchElement">3.1.1 查询表单配置</a>
com.appcnd.common.cms.entity.form.search.SearchElement
* [完全匹配文本输入框](#SearchInputEq)
* [模糊匹配文本输入框](#SearchInputLike)
* [查询下拉菜单](#SearchSelect)
* [远程查询下拉菜单](#SearchSelectRemote)
* [查询日期选择器（yyyy-MM-dd）](#SearchDatePickerBt)
* [查询日期时间选择器（yyyy-MM-dd HH:mm:ss）](#SearchDatetimePickerBt)


<a name="SearchInputEq">完全匹配文本输入框：com.appcnd.common.cms.entity.form.search.SearchInputEq</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 150 | 宽度（单位：px） |
  | defaultValue | Object | 否 |  | 默认值 |
  
---------------------------------------

<a name="SearchInputLike">模糊匹配文本输入框：com.appcnd.common.cms.entity.form.search.SearchInputLike</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 150 | 宽度（单位：px） |
  | defaultValue | Object | 否 |  | 默认值 |
  
---------------------------------------

<a name="SearchSelect">查询下拉菜单：com.appcnd.common.cms.entity.form.search.SearchSelect</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 150 | 宽度（单位：px） |
  | options | [[Option](#option)] | 是 |  | 选项 |
  | defaultValue | Object | 否 |  | 默认值 |
  
---------------------------------------

<a name="SearchSelectRemote">远程查询下拉菜单：com.appcnd.common.cms.entity.form.search.SearchSelectRemote</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 150 | 宽度（单位：px） |
  | schema | String | 是 |  | 远程数据表所在库 |
  | table | String | 是 |  | 远程数据表名 |
  | keyColumn | String | 是 |  | 键字段|
  | valueColumn | String | 是 |  | 值字段 |
  | defaultValue | Object | 否 |  | 默认值 |
  
---------------------------------------

<a name="SearchDatePickerBt">查询日期选择器（yyyy-MM-dd）：com.appcnd.common.cms.entity.form.search.SearchDatePickerBt</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 150 | 宽度（单位：px） |
  | defaultValue | Object | 否 |  | 默认值 |
  
---------------------------------------

<a name="SearchDatetimePickerBt">查询日期时间选择器（yyyy-MM-dd HH:mm:ss）：com.appcnd.common.cms.entity.form.search.SearchDatetimePickerBt</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | key | String | 是 |  | 数据库字段名 |
  | label | String | 是 |  | 表单文案 |
  | placeholder | String | 否 |  | 提示文案 |
  | clearable | String | 否 | true | 是否可清空 |
  | size | String | 否 | small | 多选框尺寸（medium / small / mini） |
  | width | Integer | 否 | 150 | 宽度（单位：px） |
  | defaultValue | Object | 否 |  | 默认值 |
  
---------------------------------------

##### <a name="formmatter">3.1.2 格式化配置</a>
com.appcnd.common.cms.entity.table.formatter.Formatter
* [图片格式化](#FormatterPic)
* [开关格式化](#FormatterSwitch)
* [文本格式化](#FormatterText)
* [链接格式化](#FormatterUrl)

<a name="FormatterPic">图片格式化：com.appcnd.common.cms.entity.table.formatter.FormatterPic</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | width | Integer | 是 | 50 | 图片展示宽度，单位：px |
  | height | Integer | 是 | 50 | 图片展示高度，单位：px |
  
---------------------------------------

<a name="FormatterSwitch">开关格式化：com.appcnd.common.cms.entity.table.formatter.FormatterSwitch</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | active | [[Option](#option)] | 是 |  | 选中选项配置 |
  | inactive | [[Option](#option)] | 是 |  | 未选中选项配置 |
  
---------------------------------------

<a name="FormatterText">文本格式化：com.appcnd.common.cms.entity.table.formatter.FormatterText</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | map | Map<String, String> | 是 |  | key-value配置 |
  
---------------------------------------

<a name="FormatterUrl">链接格式化：com.appcnd.common.cms.entity.table.formatter.FormatterUrl</a>
  
  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | target | String | 否 | _blank | 链接打开方式 |
  | text | String | 否 |  | 链接文案 |
  
---------------------------------------

### <a name="h4">4 从表配置</a>
com.appcnd.common.cms.entity.table.FollowTable

  | 属性 | 类型 | 是否必须 | 默认值 | 说明 |
  | :------| :------ | :------ | :------ | :------ |
  | pagination | Boolean | 否 | false | 是否分页 |
  | defaultSortColumn | String | 否 |  | 默认排序字段 |
  | defaultOrder | String | 否 | asc | 正序or倒序（asc/desc） |
  | select | [[Select](#select)] | 是 |  | 数据库查询配置 |
  | relateKey | String | 是 |  | 当前从表关联字段 |
  | parentKey | String | 是 |  | 主表关联字段 |
  | bottomName | String | 是 |  | 按钮文案 |
  | addForm | [AddForm](#h2) | 否 |  | 新增/编辑表单 |
  | addBtn | Boolean | 否 | false | 是否允许新增 |
  | editBtn | Boolean | 否 | false | 是否允许编辑 |
  | deleteBtn | Boolean | 否 | false | 是否允许删除 |
  | cascadingDelete | Boolean | 否 | false | 主表删除是否级联删除该从表关联的数据 |
  | style | TableStyle | 否 | TableStyle.A | 展示样式（A-操作按钮在表格上方 B-操作按钮在表格中） |
  | optionWidth | Integer | 否 | 180 | 展示样式B时,操作列宽度 |

