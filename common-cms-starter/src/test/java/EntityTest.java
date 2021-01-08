import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.SelectLeftJoin;
import com.appcnd.common.cms.entity.db.Where;
import com.appcnd.common.cms.entity.db.WhereEq;
import com.appcnd.common.cms.entity.form.add.*;
import com.appcnd.common.cms.entity.form.search.SearchElement;
import com.appcnd.common.cms.entity.form.search.SearchInputEq;
import com.appcnd.common.cms.entity.form.search.SearchInputLike;
import com.appcnd.common.cms.entity.form.search.SearchSelectRemote;
import com.appcnd.common.cms.entity.table.FollowTable;
import com.appcnd.common.cms.entity.table.Table;
import com.appcnd.common.cms.entity.table.TableColumn;
import com.appcnd.common.cms.entity.table.formatter.FormatterPic;
import com.appcnd.common.cms.entity.table.formatter.FormatterSwitch;
import com.appcnd.common.cms.entity.table.formatter.FormatterText;
import com.appcnd.common.cms.entity.table.formatter.FormatterUrl;
import com.appcnd.common.cms.entity.util.DesUtil;

import java.util.Date;
import java.util.Arrays;

/**
 * created by nihao 2020/07/15
 */
public class EntityTest {
    public static void main(String[] args) throws Exception {
        Select select = Select.builder().schema("test").table("tb_main").primaryKey("id")
                .tableColumns(
                        TableColumn.builder().key("id").label("ID").build(),
                        TableColumn.builder().key("name").label("名称").build(),
                        TableColumn.builder().key("type").label("类型").formatter(FormatterText.builder().kv("1","类型1").kv("2","类型2").build()).build(),
                        TableColumn.builder().key("pic").label("图片").formatter(FormatterPic.builder().build()).build(),
                        TableColumn.builder().key("status").label("状态").formatter(FormatterSwitch.builder().active("开启","1").inactive("关闭","0").build()).build(),
                        TableColumn.builder().key("time").label("时间").sortable(true).build()
                ).wheres(
                        Where.gt().key("type").value(0).build()
                ).searchElements(
                        SearchSelectRemote.builder().key("city_id").label("城市").schema("test").table("tb_city").keyColumn("id").valueColumn("name").build()
                ).build();
        Table table = Table.builder().pagination(true).defaultSortColumn("id").defaultOrder("desc").select(select).build();
        AddForm addForm = AddForm.builder().schema("test").table("tb_main").primaryKey("id")
                .elements(
                        AddElement.input().key("name").label("名称").canEdit(false).rule(FormRule.builder().message("必填").required(true).build()).build(),
                        AddElement.select().key("type").label("类型").option("1","类型1").option("2","类型2").build(),
                        AddElement.uploadPic().key("pic").label("图片").build(),
                        AddElement.radio().key("status").label("状态").radio("0","关闭").radio("1","开启").build(),
                        AddElement.selectRemote().key("city_id").label("城市").schema("test").table("tb_city").keyColumn("id").valueColumn("name").build(),
                        AddElement.createDateTime().key("time").build(),
                        AddElement.rich().key("rich").label("内容").build()
                ).uniqueColumns(
                        UniqueColumn.builder().columns(Arrays.asList("name")).toast("名称不能重复").build()
                ).build();
        FollowTable followTable = FollowTable.builder().parentKey("main_id").relateKey("id").bottomName("从表").addBtn(true).deleteBtn(true).editBtn(true)
                .select(
                        Select.builder().schema("test").table("tb_follow").primaryKey("id")
                                .searchElements(
                                        SearchElement.inputLike().key("f_name").label("名称").build()
                                ).tableColumns(
                                        TableColumn.builder().key("id").label("ID").build(),
                                TableColumn.builder().key("f_name").label("名称").build(),
                                TableColumn.builder().key("url").label("链接").formatter(FormatterUrl.builder().build()).build(),
                                TableColumn.builder().key("time").label("时间").build()
                                ).build()
                ).addForm(
                        AddForm.builder().schema("test").table("tb_follow").primaryKey("id")
                                .elements(
                                        AddElement.input().key("f_name").label("名称").build(),
                                        AddElement.input().key("url").label("链接").build(),
                                        AddElement.datetime().key("time").label("时间").to(java.util.Date.class).build()
                                ).build()
                ).build();
        ConfigEntity configEntity = ConfigEntity.builder().title("测试").table(table).addBtn(true).deleteBtn(true).editBtn(true)
                .addForm(addForm).followTables(followTable).build();
        System.out.println(configEntity.json());


//        JSONObject jsonObject = new JSONObject();
//        jsonObject.put("a",1);
//        System.out.println(JSON.toJSONString(jsonObject));
//        ConfigEntity configEntity = ConfigEntity.builder()
//                .addBtn(true)
//                .deleteBtn(false)
//                .editBtn(false)
//                .title("测试")
//                .table(Table.builder()
//                        .pagination(true)
//                        .select(Select.builder()
//                                .schema("test")
//                                .table("tb_main")
//                                .primaryKey("id")
//                                .tableColumns(
//                                        TableColumn.builder().key("id").label("id").build(),
//                                        TableColumn.builder().key("name").label("名称").build(),
//                                        TableColumn.builder().key("type").label("类型").formatter(FormatterText.builder().kv("1","类型1").kv("2","类型2").build()).build(),
//                                        TableColumn.builder().key("pic").label("图片").formatter(FormatterPic.builder().build()).build(),
//                                        TableColumn.builder().key("status").label("状态").formatter(FormatterSwitch.builder().active("1","开启").inactive("1","关闭").build()).build(),
//                                        TableColumn.builder().key("time").label("时间").build()
//                                )
//                                .leftJoins(
//                                        SelectLeftJoin.builder().schema("test").table("tb_main_left").parentKey("main_id").relateKey("id")
//                                                .tableColumns(
//                                                        TableColumn.builder().key("name").prop("left_name").label("左连接名称").build()
//                                                )
//                                                .searchElements(
//                                                        SearchElement.inputEq().key("id").label("城市id").build()
//                                                ).wheres(
//                                                        Where.gt().key("id").value(0).build()
//                                        ).build()
//                                )
//                                .wheres(Where.gt().key("type").value(1).build())
//                                .searchElements(
//                                        SearchInputLike.builder().key("name").label("主表名称").build(),
//                                        SearchSelectRemote.builder().schema("test").table("tb_city").keyColumn("id").valueColumn("name").key("city_id").label("城市").build()
//                                ).build()
//                        ).build())
//                .addForm(AddForm.builder().schema("test").table("tb_main").primaryKey("id").width(100)
//                        .elements(
//                                AddElement.input().key("name").label("名称").canEdit(true).build(),
//                                AddElement.datetime().key("time").label("时间").to(Date.class).build()
//                        )
//                        .build())
//                .followTables(FollowTable.builder()
//                        .bottomName("从表按钮")
//                        .pagination(true)
//                        .addBtn(false)
//                        .editBtn(false)
//                        .deleteBtn(false)
//
//                        .build())
//                .build();
//        System.out.println(configEntity.json());
//        System.out.println(DesUtil.encrypt(configEntity.getTitle()));
    }
}
