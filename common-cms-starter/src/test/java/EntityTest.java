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
import com.appcnd.common.cms.starter.util.DesUtil;

import java.util.Date;
import java.util.Arrays;

/**
 * created by nihao 2020/07/15
 */
public class EntityTest {
    public static void main(String[] args) throws Exception {
        ConfigEntity configEntity = ConfigEntity.builder()
                .addBtn(true)
                .deleteBtn(false)
                .editBtn(false)
                .title("测试")
                .table(Table.builder()
                        .pagination(true)
                        .select(Select.builder()
                                .schema("test")
                                .table("tb_main")
                                .primaryKey("id")
                                .tableColumns(
                                        TableColumn.builder().key("id").label("id").build(),
                                        TableColumn.builder().key("name").label("名称").build(),
                                        TableColumn.builder().key("type").label("类型").formatter(FormatterText.builder().kv("1","类型1").kv("2","类型2").build()).build(),
                                        TableColumn.builder().key("pic").label("图片").formatter(FormatterPic.builder().build()).build(),
                                        TableColumn.builder().key("status").label("状态").formatter(FormatterSwitch.builder().active("1","开启").inactive("1","关闭").build()).build(),
                                        TableColumn.builder().key("time").label("时间").build()
                                )
                                .leftJoins(
                                        SelectLeftJoin.builder().schema("test").table("tb_main_left").parentKey("main_id").relateKey("id")
                                                .tableColumns(
                                                        TableColumn.builder().key("name").prop("left_name").label("左连接名称").build()
                                                )
                                                .searchElements(
                                                        SearchElement.inputEq().key("id").label("城市id").build()
                                                ).wheres(
                                                        Where.gt().key("id").value(0).build()
                                        ).build()
                                )
                                .wheres(Where.gt().key("type").value(1).build())
                                .searchElements(
                                        SearchInputLike.builder().key("name").label("主表名称").build(),
                                        SearchSelectRemote.builder().schema("test").table("tb_city").keyColumn("id").valueColumn("name").key("city_id").label("城市").build()
                                ).build()
                        ).build())
                .addForm(AddForm.builder().schema("test").table("tb_main").primaryKey("id").width(100)
                        .elements(
                                AddElement.input().key("name").label("名称").canEdit(true).build(),
                                AddElement.datetime().key("time").label("时间").to(Date.class).build()
                        )
                        .build())
                .build();
        System.out.println(configEntity.json());
        System.out.println(DesUtil.encrypt(configEntity.getTitle()));
    }
}
