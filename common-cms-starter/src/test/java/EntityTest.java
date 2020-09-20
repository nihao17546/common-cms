import com.appcnd.common.cms.entity.ConfigEntity;
import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.SelectLeftJoin;
import com.appcnd.common.cms.entity.db.WhereEq;
import com.appcnd.common.cms.entity.form.add.*;
import com.appcnd.common.cms.entity.form.search.SearchInputEq;
import com.appcnd.common.cms.entity.form.search.SearchInputLike;
import com.appcnd.common.cms.entity.table.FollowTable;
import com.appcnd.common.cms.entity.table.Table;
import com.appcnd.common.cms.entity.table.TableColumn;
import com.appcnd.common.cms.entity.table.formatter.FormatterText;
import com.appcnd.common.cms.starter.util.DesUtil;

import java.util.Arrays;

/**
 * created by nihao 2020/07/15
 */
public class EntityTest {
    public static void main(String[] args) throws Exception {
        ConfigEntity configEntity = ConfigEntity.builder()
                .addBtn(true)
                .deleteBtn(true)
                .editBtn(true)
                .title("云展馆3D标识配置")
                .table(Table.builder()
                        .pagination(true)
                        .select(Select.builder()
                                .schema("expo")
                                .table("fm_exhibition_dimension")
                                .primaryKey("id")
                                .tableColumns(
                                        TableColumn.builder().key("name").label("展区名称").build(),
                                        TableColumn.builder().key("type").label("类型").formatter(FormatterText.builder().kv("1","展区").kv("2","展厅").build()).build(),
                                        TableColumn.builder().key("dimension").label("展区三维标识").build()
                                )
                                .wheres(WhereEq.builder().key("type").value(1).build())
                                .searchElements(
                                        SearchInputLike.builder().key("name").label("展区名称").build(),
                                        SearchInputEq.builder().key("dimension").label("展区三维标识").build()
                                ).build()
                        ).build())
                .addForm(AddForm.builder()
                        .uniqueColumns(
                                UniqueColumn.builder().toast("标识重复").columns(Arrays.asList("type","dimension")).build(),
                                UniqueColumn.builder().toast("名称重复").columns(Arrays.asList("type","name")).build()
                        ).schema("expo")
                        .table("fm_exhibition_dimension")
                        .primaryKey("id")
                        .elements(
                                AddInput.builder().key("name").label("展区名称").maxlength(20).rule(FormRule.builder().required(true).build()).build(),
                                AddInput.builder().key("dimension").label("三维标识").maxlength(20).rule(FormRule.builder().required(true).build()).build(),
                                AddSelect.builder().key("type").label("类型").option("1","展区").rule(FormRule.builder().required(true).build()).build()
                        ).build())
                .followTables(FollowTable.builder()
                        .bottomName("查看展厅三维标识")
                        .parentKey("parent_id").relateKey("id")
                        .pagination(true)
                        .addBtn(true)
                        .deleteBtn(true)
                        .editBtn(true)
                        .select(Select.builder()
                                .schema("expo")
                                .table("fm_exhibition_dimension")
                                .primaryKey("id")
                                .tableColumns(
                                        TableColumn.builder().key("name").label("展厅名称").build(),
                                        TableColumn.builder().key("type").label("类型").formatter(FormatterText.builder().kv("1","展区").kv("2","展厅").build()).build(),
                                        TableColumn.builder().key("dimension").label("展厅三维标识").build()
                                ).searchElements(
                                        SearchInputLike.builder().key("name").label("展厅名称").build(),
                                        SearchInputEq.builder().key("dimension").label("展厅三维标识").build()
                                ).leftJoins(
                                        SelectLeftJoin.builder()
                                                .schema("expo")
                                                .table("fm_exhibition_dimension")
                                                .parentKey("parent_id").relateKey("id")
                                                .tableColumns(
                                                        TableColumn.builder().key("name").prop("parent_name").label("所属展区").build()
                                                ).build()
                                ).build())
                        .addForm(AddForm.builder()
                                .uniqueColumns(
                                        UniqueColumn.builder().toast("标识重复").columns(Arrays.asList("type","dimension")).build(),
                                        UniqueColumn.builder().toast("名称重复").columns(Arrays.asList("type","name")).build()
                                ).schema("expo")
                                .table("fm_exhibition_dimension")
                                .primaryKey("id")
                                .elements(
                                        AddInput.builder().key("name").label("展厅名称").maxlength(20).rule(FormRule.builder().required(true).build()).build(),
                                        AddInput.builder().key("dimension").label("三维标识").maxlength(20).rule(FormRule.builder().required(true).build()).build(),
                                        AddSelect.builder().key("type").label("类型").option("2","展厅").rule(FormRule.builder().required(true).build()).build()
                                ).build())
                        .build())
                .build();
        System.out.println(configEntity.json());
        System.out.println(DesUtil.encrypt(configEntity.getTitle()));
    }
}
