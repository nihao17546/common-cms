<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>配置</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
    </style>
</head>
<body>
<div id="app" v-loading="loading">
    <el-container>
        <el-main style="padding: 0px;">
            <el-tabs tab-position="left">
                <el-tab-pane label="数据库配置">
                    <iframe id="db" src="${contextPath}/pages/db.html" frameborder="0" width="100%" :height="height"></iframe>
                </el-tab-pane>
                <#--<el-tab-pane label="数据库查看" :disabled="showDisabled">-->
                    <#--<iframe id="dbShow" src="${contextPath}/pages/dbShow.html" frameborder="0" width="100%" :height="height"></iframe>-->
                <#--</el-tab-pane>-->
                <el-tab-pane label="页面配置" :disabled="showDisabled">
                    <el-card class="box-card">
                        <div slot="header">
                            <span>主表配置</span>
                            <el-button type="primary" plain size="mini" @click="preview">预览</el-button>
                        </div>
                        <el-row :gutter="24">
                            <el-col :span="24">
                                <el-form :model="form" :rules="rules" ref="basicForm" size="small">
                                    <el-col :span="8">
                                        <el-form-item label="页面标题:" prop="title" :label-width="formLabelWidth">
                                            <el-input v-model.trim="form.title" autocomplete="off" size="small"
                                                      maxlength="200"></el-input>
                                        </el-form-item>
                                    </el-col>
                                    <el-col :span="8">
                                        <el-form-item label="允许新增:" prop="add_btn" :label-width="formLabelWidth">
                                            <el-select style="width: 100%" v-model="form.add_btn" @change="addOrEditBtnChange">
                                                <el-option :key="true" label="是" :value="true"></el-option>
                                                <el-option :key="false" label="否" :value="false"></el-option>
                                            </el-select>
                                        </el-form-item>
                                    </el-col>
                                    <el-col :span="8">
                                        <el-form-item label="允许编辑:" prop="edit_btn" :label-width="formLabelWidth">
                                            <el-select style="width: 100%" v-model="form.edit_btn" @change="addOrEditBtnChange">
                                                <el-option :key="true" label="是" :value="true"></el-option>
                                                <el-option :key="false" label="否" :value="false"></el-option>
                                            </el-select>
                                        </el-form-item>
                                    </el-col>
                                    <el-col :span="8">
                                        <el-form-item label="允许删除:" prop="delete_btn" :label-width="formLabelWidth">
                                            <el-select style="width: 100%" v-model="form.delete_btn">
                                                <el-option :key="true" label="是" :value="true"></el-option>
                                                <el-option :key="false" label="否" :value="false"></el-option>
                                            </el-select>
                                        </el-form-item>
                                    </el-col>
                                </el-form>
                            </el-col>
                            <el-col :span="24">
                                <el-collapse v-model="activeNames">
                                    <el-collapse-item title="表格配置" name="1">
                                        <el-card style="margin-top: 10px;" shadow="hover">
                                            <el-form :model="form.table" :rules="rules" ref="mainTableForm" size="small">
                                                <el-row :gutter="24">
                                                    <el-col :span="8">
                                                        <el-form-item label="是否分页:" prop="pagination"
                                                                      :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                                      :label-width="formLabelWidth">
                                                            <el-select style="width: 100%" v-model="form.table.pagination">
                                                                <el-option :key="true" label="是" :value="true"></el-option>
                                                                <el-option :key="false" label="否" :value="false"></el-option>
                                                            </el-select>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="8">
                                                        <el-form-item label="默认排序字段:" prop="defaultSortColumn"
                                                                      :label-width="formLabelWidth">
                                                            <el-input v-model.trim="form.table.defaultSortColumn" autocomplete="off" size="small"></el-input>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="8" v-if="form.table.defaultSortColumn">
                                                        <el-form-item label="排序方式:" prop="defaultOrder"
                                                                      :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                                      :label-width="formLabelWidth">
                                                            <el-select style="width: 100%" v-model="form.table.defaultOrder">
                                                                <el-option key="asc" label="正序" value="asc"></el-option>
                                                                <el-option key="desc" label="倒序" value="desc"></el-option>
                                                            </el-select>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="24" style="margin-bottom: 8px;">
                                                        <el-form-item label="查询列" prop="columns" :label-width="formLabelWidth">
                                                            <el-button type="primary" plain size="mini" @click="showAddTableColumnDialog">添加</el-button>
                                                        </el-form-item>
                                                    </el-col>
                                                    <span v-for="(item,index) in form.table.columns">
                                                        <el-card shadow="hover" style="margin-top: 8px;">
                                                            <el-row style="border: 0px solid gray;" :gutter="24">
                                                                <el-col :span="8">
                                                                    <el-form-item label="sql查询字段:" :label-width="formLabelWidth"
                                                                                  :prop="'columns.' + index + '.key'"
                                                                                  :rules="rules.table.columns.key">
                                                                        <el-input v-model.trim="item.key" placeholder="" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="sql查询别名:" :label-width="formLabelWidth"
                                                                                  :prop="'columns.' + index + '.prop'"
                                                                                  :rules="rules.table.columns.prop">
                                                                        <el-input v-model.trim="item.prop" placeholder="默认等于“sql查询字段”" readOnly="true"
                                                                                  maxlength="50" autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="前端列头文案:" :label-width="formLabelWidth"
                                                                                  :prop="'columns.' + index + '.label'"
                                                                                  :rules="rules.table.columns.label">
                                                                        <el-input v-model.trim="item.label" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="前端列宽度（px）:" :label-width="formLabelWidth"
                                                                                  :prop="'columns.' + index + '.width'"
                                                                                  :rules="rules.table.columns.width">
                                                                        <el-input v-model.trim="item.width" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="是否可以排序:" :label-width="formLabelWidth">
                                                                        <el-select style="width: 100%" v-model="item.sortable"
                                                                                   placeholder="默认否">
                                                                            <el-option :key="true" label="是" :value="true"></el-option>
                                                                            <el-option :key="false" label="否" :value="false"></el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="格式化类型:" :label-width="formLabelWidth">
                                                                        <el-select style="width: 100%" clearable
                                                                                   v-model="item.formatterTypeIndex"
                                                                                   @change="formatterTypeChange(index)">
                                                                            <el-option v-for="(type,aIndex) in formatterTypes" :key="aIndex"
                                                                                       :label="type.name" :value="aIndex">
                                                                            </el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'PIC'">
                                                                    <el-form-item label="图片展示宽度（px）:"
                                                                                  :rules="rules.table.columns.formatterPic"
                                                                                  :prop="'columns.' + index + '.formatter.width'"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.width" placeholder="默认50"
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'PIC'">
                                                                    <el-form-item label="图片展示高度（px）:"
                                                                                  :rules="rules.table.columns.formatterPic"
                                                                                  :prop="'columns.' + index + '.formatter.height'"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.height" placeholder="默认50"
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                    <el-form-item label="选中选项的值:"
                                                                                  :prop="'columns.' + index + '.formatter.active.value'"
                                                                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.active.value" placeholder=""
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                    <el-form-item label="选中选项的标签:"
                                                                                  :prop="'columns.' + index + '.formatter.active.label'"
                                                                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.active.label" placeholder=""
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                    <el-form-item label="未选中选项的值:"
                                                                                  :prop="'columns.' + index + '.formatter.inactive.value'"
                                                                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.inactive.value" placeholder=""
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                    <el-form-item label="未选中选项的标签:"
                                                                                  :prop="'columns.' + index + '.formatter.inactive.label'"
                                                                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.inactive.label" placeholder=""
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'URL'">
                                                                    <el-form-item label="链接打开方式:"
                                                                                  :prop="'columns.' + index + '.formatter.target'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-select style="width: 100%" v-model="item.formatter.target"
                                                                                   placeholder="请选择链接打开方式">
                                                                            <el-option key="_blank" label="新开窗口" value="_blank"></el-option>
                                                                            <el-option key="_self" label="当前窗口" value="_self"></el-option>
                                                                            <el-option key="_parent" label="父级窗口" value="_parent"></el-option>
                                                                            <el-option key="_top" label="顶层窗口" value="_top"></el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'URL'">
                                                                    <el-form-item label="链接文案:"
                                                                                  :prop="'columns.' + index + '.formatter.text'"
                                                                                  :rules="rules.table.columns.formatterUrlText"
                                                                                  :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.text" placeholder="默认链接本身"
                                                                                  autocomplete="off" size="small" maxlength="100"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.formatter && item.formatter.type && item.formatter.type == 'TEXT'">
                                                                    <el-form-item label="文本格式化:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.formatter.map" readOnly="true" placeholder=""
                                                                                  autocomplete="off" size="small" maxlength="100"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="24" style="text-align: right;">
                                                                    <el-button-group>
                                                                        <el-button type="primary" size="mini" icon="el-icon-arrow-up"
                                                                                   v-if="index != 0"
                                                                                   @click="up(item, index, form.table.columns)">上移</el-button>
                                                                        <el-button type="primary" size="mini" icon="el-icon-arrow-down"
                                                                                   v-if="index != form.table.columns.length - 1"
                                                                                   @click="down(item, index, form.table.columns)">下移</el-button>
                                                                    </el-button-group>
                                                                    <el-button type="danger" plain size="mini"
                                                                               @click="remove(item, index, form.table)">移除</el-button>
                                                                </el-col>
                                                            </el-row>
                                                        </el-card>
                                                    </span>
                                                </el-row>
                                            </el-form>
                                        </el-card>
                                    </el-collapse-item>
                                    <el-collapse-item title="搜索表单" name="2">
                                        <el-card style="margin-top: 10px;" shadow="hover">
                                            <el-row :gutter="24">
                                                <el-col :span="24" style="margin-bottom: 8px;">
                                                    <el-button type="primary" plain size="mini" @click="showAddSearchDialog">添加</el-button>
                                                </el-col>
                                                <el-form :model="search" ref="mainSearchForm" size="small">
                                                    <el-col :span="24" style="margin-bottom: 8px;"
                                                            v-for="(item,index) in search.elements">
                                                        <el-card shadow="hover">
                                                            <el-row :gutter="24">
                                                                <el-col :span="8" style="margin-bottom: 8px;">
                                                                    <el-form-item label="表:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.elementTable" placeholder="" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" style="margin-bottom: 8px;">
                                                                    <el-form-item label="字段:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.key" placeholder="" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="前端文案:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.label'"
                                                                                  :rules="[{required: true, message: '前端文案不能为空', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.label" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                            </el-row>
                                                            <el-row :gutter="24">
                                                                <el-col :span="8">
                                                                    <el-form-item label="前端提示信息:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.placeholder'">
                                                                        <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="类型:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.className'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" clearable v-model="item.className"
                                                                                   @change="searchTypeChange(index)">
                                                                            <el-option v-for="(type,aIndex) in searchTypes" :key="type.value"
                                                                                       :label="type.label" :value="type.value">
                                                                            </el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="默认值:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.defaultValue'">
                                                                        <el-input v-model.trim="item.defaultValue" placeholder="" maxlength="100"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8"
                                                                        v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') == -1">
                                                                    <el-form-item label="下拉菜单配置:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.options" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8"
                                                                        v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') > -1">
                                                                    <el-form-item label="远程下拉菜单配置:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.schema + '.' + item.table + '[' + item.keyColumn + '-' + item.valueColumn + ']'"
                                                                                  readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="24" style="text-align: right;">
                                                                    <el-button-group>
                                                                        <el-button type="primary" size="mini" icon="el-icon-arrow-up"
                                                                                   v-if="index != 0"
                                                                                   @click="up(item, index, search.elements)">上移</el-button>
                                                                        <el-button type="primary" size="mini" icon="el-icon-arrow-down"
                                                                                   v-if="index != search.elements.length - 1"
                                                                                   @click="down(item, index, search.elements)">下移</el-button>
                                                                    </el-button-group>
                                                                    <el-button type="danger" plain size="mini"
                                                                               @click="justRemove(item, index, search.elements)">移除</el-button>
                                                                </el-col>
                                                            </el-row>
                                                        </el-card>
                                                    </el-col>
                                                </el-form>
                                            </el-row>
                                        </el-card>
                                    </el-collapse-item>
                                    <el-collapse-item title="默认查询条件" name="3">
                                        <el-card style="margin-top: 10px;" shadow="hover">
                                            <el-form :model="where" :rules="rules" ref="whereForm" size="small">
                                                <el-row :gutter="24">
                                                    <el-col :span="24" style="margin-bottom: 8px;">
                                                        <el-button type="primary" plain size="mini" @click="showAddWhereDialog">添加</el-button>
                                                    </el-col>
                                                    <span v-for="(item,index) in where.wheres">
                                                        <el-card shadow="hover" style="margin-top: 8px;">
                                                            <el-row style="border: 0px solid gray;" :gutter="24">
                                                                <el-col :span="8" style="margin-bottom: 8px;">
                                                                    <el-form-item label="表:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.elementTable" placeholder="" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="sql查询字段:" :label-width="formLabelWidth"
                                                                                  :prop="'wheres.' + index + '.key'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.key" placeholder="" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="类型:" :label-width="formLabelWidth"
                                                                                  :prop="'wheres.' + index + '.className'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" clearable
                                                                                   v-model.trim="item.className"
                                                                                   @change="searchWhereTypeChange(index)">
                                                                            <el-option v-for="(searchWhereType,aIndex) in searchWhereTypes"
                                                                                       :key="aIndex"
                                                                                       :label="searchWhereType.label"
                                                                                       :value="searchWhereType.value">
                                                                            </el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8"
                                                                        v-if="item.type && (item.type == 'eq' || item.type == 'gt' || item.type == 'gteq' || item.type == 'lt' || item.type == 'lteq' || item.type == 'like')">
                                                                    <el-form-item label="值:" :label-width="formLabelWidth"
                                                                                  :prop="'wheres.' + index + '.value'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.value" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.type && item.type == 'bt'">
                                                                    <el-form-item label="最小值:" :label-width="formLabelWidth"
                                                                                  :prop="'wheres.' + index + '.begin'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.begin" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.type && item.type == 'bt'">
                                                                    <el-form-item label="最大值:" :label-width="formLabelWidth"
                                                                                  :prop="'wheres.' + index + '.end'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.end" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.type && item.type == 'in'">
                                                                    <el-form-item label="集合值:" :label-width="formLabelWidth">
                                                                        <el-input v-model.trim="item.values" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small" readOnly="true"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="24" style="text-align: right;">
                                                                    <el-button-group>
                                                                        <el-button type="primary" size="mini" icon="el-icon-arrow-up"
                                                                                   v-if="index != 0"
                                                                                   @click="up(item, index, where.wheres)">上移</el-button>
                                                                        <el-button type="primary" size="mini" icon="el-icon-arrow-down"
                                                                                   v-if="index != where.wheres.length - 1"
                                                                                   @click="down(item, index, where.wheres)">下移</el-button>
                                                                    </el-button-group>
                                                                    <el-button type="danger" plain size="mini"
                                                                               @click="justRemove(item, index, where.wheres)">移除</el-button>
                                                                </el-col>
                                                            </el-row>
                                                        </el-card>
                                                    </span>
                                                </el-row>
                                            </el-form>
                                        </el-card>
                                    </el-collapse-item>
                                    <el-collapse-item title="新增/编辑表单配置" name="4" v-if="form.add_btn || form.edit_btn">
                                        <el-card style="margin-top: 10px;" shadow="hover">
                                            <el-form :model="form.add_form" :rules="rules" ref="addForm" size="small">
                                                <el-row :gutter="24">
                                                    <el-col :span="8">
                                                        <el-form-item label="前端弹窗宽（%）:" prop="width" :label-width="formLabelWidth">
                                                            <el-input-number size="small" v-model="form.add_form.width"
                                                                             :min="50" :max="100"
                                                                             style="width: 100%"></el-input-number>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="8">
                                                        <el-form-item label="添加字段" prop="elements" :label-width="formLabelWidth">
                                                            <el-button type="primary" plain size="mini" @click="showAddFormColumnDialog">添加</el-button>
                                                        </el-form-item>
                                                    </el-col>
                                                </el-row>
                                                <span v-for="(item,index) in form.add_form.elements">
                                                        <el-card shadow="hover" style="margin-top: 8px;">
                                                            <el-row style="border: 0px solid gray;" :gutter="24">
                                                                <el-col :span="8">
                                                                    <el-form-item label="字段:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.key'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.key" placeholder="" readOnly="true"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8">
                                                                    <el-form-item label="类型:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.className'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" clearable v-model="item.className"
                                                                                   @change="addFormClassChange(index)">
                                                                            <el-option v-for="(type,aIndex) in addFormTypes" :key="type.value"
                                                                                       :label="type.label" :value="type.value">
                                                                            </el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.shows.indexOf('label') != -1">
                                                                    <el-form-item label="表单文案:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.label'"
                                                                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.label" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.shows.indexOf('clearable') != -1">
                                                                    <el-form-item label="表单可清空:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.clearable'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" v-model="item.clearable">
                                                                            <el-option :key="true" label="是" :value="true"></el-option>
                                                                            <el-option :key="false" label="否" :value="false"></el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="8" v-if="item.shows.indexOf('canEdit') != -1">
                                                                    <el-form-item label="是否可编辑:" :label-width="formLabelWidth"
                                                                                  :prop="'elements.' + index + '.canEdit'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" v-model="item.canEdit">
                                                                            <el-option :key="true" label="是" :value="true"></el-option>
                                                                            <el-option :key="false" label="否" :value="false"></el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                            </el-row>
                                                        </el-card>
                                                    </span>
                                            </el-form>
                                        </el-card>
                                    </el-collapse-item>
                                </el-collapse>
                                <el-row :gutter="24">
                                    <el-col :span="24" style="margin-top: 10px;text-align: right;">
                                        <el-button type="primary" plain size="mini" @click="submit">提交</el-button>
                                    </el-col>
                                </el-row>
                            </el-col>
                        </el-row>
                    </el-card>
                </el-tab-pane>
            </el-tabs>
        </el-main>
    </el-container>

    <el-dialog title="添加列" :visible.sync="tableColumnDialog.visible" class="group-dialog" :before-close="closeTableColumnDialog">
        <el-select v-model="tableColumnDialog.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addTableColumn">
            <el-option-group
                    v-for="(group,index) in mainTableColumns"
                    :key="group.label"
                    :label="group.label">
                <el-option
                        v-for="(item,index) in group.options"
                        :key="item+index"
                        :label="'列名:' + item.key + ' 类型:' + item.dataType"
                        :value="group.label + ',' + item.key">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addTableColumn">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="文本格式化" :visible.sync="formatterText.visible" class="group-dialog" :before-close="closeFormatterTextDialog">
        <div style="margin-bottom: 5px;text-align: left;">
            <el-button type="primary" plain size="mini" @click="pushFormatterText">添加</el-button>
        </div>
        <div v-for="(item,index) in formatterText.map">
            <el-row :gutter="24">
                <el-col :span="10">
                    <el-input size="small" placeholder="key" v-model.trim="item.key"></el-input>
                </el-col>
                <el-col :span="10">
                    <el-input size="small" placeholder="value" v-model.trim="item.value"></el-input>
                </el-col>
                <el-col :span="4">
                    <el-button type="danger" plain size="mini" @click="removeFormatterText(index)">移除</el-button>
                </el-col>
            </el-row>
        </div>
    </el-dialog>

    <el-dialog title="搜索条件" :visible.sync="searchDialog.visible" class="group-dialog"
               :before-close="closeAddSearchDialog">
        <el-select v-model="searchDialog.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addSearchDom">
            <el-option-group
                    v-for="(group,index) in mainSearchColumns"
                    :key="group.label"
                    :label="group.label">
                <el-option
                        v-for="(item,index) in group.options"
                        :key="item+index"
                        :label="'列名:' + item.key + ' 类型:' + item.dataType"
                        :value="group.label + ',' + item.key">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addSearchDom">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="搜索下拉菜单选项" :visible.sync="searchDialog.select.visible" class="group-dialog" :before-close="closeSearchSelectDialog">
        <div style="margin-bottom: 5px;text-align: left;">
            <el-button type="primary" plain size="mini" @click="pushSearchSelect">添加</el-button>
        </div>
        <div v-for="(item,index) in searchDialog.select.options">
            <el-row :gutter="24">
                <el-col :span="10">
                    <el-input size="small" placeholder="选项外显名称" v-model.trim="item.label"></el-input>
                </el-col>
                <el-col :span="10">
                    <el-input size="small" placeholder="选项值" v-model.trim="item.value"></el-input>
                </el-col>
                <el-col :span="4">
                    <el-button type="danger" plain size="mini" @click="removeSearchSelect(index)">移除</el-button>
                </el-col>
            </el-row>
        </div>
    </el-dialog>

    <el-dialog title="远程下拉菜单配置" :visible.sync="remoteSelectDialog.visible" class="group-dialog"
               :show-close="false">
        <el-form :model="remoteSelectDialog.form" ref="remoteSelectForm" size="small">
            <el-row :gutter="24">
                <el-col :span="24">
                    <el-form-item label="数据库:" :label-width="formLabelWidth"
                                  prop="schema"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input v-model.trim="remoteSelectDialog.form.schema" placeholder="" maxlength="100"
                                  autocomplete="off" size="small" @change="remoteSelectSchemaOrTableChange"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="表:" :label-width="formLabelWidth"
                                  prop="table"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input v-model.trim="remoteSelectDialog.form.table" placeholder="" maxlength="100"
                                  autocomplete="off" size="small" @change="remoteSelectSchemaOrTableChange"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="外显字段:" :label-width="formLabelWidth"
                                  prop="keyColumn"
                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                        <el-select v-model.trim="remoteSelectDialog.form.keyColumn" placeholder="请选择外显字段" size="small" style="width: 100%">
                            <el-option v-for="column in remoteSelectDialog.columns"
                                       @focus="remoteSelectFocus"
                                       :key="column.name"
                                       :label="'列名:' + column.name + '   类型:' + column.type"
                                       :value="column.name">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="值字段:" :label-width="formLabelWidth"
                                  prop="valueColumn"
                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                        <el-select v-model.trim="remoteSelectDialog.form.valueColumn" placeholder="请选择值字段" size="small" style="width: 100%">
                            <el-option v-for="column in remoteSelectDialog.columns"
                                       @focus="remoteSelectFocus"
                                       :key="column.name"
                                       :label="'列名:' + column.name + '   类型:' + column.type"
                                       :value="column.name">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="24" style="text-align: right;">
                    <el-button type="info" plain size="mini" @click="cancelRemoteSelect">取消</el-button>
                    <el-button type="primary" plain size="mini" @click="confirmRemoteSelect('remoteSelectForm')">确认</el-button>
                </el-col>
            </el-row>
        </el-form>
    </el-dialog>

    <el-dialog title="默认查询选择字段" :visible.sync="where.dialog.visible" class="group-dialog"
               :before-close="closeAddWhereDialog">
        <el-select v-model="where.dialog.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addWhereDom">
            <el-option-group
                    v-for="(group,index) in mainSearchColumns"
                    :key="group.label"
                    :label="group.label">
                <el-option
                        v-for="(item,index) in group.options"
                        :key="item+index"
                        :label="'列名:' + item.key + ' 类型:' + item.dataType"
                        :value="group.label + ',' + item.key">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addWhereDom">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="默认查询区间配置" :visible.sync="where.dialog.whereIn && where.dialog.whereIn.visible" class="group-dialog"
               :show-close="false">
        <el-form :model="where.dialog.whereIn" ref="whereInForm" size="small">
            <el-row :gutter="24">
                <el-col :span="24">
                    <el-form-item label="区间值:" :label-width="formLabelWidth"
                                  prop="item"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input v-model.trim="where.dialog.whereIn.item" placeholder="多个值之间使用英文逗号分隔"
                                  maxlength="1000" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="24" style="text-align: right;">
                    <el-button type="info" plain size="mini" @click="cancelWhereIn">取消</el-button>
                    <el-button type="primary" plain size="mini" @click="confirmWhereIn('whereInForm')">确认</el-button>
                </el-col>
            </el-row>
        </el-form>
    </el-dialog>

    <el-dialog title="添加字段" :visible.sync="formColumnDialog.visible" class="group-dialog" :before-close="closeFormColumnDialog">
        <el-select v-model="formColumnDialog.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addFormColumn">
            <el-option-group
                    v-for="(group,index) in mainFormColumns"
                    :key="group.label"
                    :label="group.label">
                <el-option
                        v-for="(item,index) in group.options"
                        :key="item+index"
                        :label="'列名:' + item.key + ' 类型:' + item.dataType"
                        :value="group.label + ',' + item.key">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addTableColumn">确认</el-button>
        </div>
    </el-dialog>
</div>
<script>
    window.contextPath = '${contextPath}'
    window.searchElementPackage = '${searchElementPackage}'
    window.wherePackage = '${wherePackage}'
    window.addElementPackage  = '${addElementPackage}'
</script>
<script>
    window.vue = new Vue({
        name: 'config',
        el: '#app',
        data() {
            var validateZNum = (rule, value, callback) => {
                if (!value || value === '') {
                    if (rule.required) {
                        callback(new Error(rule.message));
                    } else {
                        callback();
                    }
                } else {
                    if (/(^[1-9]\d*$)/.test(value)) {
                        callback();
                    } else {
                        callback(new Error('格式要求正整数'));
                    }
                }
            };
            var validateColumns = (rule, value, callback) => {
                if (!value || value.length == 0) {
                    if (rule.required) {
                        callback(new Error(rule.message));
                    } else {
                        callback();
                    }
                } else {
                    callback();
                }
            };
            return {
                loading: false,
                height: window.innerHeight - 78,
                formLabelWidth: '150px',
                formatterTypes: [],
                whereTypes: [],
                searchTypes: [{
                    label: '完全匹配文本输入框',
                    value: window.searchElementPackage + 'SearchInputEq'
                },{
                    label: '模糊匹配文本输入框',
                    value: window.searchElementPackage + 'SearchInputLike'
                },{
                    label: '查询下拉菜单',
                    value: window.searchElementPackage + 'SearchSelect'
                },{
                    label: '远程查询下拉菜单',
                    value: window.searchElementPackage + 'SearchSelectRemote'
                },{
                    label: '日期选择器（yyyy-MM-dd）',
                    value: window.searchElementPackage + 'SearchDatePickerBt'
                },{
                    label: '日期时间选择器（yyyy-MM-dd HH:mm:ss）',
                    value: window.searchElementPackage + 'SearchDatetimePickerBt'
                }],
                searchWhereTypes: [{
                    label: '完全匹配',
                    value: window.wherePackage + 'WhereEq'
                },{
                    label: '区间',
                    value: window.wherePackage + 'WhereBt'
                },{
                    label: '大于',
                    value: window.wherePackage + 'WhereGt'
                },{
                    label: '大于等于',
                    value: window.wherePackage + 'WhereGteq'
                },{
                    label: '小于',
                    value: window.wherePackage + 'WhereLt'
                },{
                    label: '大于等于',
                    value: window.wherePackage + 'WhereLteq'
                },{
                    label: '模糊匹配',
                    value: window.wherePackage + 'WhereLike'
                },{
                    label: '集合',
                    value: window.wherePackage + 'WhereIn'
                }],
                mainDb: {},
                oneToOnes: [],
                oneToMores: [],
                mainTableColumns: [],
                mainSearchColumns: [],
                mainFormColumns: [],
                showDisabled: true,
                form: {
                    table: {
                        columns: [],
                        select: {
                            columns: [],
                            wheres: [],
                            leftJoins: [],
                            searchElements: []
                        },
                        pagination: false
                    },
                    add_form: {
                        elements: [],
                        unique_columns: []
                    }
                },
                searchDialog: {
                    visible: false,
                    select: {
                        visible: false,
                        options: []
                    }
                },
                remoteSelectDialog: {
                    visible: false,
                    form: {},
                    columns: []
                },
                search: {
                    elements: []
                },
                where: {
                    dialog: {
                        visible: false,
                        item: '',
                        whereIn: {
                            visible: false,
                            item: ''
                        }
                    },
                    wheres: []
                },
                rules: {
                    title: [{required: true, message: '请输入', trigger: 'change'}],
                    columns: [{required: true, message: '查询列不能为空', validator: validateColumns, trigger: 'change'}],
                    table: {
                        columns: {
                            key: [{required: true, message: 'sql查询字段不能为空', trigger: 'change'}],
                            label: [{required: true, message: '前端列头文案不能为空', trigger: 'change'}],
                            formatterPic: [{required: true, message: '请输入正整数', validator: validateZNum, trigger: 'change'}],
                        }
                    }
                },
                activeNames: [],
                tableColumnDialog: {
                    visible: false
                },
                formatterText: {
                    visible: false,
                    map: []
                },
                formColumnDialog: {
                    visible: false
                },
                addFormTypes: [{
                    label: '普通文本',
                    value: window.addElementPackage + 'AddInput'
                },{
                    label: '下拉选择框',
                    value: window.addElementPackage + 'AddSelect'
                },{
                    label: '远程下拉选择框',
                    value: window.addElementPackage + 'AddSelectRemote'
                },{
                    label: '单选框',
                    value: window.addElementPackage + 'AddRadio'
                },{
                    label: '计数器',
                    value: window.addElementPackage + 'AddInputNumber'
                },{
                    label: '日期选择器（yyyy-MM-dd）',
                    value: window.addElementPackage + 'AddDatePicker'
                },{
                    label: '日期时间选择器（yyyy-MM-dd HH:mm:ss）',
                    value: window.addElementPackage + 'AddDateTimePicker'
                },{
                    label: '时间选择器',
                    value: window.addElementPackage + 'AddTimePicker'
                },{
                    label: '图片上传',
                    value: window.addElementPackage + 'AddUploadPic'
                },{
                    label: '富文本',
                    value: window.addElementPackage + 'AddRich'
                },{
                    label: '创建时间',
                    value: window.addElementPackage + 'AddCreateDateTime'
                },{
                    label: '更新时间',
                    value: window.addElementPackage + 'AddUpdateDateTime'
                }]
            }
        },
        methods: {
            submit() {
                this.loading = true;

                let data = JSON.parse(JSON.stringify(this.form))

                if (data.table && data.table.columns && data.table.columns.length > 0) {
                    for (let i = 0; i < data.table.columns.length; i ++) {
                        delete data.table.columns[i].options
                    }
                }

                if (this.search && this.search.elements && this.search.elements.length > 0) {
                    for (let i = 0; i < this.search.elements.length; i ++) {
                        let searchElement = this.search.elements[i]
                        let aa = searchElement.elementTable.split('.');
                        let schema = aa[0]
                        let table = aa[1]
                        let alias = searchElement.alias
                        let obj = JSON.parse(JSON.stringify(searchElement))
                        delete obj.elementTable
                        if (data.table.select.alias == alias) {
                            if (!data.table.select.searchElements) {
                                data.table.select.searchElements = []
                            }
                            data.table.select.searchElements.push(obj)
                            break
                        } else if (data.table.select.leftJoins && data.table.select.leftJoins.length > 0) {
                            for (let q = 0; q < data.table.select.leftJoins.length; q ++) {
                                let leftJoin = data.table.select.leftJoins[q]
                                if (leftJoin.alias == alias) {
                                    if (!data.table.select.leftJoins[q].searchElements) {
                                        data.table.select.leftJoins[q].searchElements = []
                                    }
                                    data.table.select.leftJoins[q].searchElements.push(obj)
                                    break
                                }
                            }
                        }
                    }
                }

                if (this.where && this.where.wheres && this.where.wheres.length > 0) {
                    for (let i = 0; i < this.where.wheres.length; i ++) {
                        let where = this.where.wheres[i]
                        let aa = where.elementTable.split('.');
                        let schema = aa[0]
                        let table = aa[1]
                        let alias = where.alias
                        let obj = JSON.parse(JSON.stringify(where))
                        delete obj.elementTable
                        delete obj.alias
                        if (data.table.select.alias == alias) {
                            if (!data.table.select.wheres) {
                                data.table.select.wheres = []
                            }
                            data.table.select.wheres.push(obj)
                            break
                        } else if (data.table.select.leftJoins && data.table.select.leftJoins.length > 0) {
                            for (let q = 0; q < data.table.select.leftJoins.length; q ++) {
                                let leftJoin = data.table.select.leftJoins[q]
                                if (leftJoin.alias == alias) {
                                    if (!data.table.select.leftJoins[q].wheres) {
                                        data.table.select.leftJoins[q].wheres = []
                                    }
                                    data.table.select.leftJoins[q].wheres.push(obj)
                                    break
                                }
                            }
                        }
                    }
                }

                console.log(JSON.stringify(data))
                // console.log(JSON.stringify(this.search))
                this.activeNames = ["1","2","3","4"]

                let basicFormValid = null,
                        mainTableFormValid = null,
                        mainSearchFormValid = null,
                        whereFormValid = null;

                this.$refs['basicForm'].validate((valid) => {
                    if (valid) {
                        basicFormValid = true
                    } else {
                        basicFormValid = false
                    }
                });

                this.$refs['mainTableForm'].validate((valid) => {
                    if (valid) {
                        mainTableFormValid = true
                    } else {
                        mainTableFormValid = false
                    }
                });

                this.$refs['mainSearchForm'].validate((valid) => {
                    if (valid) {
                        mainSearchFormValid = true
                    } else {
                        mainSearchFormValid = false
                    }
                });

                this.$refs['whereForm'].validate((valid) => {
                    if (valid) {
                        whereFormValid = true
                    } else {
                        whereFormValid = false
                    }
                });

                let aaa = window.setInterval(() => {
                    if (basicFormValid != null
                            && mainTableFormValid != null
                            && mainSearchFormValid != null
                            && whereFormValid != null) {
                        window.clearInterval(aaa)
                        if (basicFormValid
                                && mainTableFormValid
                                && mainSearchFormValid
                                && whereFormValid) {
                            alert(1)
                        } else {
                            alert(0)
                        }
                        this.loading = false;
                    }
                }, 100)
            },
            addFormClassChange(index) {
                if (this.form.add_form.elements[index].className) {
                    if (this.form.add_form.elements[index].className.indexOf('.AddInputNumber') > -1) {
                        this.form.add_form.elements[index].elType = 'INPUT_NUMBER'
                        this.form.add_form.elements[index].columnType = 'COM'
                        this.form.add_form.elements[index].canEdit = true
                        this.form.add_form.elements[index].clearable = true
                        this.form.add_form.elements[index].label = ''
                        this.form.add_form.elements[index].size = 'small'
                        this.form.add_form.elements[index].min = ''
                        this.form.add_form.elements[index].max = ''
                        this.form.add_form.elements[index].precision = ''
                        this.form.add_form.elements[index].step = ''
                        this.form.add_form.elements[index].shows = ['label','canEdit','clearable','min','max','precision','step']
                    }
                } else {
                    delete this.form.add_form.elements[index].className
                    delete this.form.add_form.elements[index].elType
                    delete this.form.add_form.elements[index].columnType
                    delete this.form.add_form.elements[index].canEdit
                    delete this.form.add_form.elements[index].clearable
                    delete this.form.add_form.elements[index].label
                    delete this.form.add_form.elements[index].size
                    delete this.form.add_form.elements[index].min
                    delete this.form.add_form.elements[index].max
                    delete this.form.add_form.elements[index].precision
                    delete this.form.add_form.elements[index].step
                }
                this.form.add_form.elements = JSON.parse(JSON.stringify(this.form.add_form.elements))
            },
            addFormColumn() {
                if (this.formColumnDialog.item != null && typeof this.formColumnDialog.item != 'undefined') {
                    let aa = this.formColumnDialog.item.split(',');
                    let table = aa[0], key = aa[1];
                    for (let i = 0; i < this.mainFormColumns.length; i++) {
                        if (this.mainFormColumns[i].label == table) {
                            if (this.mainFormColumns[i].options && this.mainFormColumns[i].options.length > 0) {
                                for (let j = 0; j < this.mainFormColumns[i].options.length; j ++) {
                                    if (this.mainFormColumns[i].options[j].key === key) {
                                        this.form.add_form.elements.push({
                                            key: this.mainFormColumns[i].options[j].key,
                                            option: JSON.stringify(this.mainFormColumns[i].options[j]),
                                            shows: []
                                        })
                                        this.mainFormColumns[i].options.splice(j, 1)
                                        this.$refs.addForm.validateField("elements");
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                this.closeFormColumnDialog()
            },
            closeFormColumnDialog() {
                this.formColumnDialog = {
                    visible : false
                }
            },
            showAddFormColumnDialog() {
                this.formColumnDialog = {
                    visible : true
                }
            },
            cancelWhereIn() {
                delete this.where.wheres[this.where.dialog.index].values
                delete this.where.wheres[this.where.dialog.index].className
                delete this.where.wheres[this.where.dialog.index].type
                this.where.dialog.whereIn = {
                    visible: false,
                    item: ''
                }
            },
            confirmWhereIn(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        this.where.wheres[this.where.dialog.index].values = this.where.dialog.whereIn.item.split(',')
                        this.where.dialog.whereIn = {
                            visible: false,
                            item: ''
                        }
                    }
                })
            },
            searchWhereTypeChange(index) {
                delete this.where.wheres[index].begin
                delete this.where.wheres[index].end
                delete this.where.wheres[index].value
                delete this.where.wheres[index].values
                if (this.where.wheres[index].className) {
                    if (this.where.wheres[index].className.indexOf('.WhereEq') > -1) {
                        this.where.wheres[index].type = 'eq'
                        this.where.wheres[index].value = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereGteq') > -1) {
                        this.where.wheres[index].type = 'gteq'
                        this.where.wheres[index].value = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereGt') > -1) {
                        this.where.wheres[index].type = 'gt'
                        this.where.wheres[index].value = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereLteq') > -1) {
                        this.where.wheres[index].type = 'lteq'
                        this.where.wheres[index].value = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereLt') > -1) {
                        this.where.wheres[index].type = 'lt'
                        this.where.wheres[index].value = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereBt') > -1) {
                        this.where.wheres[index].type = 'bt'
                        this.where.wheres[index].begin = ''
                        this.where.wheres[index].end = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereLike') > -1) {
                        this.where.wheres[index].type = 'like'
                        this.where.wheres[index].value = ''
                    } else if (this.where.wheres[index].className.indexOf('.WhereIn') > -1) {
                        this.where.wheres[index].type = 'in'
                        this.where.wheres[index].values = []
                        this.where.dialog.whereIn = {
                            visible: true,
                            item: ''
                        }
                    }
                    this.where.dialog.index = index
                } else {
                    delete this.where.wheres[index].type
                    delete this.where.wheres[index].className
                    delete this.where.dialog.index
                }
            },
            addWhereDom() {
                if (this.where.dialog.item != null && typeof this.where.dialog.item != 'undefined') {
                    let aa = this.where.dialog.item.split(',');
                    let table = aa[0], key = aa[1];
                    for (let i = 0; i < this.mainSearchColumns.length; i++) {
                        if (this.mainSearchColumns[i].label == table) {
                            if (this.mainSearchColumns[i].options && this.mainSearchColumns[i].options.length > 0) {
                                for (let j = 0; j < this.mainSearchColumns[i].options.length; j ++) {
                                    if (this.mainSearchColumns[i].options[j].key === key) {
                                        this.where.wheres.push({
                                            elementTable: table,
                                            alias: this.mainSearchColumns[i].options[j].alias,
                                            key: this.mainSearchColumns[i].options[j].key,
                                            type: '',
                                            className: ''
                                        })
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                this.closeAddWhereDialog()
            },
            closeAddWhereDialog() {
                this.where.dialog = {
                    visible: false,
                    item: '',
                    whereIn: {
                        visible: false,
                        item: ''
                    }
                }
            },
            showAddWhereDialog() {
                this.where.dialog = {
                    visible: true,
                    item: '',
                    whereIn: {
                        visible: false,
                        item: ''
                    }
                }
            },
            confirmRemoteSelect(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        this.search.elements[this.remoteSelectDialog.index].schema = this.remoteSelectDialog.form.schema
                        this.search.elements[this.remoteSelectDialog.index].table = this.remoteSelectDialog.form.table
                        this.search.elements[this.remoteSelectDialog.index].keyColumn = this.remoteSelectDialog.form.keyColumn
                        this.search.elements[this.remoteSelectDialog.index].valueColumn = this.remoteSelectDialog.form.valueColumn
                        this.remoteSelectDialog = {
                            visible: false,
                            form: {},
                            columns: []
                        }
                    }
                })
            },
            cancelRemoteSelect() {
                delete this.search.elements[this.remoteSelectDialog.index].schema
                delete this.search.elements[this.remoteSelectDialog.index].table
                delete this.search.elements[this.remoteSelectDialog.index].keyColumn
                delete this.search.elements[this.remoteSelectDialog.index].valueColumn
                delete this.search.elements[this.remoteSelectDialog.index].className
                delete this.search.elements[this.remoteSelectDialog.index].judgeType
                delete this.search.elements[this.remoteSelectDialog.index].elType
                this.remoteSelectDialog = {
                    visible: false,
                    form: {},
                    columns: []
                }
            },
            remoteSelectFocus() {

            },
            remoteSelectSchemaOrTableChange() {
                this.remoteSelectDialog.columns = []
                this.remoteSelectDialog.form.keyColumn = ''
                this.remoteSelectDialog.form.valueColumn = ''
                if (typeof this.remoteSelectDialog.form.schema != 'undefined'
                        && typeof this.remoteSelectDialog.form.table != 'undefined'
                        && this.remoteSelectDialog.form.schema != ''
                        && this.remoteSelectDialog.form.table != '')
                axios.get(window.contextPath + '/api/getTable', {
                    params: {
                        schema: this.remoteSelectDialog.form.schema,
                        table: this.remoteSelectDialog.form.table
                    }
                }).then(res => {
                    if (res.data.status == 0) {
                        this.remoteSelectDialog.columns = res.data.content.table.columns
                    }
                }).catch(res => {
                    console.error(res)
                    this.$message.error('服务异常');
                })
            },
            closeSearchSelectDialog(done) {
                if (this.searchDialog.select.options.length == 0) {
                    delete this.search.elements[this.searchDialog.select.index].options
                    delete this.search.elements[this.searchDialog.select.index].className
                    delete this.search.elements[this.searchDialog.select.index].judgeType
                    delete this.search.elements[this.searchDialog.select.index].elType
                    this.searchDialog = {
                        visible: false,
                        select: {
                            visible: false,
                            options: []
                        }
                    }
                    done()
                } else {
                    let options = []
                    for (let i = 0; i < this.searchDialog.select.options.length; i ++) {
                        let label = this.searchDialog.select.options[i].label
                        let value = this.searchDialog.select.options[i].value
                        if (typeof label != 'undefined' && typeof value != 'undefined'
                                && label != '' && value != '') {
                            options.push({
                                label: label,
                                value: value
                            })
                        } else {
                            this.$message.warning('搜索下拉菜单选项填写错误');
                            return
                        }
                    }
                    this.search.elements[this.searchDialog.select.index].options = options
                    this.searchDialog = {
                        visible: false,
                        select: {
                            visible: false,
                            options: []
                        }
                    }
                    done()
                }
            },
            removeSearchSelect(index) {
                this.searchDialog.select.options.splice(index, 1)
            },
            pushSearchSelect() {
                this.searchDialog.select.options.push({
                    label: '',
                    value: ''
                })
            },
            searchTypeChange(index) {
                delete this.search.elements[index].options
                if (this.search.elements[index].className) {
                    if (this.search.elements[index].className.indexOf('.SearchSelectRemote') > -1) {
                        this.search.elements[index].elType = 'SELECT'
                        this.search.elements[index].judgeType = 'eq'
                        this.remoteSelectDialog = {
                            visible: true,
                            form: {
                                keyColumn: '',
                                valueColumn: ''
                            },
                            columns: [],
                            index: index
                        }
                    } else if (this.search.elements[index].className.indexOf('.SearchSelect') > -1) {
                        this.search.elements[index].elType = 'SELECT'
                        this.search.elements[index].judgeType = 'eq'
                        this.search.elements[index].options = []
                        this.searchDialog.select = {
                            visible: true,
                            options: [],
                            index: index
                        }
                    } else if (this.search.elements[index].className.indexOf('.SearchInputEq') > -1) {
                        this.search.elements[index].elType = 'INPUT'
                        this.search.elements[index].judgeType = 'eq'
                    } else if (this.search.elements[index].className.indexOf('.SearchInputLike') > -1) {
                        this.search.elements[index].elType = 'INPUT'
                        this.search.elements[index].judgeType = 'like'
                    } else if (this.search.elements[index].className.indexOf('.SearchDatePickerBt') > -1) {
                        this.search.elements[index].elType = 'DATETIME_PICKER'
                        this.search.elements[index].judgeType = 'bt'
                        this.search.elements[index].format = 'yyyy-MM-dd'
                    } else if (this.search.elements[index].className.indexOf('.SearchDatetimePickerBt') > -1) {
                        this.search.elements[index].elType = 'DATETIME_PICKER'
                        this.search.elements[index].judgeType = 'bt'
                        this.search.elements[index].format = 'yyyy-MM-dd HH:mm:ss'
                    }
                } else {
                    delete this.search.elements[index].elType
                    delete this.search.elements[index].judgeType
                    delete this.search.elements[index].options
                    delete this.search.elements[index].className
                    delete this.search.elements[index].schema
                    delete this.search.elements[index].table
                    delete this.search.elements[index].keyColumn
                    delete this.search.elements[index].valueColumn
                    delete this.search.elements[index].format
                    delete this.searchDialog.select.index
                }
            },
            removeSearchDom(index) {
                this.search.elements.splice(index, 1)
            },
            closeAddSearchDialog() {
                this.searchDialog = {
                    visible: false,
                    select: {
                        visible: false,
                        options: []
                    }
                }
            },
            showAddSearchDialog() {
                this.searchDialog = {
                    visible: true,
                    select: {
                        visible: false,
                        options: []
                    }
                }
            },
            addSearchDom() {
                if (this.searchDialog.item != null && typeof this.searchDialog.item != 'undefined') {
                    let aa = this.searchDialog.item.split(',');
                    let table = aa[0], key = aa[1];
                    for (let i = 0; i < this.mainSearchColumns.length; i++) {
                        if (this.mainSearchColumns[i].label == table) {
                            if (this.mainSearchColumns[i].options && this.mainSearchColumns[i].options.length > 0) {
                                for (let j = 0; j < this.mainSearchColumns[i].options.length; j ++) {
                                    if (this.mainSearchColumns[i].options[j].key === key) {
                                        this.search.elements.push({
                                            elementTable: table,
                                            alias: this.mainSearchColumns[i].options[j].alias,
                                            key: this.mainSearchColumns[i].options[j].key,
                                            label: '',
                                            placeholder: '',
                                            clearable: true,
                                            size: 'small',
                                            judgeType: '',
                                            defaultValue: '',
                                            show: true
                                        })
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                this.closeAddSearchDialog()
            },
            up(item, index, elements) {
                elements[index] = elements.splice(index - 1, 1, elements[index])[0];
            },
            down(item, index, elements) {
                elements[index] = elements.splice(index + 1, 1, elements[index])[0];
            },
            justRemove(item, index, elements) {
                elements.splice(index, 1)
            },
            remove(item, index, table) {
                table.columns.splice(index, 1)
                let option = JSON.parse(item.option)
                if (table.alias == option.alias) {
                    for (let i = 0; i < table.select.columns.length; i ++) {
                        let asa = table.select.columns[i];
                        if (asa == item.key + ' as ' + item.prop) {
                            table.select.columns.splice(i, 1)
                            break
                        }
                    }
                } else if (table.select.leftJoins && table.select.leftJoins.length > 0) {
                    for (let i = 0; i < table.select.leftJoins.length; i ++) {
                        let leftJoin = table.select.leftJoins[i];
                        if (leftJoin.alias == option.alias) {
                            for (let j = 0; j < table.select.leftJoins[i].columns.length; j ++) {
                                let asa = table.select.leftJoins[i].columns[j];
                                if (asa == item.key + ' as ' + item.prop) {
                                    table.select.leftJoins[i].columns.splice(i, 1)
                                    break
                                }
                            }
                        }
                    }
                }
                for (let i = 0; i < this.mainTableColumns.length; i ++) {
                    if (option.label == this.mainTableColumns[i].label) {
                        this.mainTableColumns[i].options.push(option)
                        break
                    }
                }
            },
            removeFormatterText(index) {
                this.formatterText.map.splice(index, 1)
            },
            pushFormatterText() {
                this.formatterText.map.push({
                    key: '',
                    value: ''
                })
            },
            closeFormatterTextDialog(done) {
                if (this.formatterText.map.length == 0) {
                    delete this.form.table.columns[this.formatterText.index].formatterTypeIndex
                    delete this.form.table.columns[this.formatterText.index].formatter
                    this.formatterText = {
                        visible: false,
                        map: []
                    }
                    done()
                } else {
                    let map = {}
                    for (let i = 0; i < this.formatterText.map.length; i ++) {
                        let key = this.formatterText.map[i].key
                        let value = this.formatterText.map[i].value
                        if (typeof key != 'undefined' && typeof value != 'undefined'
                                && key != '' && value != '') {
                            map[key] = value
                        } else {
                            this.$message.warning('文本格式化填写错误');
                            return
                        }
                    }
                    this.form.table.columns[this.formatterText.index].formatter.map = map
                    this.formatterText = {
                        visible: false,
                        map: []
                    }
                    done()
                }
            },
            addFormatterText() {
                this.closeFormatterTextDialog()
            },
            formatterTypeChange(index) {
                if (typeof this.form.table.columns[index].formatterTypeIndex == 'number') {
                    this.form.table.columns[index].formatter = {
                        className: this.formatterTypes[this.form.table.columns[index].formatterTypeIndex].className,
                        type: this.formatterTypes[this.form.table.columns[index].formatterTypeIndex].type
                    }
                    if (this.form.table.columns[index].formatter.type == 'SWITCH') {
                        this.form.table.columns[index].formatter.active = {
                            value: '',
                            label: ''
                        }
                        this.form.table.columns[index].formatter.inactive = {
                            value: '',
                            label: ''
                        }
                    } else if (this.form.table.columns[index].formatter.type == 'URL') {
                        this.form.table.columns[index].formatter.target = '_blank'
                        this.form.table.columns[index].formatter.text = ''
                    } else if (this.form.table.columns[index].formatter.type == 'PIC') {
                        this.form.table.columns[index].formatter.width = '50'
                        this.form.table.columns[index].formatter.height = '50'
                    } else if (this.form.table.columns[index].formatter.type == 'TEXT') {
                        this.form.table.columns[index].formatter.map = {}
                        this.formatterText = {
                            visible: true,
                            index: index,
                            map: []
                        }
                    }
                    this.form = JSON.parse(JSON.stringify(this.form))
                } else {
                    delete this.form.table.columns[index].formatterTypeIndex
                    delete this.form.table.columns[index].formatter
                }
            },
            /**
             * 新增编辑按钮变化
             */
            addOrEditBtnChange() {
                if (this.form.add_btn || this.form.edit_btn) {
                    // this.mainAdd.rules.elements[0].required = true
                } else {
                    // this.mainAdd.rules.elements[0].required = false
                }
            },
            addSelectColumn(column) {
                if (this.form.table.select.alias == column.alias) {
                    this.form.table.select.columns.push(column.key + ' as ' + column.key + '_' + column.alias)
                } else {
                    for (let i = 0; i < this.form.table.select.leftJoins.length; i ++) {
                        if (this.form.table.select.leftJoins[i].alias == column.alias) {
                            this.form.table.select.leftJoins[i].columns.push(column.key + ' as ' + column.key + '_' + column.alias)
                            break;
                        }
                    }
                }
            },
            addTableColumn() {
                if (this.tableColumnDialog.item != null && typeof this.tableColumnDialog.item != 'undefined') {
                    let aa = this.tableColumnDialog.item.split(',');
                    let table = aa[0], key = aa[1];
                    for (let i = 0; i < this.mainTableColumns.length; i++) {
                        if (this.mainTableColumns[i].label == table) {
                            if (this.mainTableColumns[i].options && this.mainTableColumns[i].options.length > 0) {
                                for (let j = 0; j < this.mainTableColumns[i].options.length; j ++) {
                                    if (this.mainTableColumns[i].options[j].key === key) {
                                        this.form.table.columns.push({
                                            key: this.mainTableColumns[i].options[j].key,
                                            prop: this.mainTableColumns[i].options[j].key + '_' + this.mainTableColumns[i].options[j].alias,
                                            option: JSON.stringify(this.mainTableColumns[i].options[j])
                                        })
                                        this.addSelectColumn(this.mainTableColumns[i].options[j])
                                        this.mainTableColumns[i].options.splice(j, 1)
                                        this.$refs.mainTableForm.validateField("columns");
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                this.closeTableColumnDialog()
            },
            closeTableColumnDialog() {
                this.tableColumnDialog = {
                    visible : false
                }
            },
            showAddTableColumnDialog() {
                this.tableColumnDialog = {
                    visible : true
                }
            },
            preview() {
                window.open(window.contextPath + "/pages/preview.html")
            },
            init(mainDb, oneToOnes, oneToMores) {
                window.vue.mainDb = mainDb
                window.vue.oneToOnes = oneToOnes
                window.vue.oneToMores = oneToMores
                window.vue.mainTableColumns = []
                window.vue.mainSearchColumns = []
                window.vue.mainFormColumns = []
                window.vue.form = {
                    table: {
                        columns: [],
                        select: {
                            columns: [],
                            wheres: [],
                            leftJoins: [],
                            searchElements: []
                        },
                        pagination: false
                    },
                    add_form: {
                        elements: [],
                        unique_columns: []
                    }
                }
                window.vue.search = {
                    elements: []
                }
                if (window.vue.mainDb && window.vue.mainDb.columns && window.vue.mainDb.columns.length > 0) {
                    window.vue.form.table.select.schema = window.vue.mainDb.schema
                    window.vue.form.table.select.table = window.vue.mainDb.table
                    window.vue.form.table.select.alias = 'a'
                    window.vue.form.table.select.primaryKey = window.vue.mainDb.primaryKey
                    window.vue.form.add_form.schema = window.vue.mainDb.schema
                    window.vue.form.add_form.table = window.vue.mainDb.table
                    window.vue.form.add_form.primaryKey = window.vue.mainDb.primaryKey
                    let column = {
                        label: window.vue.mainDb.schema + '.' + window.vue.mainDb.table,
                        options: []
                    }
                    let formColumn = {
                        label: window.vue.mainDb.schema + '.' + window.vue.mainDb.table,
                        options: []
                    }
                    for (let i = 0; i < window.vue.mainDb.columns.length; i ++) {
                        column.options.push({
                            key: window.vue.mainDb.columns[i].name,
                            dataType: window.vue.mainDb.columns[i].type,
                            label: window.vue.mainDb.schema + '.' +window.vue.mainDb.table,
                            alias: 'a'
                        })
                        if (window.vue.mainDb.columns[i].name != window.vue.mainDb.primaryKey) {
                            formColumn.options.push({
                                key: window.vue.mainDb.columns[i].name,
                                dataType: window.vue.mainDb.columns[i].type,
                                label: window.vue.mainDb.schema + '.' +window.vue.mainDb.table,
                                alias: 'a'
                            })
                        }
                    }
                    window.vue.mainTableColumns.push(column)
                    window.vue.mainFormColumns.push(formColumn)
                }
                if (window.vue.oneToOnes && window.vue.oneToOnes.length > 0) {
                    for (let i = 0; i < window.vue.oneToOnes.length; i ++) {
                        if (window.vue.oneToOnes[i].columns && window.vue.oneToOnes[i].columns.length > 0) {
                            window.vue.form.table.select.leftJoins.push({
                                alias: 'a' + i,
                                table: window.vue.oneToOnes[i].table,
                                schema: window.vue.oneToOnes[i].schema,
                                parentKey: window.vue.oneToOnes[i].parentKey,
                                relateKey: window.vue.oneToOnes[i].relateKey,
                                columns: []
                            })
                            let column = {
                                label: window.vue.oneToOnes[i].schema + '.' + window.vue.oneToOnes[i].table,
                                options: []
                            }
                            for (let j = 0; j < window.vue.oneToOnes[i].columns.length; j ++) {
                                column.options.push({
                                    key: window.vue.oneToOnes[i].columns[j].name,
                                    dataType: window.vue.oneToOnes[i].columns[j].type,
                                    label: window.vue.oneToOnes[i].schema + '.' +window.vue.oneToOnes[i].table,
                                    alias: 'a' + i
                                })
                            }
                            window.vue.mainTableColumns.push(column)
                        }
                    }
                }
                window.vue.mainSearchColumns = JSON.parse(JSON.stringify(window.vue.mainTableColumns))
            }
        },
        created: function () {
            axios.get(window.contextPath + '/api/formatterTypes', {
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.formatterTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })

            axios.get(window.contextPath + '/api/whereTypes', {
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.whereTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })

            window.setInterval(() => {
                let obj = JSON.parse(JSON.stringify(this.form))
                obj.search = JSON.parse(JSON.stringify(this.search))
                let configStr = JSON.stringify(obj)
                localStorage.setItem('config', [configStr])
            }, 100)
        }
    })
</script>
</body>
</html>