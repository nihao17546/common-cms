package com.appcnd.common.cms.starter.controller;

import com.appcnd.common.cms.entity.db.Select;
import com.appcnd.common.cms.entity.db.SelectLeftJoin;
import com.appcnd.common.cms.entity.form.add.AddDatePicker;
import com.appcnd.common.cms.entity.form.add.AddDateTimePicker;
import com.appcnd.common.cms.entity.form.add.AddElement;
import com.appcnd.common.cms.entity.form.add.AddForm;
import com.appcnd.common.cms.entity.table.TableColumn;
import com.appcnd.common.cms.starter.pojo.db.ListParam;
import com.appcnd.common.cms.starter.pojo.param.*;
import com.appcnd.common.cms.starter.pojo.vo.ListVO;
import com.appcnd.common.cms.starter.properties.ServletProperties;
import com.appcnd.common.cms.starter.service.IWebService;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import com.appcnd.common.cms.starter.util.PageUtil;
import com.alibaba.fastjson.JSON;
import com.appcnd.common.cms.starter.pojo.param.TableListParam;
import com.appcnd.common.cms.starter.util.ConfigJsonUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author nihao 2019/10/20
 */
@RequestMapping("/web")
public class WebController extends BaseController {
    @Autowired
    private IWebService webService;
    @Autowired
    private ConfigJsonUtil configJsonUtil;
    @Autowired
    private ServletProperties servletProperties;

    @RequestMapping("/{key}/html")
    public void html(@PathVariable String key,
                     HttpServletResponse response,
                     HttpServletRequest request) throws IOException {
        response.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");
        String text = PageUtil.getPage(request, servletProperties.getUrl(), key);
        response.getWriter().write(text);
    }

    @RequestMapping("/{key}.html")
    public void index(@PathVariable String key,
                      HttpServletResponse response,
                      HttpServletRequest request) throws IOException {
        response.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");
        Cookie cookie = new Cookie("config_key", key);
        cookie.setPath("/");
        response.addCookie(cookie);
        String text = PageUtil.getPage(request, servletProperties.getUrl(), "index");
        response.getWriter().write(text);
    }

    @PostMapping(value = "/api/table/list", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String tableList(@RequestBody TableListParam tableListParam) throws ClassNotFoundException {
        Select select = configJsonUtil.parseSelect(tableListParam.getListJson());
        ListParam listParam = new ListParam();
        BeanUtils.copyProperties(select, listParam);
        if (!CollectionUtils.isEmpty(tableListParam.getParams())) {
            for (int i = tableListParam.getParams().size() -1; i >= 0; i --) {
                if (tableListParam.getParams().get(i).getValue() == null || "".equals(tableListParam.getParams().get(i).getValue())) {
                    tableListParam.getParams().remove(i);
                }
            }
            if (!CollectionUtils.isEmpty(tableListParam.getParams())) {
                listParam.setParams(tableListParam.getParams());
            }
        }
        listParam.setOrder(tableListParam.getOrder());
        listParam.setSortColumn(tableListParam.getSortColumn());
        listParam.setOrderAlias(tableListParam.getOrderAlias());
        if (tableListParam.getCurPage() != null && tableListParam.getPageSize() != null) {
            ListVO<Map<String,Object>> listVO = webService.getPagination(listParam, tableListParam.getCurPage(), tableListParam.getPageSize());
            return ok().pull(listVO).json();
        }
        List<Map<String,Object>> list = webService.getList(listParam);
        ListVO<Map<String, Object>> listVO = new ListVO<>(1, list.size());
        listVO.setTotalCount(list.size());
        listVO.setList(list);
        return ok().pull(listVO).json();
    }

    @PostMapping(value = "/api/add", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String add(@RequestBody AddParam addParam) throws ClassNotFoundException, ParseException {
        AddForm addForm = configJsonUtil.parseAddForm(addParam.getAddJson());
        for (AddElement addElement : addForm.getElements()) {
            Object value = addParam.getParams().get(addElement.getKey());
            if (value != null) {
                if (addElement instanceof AddDateTimePicker) {
                    AddDateTimePicker addDateTimePicker = (AddDateTimePicker) addElement;
                    if (addDateTimePicker.getTo() != String.class) {
                        DateFormat dateFormat = new SimpleDateFormat(addDateTimePicker.getFormat());
                        Date date = dateFormat.parse(value.toString());
                        if (addDateTimePicker.getTo() == Date.class) {
                            addParam.getParams().put(addElement.getKey(), date);
                        } else if (addDateTimePicker.getTo() == java.sql.Timestamp.class) {
                            addParam.getParams().put(addElement.getKey(), new java.sql.Timestamp(date.getTime()));
                        } else if (addDateTimePicker.getTo() == Long.class) {
                            addParam.getParams().put(addElement.getKey(), date.getTime());
                        }
                    } else {
                        addParam.getParams().put(addElement.getKey(), value.toString());
                    }
                } else if (addElement instanceof AddDatePicker) {
                    AddDatePicker addDatePicker = (AddDatePicker) addElement;
                    if (addDatePicker.getTo() != String.class) {
                        DateFormat dateFormat = new SimpleDateFormat(addDatePicker.getFormat());
                        Date date = dateFormat.parse(value.toString());
                        if (addDatePicker.getTo() == java.sql.Date.class) {
                            addParam.getParams().put(addElement.getKey(), new java.sql.Date(date.getTime()));
                        }
                    } else {
                        addParam.getParams().put(addElement.getKey(), value.toString());
                    }
                }
            }
        }
        webService.add(addForm.getSchema(), addForm.getTable(), addForm.getPrimaryKey(),
                addParam.getParams(), addParam.getSpecialColumnParams(), addForm.getUniqueColumns());
        return ok().json();
    }

    @PostMapping(value = "/api/info", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String info(@RequestBody InfoParam infoParam) {
        AddForm addForm = JSON.parseObject(infoParam.getAddJson(), AddForm.class);
        Map<String,Object> info = webService.info(addForm.getSchema(), addForm.getTable(), addForm.getPrimaryKey(),
                infoParam.getPrimaryKeyValue(), infoParam.getColumns());
        return ok().pull("info", info).json();
    }

    @PostMapping(value = "/api/update", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String update(@RequestBody UpdateParam updateParam) {
        AddForm addForm = JSON.parseObject(updateParam.getAddJson(), AddForm.class);
        webService.update(addForm.getSchema(), addForm.getTable(), addForm.getPrimaryKey(),
                updateParam.getParams(), updateParam.getSpecialColumnParams(), addForm.getUniqueColumns());
        return ok().json();
    }

    @PostMapping(value = "/api/delete", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String info(@RequestBody DeleteParam deleteParam) {
        AddForm addForm = JSON.parseObject(deleteParam.getAddJson(), AddForm.class);
        webService.delete(addForm.getSchema(), addForm.getTable(), addForm.getPrimaryKey(), deleteParam.getPrimaryKeyValues(), deleteParam.getCascadingDeletes());
        return ok().json();
    }

    @PostMapping(value = "/api/updateSwitch", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateSwitch(@RequestBody UpdateSwitchParam updateSwitchParam) throws ClassNotFoundException {
        Select select = configJsonUtil.parseSelect(updateSwitchParam.getSelectJson());
        String schema = null, table = null;
        String primaryKey = null;
        Object primaryKeyVal = null;
        for (TableColumn tableColumn : select.getTableColumns()) {
            if (tableColumn.getProp().equalsIgnoreCase(updateSwitchParam.getColumn())) {
                updateSwitchParam.setColumn(tableColumn.getKey());
                schema = select.getSchema();
                table = select.getTable();
                primaryKey = select.getPrimaryKey();
                primaryKeyVal = updateSwitchParam.getPrimaryKeyValue();
                break;
            }
        }
        boolean updateFollow = false;
        if (schema == null && select.getLeftJoins() != null) {
            for (SelectLeftJoin leftJoin : select.getLeftJoins()) {
                for (TableColumn tableColumn : leftJoin.getTableColumns()) {
                    if (tableColumn.getProp().equalsIgnoreCase(updateSwitchParam.getColumn())) {
                        updateSwitchParam.setColumn(tableColumn.getKey());
                        schema = leftJoin.getSchema();
                        table = leftJoin.getTable();
                        primaryKey = leftJoin.getRelateKey();
                        primaryKeyVal = updateSwitchParam.getPrimaryKeyValue();
                        updateFollow = true;
                        break;
                    }
                }
            }
        }
        Map<String,Object> params = new HashMap<>();
        params.put(primaryKey, primaryKeyVal);
        params.put(updateSwitchParam.getColumn(), updateSwitchParam.getColumnVal());
        int a = webService.update(schema, table, primaryKey, params,
                updateSwitchParam.getSpecialColumnParams(), null);
        if (a == 0 && updateFollow) {
            return fail("当前字段[", updateSwitchParam.getColumn(),
                    "]属于从表[", schema, ".", table, "] 从表中没有数据").json();
        }
        return ok().json();
    }

}
