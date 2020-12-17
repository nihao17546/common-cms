package com.appcnd.common.cms.manager.controller;

import com.appcnd.common.cms.entity.bottom.ExternalLinksBottom;
import com.appcnd.common.cms.entity.constant.*;
import com.appcnd.common.cms.entity.db.*;
import com.appcnd.common.cms.entity.form.add.*;
import com.appcnd.common.cms.entity.table.formatter.FormatterPic;
import com.appcnd.common.cms.entity.table.formatter.FormatterSwitch;
import com.appcnd.common.cms.entity.table.formatter.FormatterText;
import com.appcnd.common.cms.entity.table.formatter.FormatterUrl;
import com.appcnd.common.cms.manager.pojo.vo.HttpResult;
import com.appcnd.common.cms.manager.pojo.vo.TableVo;
import com.appcnd.common.cms.manager.service.IDbService;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author nihao 2019/10/19
 */
@RestController
@RequestMapping("/api")
public class ApiController {
    @Autowired
    private IDbService dbService;

    @RequestMapping(value = "/getTable", produces = "application/json;charset=UTF-8")
    public String getTable(@RequestParam String schema, @RequestParam String table) {
        TableVo tableVo = dbService.getTableByShow(schema, table);
        if (!"AUTO_INCREMENT".equalsIgnoreCase(tableVo.getPrimaryKeyExtra())) {
            return HttpResult.fail("只支持配置自增主键").json();
        }
        return HttpResult.success().pull("table", tableVo).json();
    }


    @RequestMapping(value = "/addElementTypes", produces = "application/json;charset=UTF-8")
    public String addElementTypes() {
        List<AddElementTypeModel> list = new ArrayList<>();

        list.add(new AddElementTypeModel("普通文本", AddInput.class, AddColumnType.COM, ElType.INPUT)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("options","schema","table","keyColumn","valueColumn","radios","min","max","precision","step",
                        "start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("下拉选择框", AddSelect.class, AddColumnType.COM, ElType.SELECT)
                .addRule("label", true, "请输入表单文案", "change")
                .addRule("options", true, "请添加选项", "change")
                .addHide("type","maxlength","minlength","schema","table","keyColumn","valueColumn","radios","min","max","precision","step",
                        "start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("远程下拉选择框", AddSelectRemote.class, AddColumnType.COM, ElType.SELECT)
                .addRule("label", true, "请输入表单文案", "change")
                .addRule("table", true, "请输入远程数据表名", "change")
                .addRule("keyColumn", true, "请输入键字段", "change")
                .addRule("valueColumn", true, "请输入值字段", "change")
                .addHide("type","maxlength","minlength","options","radios","min","max","precision","step",
                        "start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("单选框", AddRadio.class, AddColumnType.COM, ElType.RADIO)
                .addRule("label", true, "请输入表单文案", "change")
                .addRule("options", true, "请添加选项", "change")
                .addHide("placeholder","clearable","width","type","maxlength","minlength","schema","table","keyColumn","valueColumn"
                        ,"options","min","max","precision","step","start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("计数器", AddInputNumber.class, AddColumnType.COM, ElType.INPUT_NUMBER)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("placeholder","clearable","type","maxlength","minlength","options","schema","table","keyColumn","valueColumn","radios",
                        "start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("日期选择器（yyyy-MM-dd）", AddDatePicker.class, AddColumnType.COM, ElType.DATE_PICKER)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("type","maxlength","minlength","options","schema","table","keyColumn","valueColumn","radios",
                        "min","max","precision","step","start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("日期时间选择器（yyyy-MM-dd HH:mm:ss）", AddDateTimePicker.class, AddColumnType.COM, ElType.DATETIME_PICKER)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("type","maxlength","minlength","options","schema","table","keyColumn","valueColumn","radios",
                        "min","max","precision","step","start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("时间选择器", AddTimePicker.class, AddColumnType.COM, ElType.TIME_PICKER)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("type","maxlength","minlength","options","schema","table","keyColumn","valueColumn","radios",
                        "min","max","precision","step","acceptType","limitSize"));

        list.add(new AddElementTypeModel("图片上传", AddUploadPic.class, AddColumnType.COM, ElType.UPLOAD_PIC)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("clearable","size","width","type","maxlength","minlength","options","schema","table","keyColumn","valueColumn",
                        "radios","min","max","precision","step","start","end","timeStep"));

        list.add(new AddElementTypeModel("富文本", AddRich.class, AddColumnType.COM, ElType.RICH)
                .addRule("label", true, "请输入表单文案", "change")
                .addHide("clearable","size","width","type","minlength","canEdit","options","schema","table","keyColumn","valueColumn",
                        "radios","min","max","precision","step","start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("创建时间", AddCreateDateTime.class, AddColumnType.CREATE_DATETIME, ElType.DATETIME_PICKER)
                .addHide("label","placeholder","clearable","size","width","ruleRequired","ruleRegular","ruleMessage","type",
                        "maxlength","minlength","canEdit","options","schema","table","keyColumn","valueColumn","radios",
                        "min","max","precision","step","start","end","timeStep","acceptType","limitSize"));

        list.add(new AddElementTypeModel("更新时间", AddUpdateDateTime.class, AddColumnType.UPDATE_DATETIME, ElType.DATETIME_PICKER)
                .addHide("label","placeholder","clearable","size","width","ruleRequired","ruleRegular","ruleMessage","type",
                        "maxlength","minlength","canEdit","options","schema","table","keyColumn","valueColumn","radios",
                        "min","max","precision","step","start","end","timeStep","acceptType","limitSize"));

        return HttpResult.success().pull("list", list).json();
    }

    @RequestMapping(value = "/formatterTypes", produces = "application/json;charset=UTF-8")
    public String formatterTypes() {
        List<FormatterTypeModel> list = new ArrayList<>();

        list.add(new FormatterTypeModel("图片格式化", FormatterPic.class, FormatterType.PIC)
                .addHide("formatterSwitchActiveValue","formatterSwitchActiveLabel","formatterSwitchInactiveValue","formatterSwitchInactiveLabel",
                        "formatterTextMap","formatterUrlTarget","formatterUrlText"));

        list.add(new FormatterTypeModel("开关格式化", FormatterSwitch.class, FormatterType.SWITCH)
                .addHide("formatterPicWidth","formatterPicHeight","formatterTextMap","formatterUrlTarget","formatterUrlText"));

        list.add(new FormatterTypeModel("文本格式化", FormatterText.class, FormatterType.TEXT)
                .addHide("formatterPicWidth","formatterPicHeight",
                        "formatterSwitchActiveValue","formatterSwitchActiveLabel","formatterSwitchInactiveValue","formatterSwitchInactiveLabel",
                        "formatterUrlTarget","formatterUrlText"));

        list.add(new FormatterTypeModel("链接格式化", FormatterUrl.class, FormatterType.URL)
                .addHide("formatterPicWidth","formatterPicHeight","formatterTextMap",
                        "formatterSwitchActiveValue","formatterSwitchActiveLabel","formatterSwitchInactiveValue","formatterSwitchInactiveLabel"));

        return HttpResult.success().pull("list", list).json();
    }

    @RequestMapping(value = "/bottomTypes", produces = "application/json;charset=UTF-8")
    public String bottomTypes() {
        List<BottomTypeModel> list = new ArrayList<>();
        list.add(new BottomTypeModel("外链按钮", ExternalLinksBottom.class, BottomType.EXTERNAL_LINKS)
                .addShows("externalLinksBottomUrl", "externalLinksBottomParamFormDb", "externalLinksBottomParams"));
        return HttpResult.success().pull("list", list).json();
    }

    @RequestMapping(value = "/whereTypes", produces = "application/json;charset=UTF-8")
    public String whereTypes() {
        List<WhereTypeModel> list = new ArrayList<>();
        list.add(new WhereTypeModel("=", WhereEq.class, JudgeType.eq)
                .addShows("value")
                .addRule("value", true, "请输入", "change"));
        list.add(new WhereTypeModel("like", WhereLike.class, JudgeType.like)
                .addShows("value")
                .addRule("value", true, "请输入", "change"));
        list.add(new WhereTypeModel(">", WhereGt.class, JudgeType.gt)
                .addShows("value")
                .addRule("value", true, "请输入", "change"));
        list.add(new WhereTypeModel(">=", WhereGteq.class, JudgeType.gteq)
                .addShows("value")
                .addRule("value", true, "请输入", "change"));
        list.add(new WhereTypeModel("<", WhereLt.class, JudgeType.lt)
                .addShows("value")
                .addRule("value", true, "请输入", "change"));
        list.add(new WhereTypeModel("<=", WhereLteq.class, JudgeType.lteq)
                .addShows("value")
                .addRule("value", true, "请输入", "change"));
        list.add(new WhereTypeModel("<=", WhereBt.class, JudgeType.bt)
                .addShows("begin","end")
                .addRule("begin", true, "请输入", "change")
                .addRule("end", true, "请输入", "change"));
        list.add(new WhereTypeModel("in", WhereLteq.class, JudgeType.in)
                .addShows("values")
                .addRule("values", true, "请输入", "change"));
        return HttpResult.success().pull("list", list).json();
    }

    @Data
    public static class WhereTypeModel {
        private String name;
        private String className;
        private JudgeType type;
        private List<String> shows;
        // 校验规则
        private Map<String,List<Rule>> rules;

        public WhereTypeModel(String name, Class clazz, JudgeType type) {
            this.name = name;
            this.className = clazz.getName();
            this.type = type;
            this.shows = new ArrayList<>();
        }

        public WhereTypeModel addShows(String... keys) {
            for (String key : keys) {
                this.shows.add(key);
            }
            return this;
        }

        public WhereTypeModel addRule(String key, boolean required, String message, String trigger) {
            if (!this.rules.containsKey(key)) {
                this.rules.put(key, new ArrayList<>());
            }
            this.rules.get(key).add(new Rule(required, message, trigger));
            return this;
        }
    }

    @Data
    public static class BottomTypeModel {
        private String name;
        private String className;
        private BottomType type;
        private List<String> shows;

        public BottomTypeModel(String name, Class clazz, BottomType type) {
            this.name = name;
            this.className = clazz.getName();
            this.type = type;
            this.shows = new ArrayList<>();
        }

        public BottomTypeModel addShows(String... keys) {
            for (String key : keys) {
                this.shows.add(key);
            }
            return this;
        }
    }

    @Data
    public static class FormatterTypeModel {
        private String name;
        private String className;
        private FormatterType type;
        // 校验规则
        private Map<String,List<Rule>> rules;
        private List<String> hides;

        public FormatterTypeModel(String name, Class clazz, FormatterType type) {
            this.name = name;
            this.className = clazz.getName();
            this.type = type;
            this.rules = new HashMap<>();
            this.hides = new ArrayList<>();
        }

        public FormatterTypeModel addRule(String key, boolean required, String message, String trigger) {
            if (!this.rules.containsKey(key)) {
                this.rules.put(key, new ArrayList<>());
            }
            this.rules.get(key).add(new Rule(required, message, trigger));
            return this;
        }

        public FormatterTypeModel addHide(String... keys) {
            for (String key : keys) {
                this.hides.add(key);
            }
            return this;
        }
    }

    @Data
    public static class AddElementTypeModel {
        private String name;
        private String className;
        private AddColumnType columnType;
        private ElType elType;
        // 校验规则
        private Map<String,List<Rule>> rules;
        private List<String> hides;


        public AddElementTypeModel(String name, Class clazz, AddColumnType columnType, ElType elType) {
            this.name = name;
            this.className = clazz.getName();
            this.columnType = columnType;
            this.elType = elType;
            this.rules = new HashMap<>();
            this.hides = new ArrayList<>();
        }

        public AddElementTypeModel addRule(String key, boolean required, String message, String trigger) {
            if (!this.rules.containsKey(key)) {
                this.rules.put(key, new ArrayList<>());
            }
            this.rules.get(key).add(new Rule(required, message, trigger));
            return this;
        }

        public AddElementTypeModel addHide(String... keys) {
            for (String key : keys) {
                this.hides.add(key);
            }
            return this;
        }
    }

    @Data
    public static class Rule {
        private boolean required;
        private String message;
        private String trigger;

        public Rule(boolean required, String message, String trigger) {
            this.required = required;
            this.message = message;
            this.trigger = trigger;
        }
    }
}
