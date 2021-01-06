<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>基础配置</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
        .el-card__header {
            padding-bottom: 2px;
        }
        body {
            margin-top: 0px;
            margin-bottom: 0px;
        }
    </style>
</head>
<body>
<div id="app" v-loading="loading">
    <el-form :model="form" :rules="rules" ref="form" size="small" v-if="mainDb">
        <el-collapse v-model="accordionActiveName">
            <el-collapse-item :title="'主表 - ' + form.table.select.schema + '.' + form.table.select.table" name="main">
                <div  style="padding-left: 20px;">
                    <el-row :gutter="24">
                        <el-col :span="6">
                            <el-form-item label="页面标题:"
                                          :rules="[{required: true, message: '请输入页面标题', trigger: 'change'}]"
                                          prop="title" label-width="100px">
                                <el-input v-model.trim="form.title" autocomplete="off" size="small"
                                          maxlength="200"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="允许新增:" prop="add_btn" label-width="100px">
                                <el-select style="width: 100%" v-model="form.add_btn" @change="addEditDeleteBtnChange(form)">
                                    <el-option :key="true" label="是" :value="true"></el-option>
                                    <el-option :key="false" label="否" :value="false"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="允许编辑:" prop="edit_btn" label-width="100px">
                                <el-select style="width: 100%" v-model="form.edit_btn" @change="addEditDeleteBtnChange(form)">
                                    <el-option :key="true" label="是" :value="true"></el-option>
                                    <el-option :key="false" label="否" :value="false"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="允许删除:" prop="delete_btn" label-width="100px">
                                <el-select style="width: 100%" v-model="form.delete_btn" @change="addEditDeleteBtnChange(form)">
                                    <el-option :key="true" label="是" :value="true"></el-option>
                                    <el-option :key="false" label="否" :value="false"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="24">
                            <el-collapse v-model="activeNames">
                                <el-collapse-item title="表格配置" name="table">
                                    <el-card shadow="hover">
                                        <el-col :span="6">
                                            <el-form-item label="是否分页:"
                                                          :prop="'table.pagination'"
                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                          label-width="100px">
                                                <el-select style="width: 100%" v-model="form.table.pagination">
                                                    <el-option :key="true" label="是" :value="true"></el-option>
                                                    <el-option :key="false" label="否" :value="false"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="6">
                                            <el-form-item label="默认排序字段:" :prop="'table.defaultSortColumn'"
                                                          label-width="100px">
                                                <el-select style="width: 100%" clearable @change="defaultSortColumnChange(form.table)"
                                                           v-model.trim="form.table.defaultSortColumn">
                                                    <el-option v-for="(column) in mainDb.columns" :key="column.name"
                                                               :label="'列名:' + column.name + ' 类型:' + column.type"
                                                               :value="column.name">
                                                    </el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="6" v-if="form.table.defaultSortColumn">
                                            <el-form-item label="排序方式:" :prop="'table.defaultOrder'"
                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                          label-width="100px">
                                                <el-select style="width: 100%" v-model.trim="form.table.defaultOrder">
                                                    <el-option key="asc" label="正序" value="asc"></el-option>
                                                    <el-option key="desc" label="倒序" value="desc"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="24">
                                            <el-card shadow="hover" style="margin-bottom: 8px;">
                                                <div slot="header">
                                                    <el-form-item label="查询列" :prop="'table.columns'" :rules="rules.columns" label-width="100px">
                                                        <el-button type="text" plain @click="showAddTableColumn(mainColumns, ['form','table'])">添加</el-button>
                                                    </el-form-item>
                                                </div>
                                                <el-card shadow="hover" v-for="(item,index) in form.table.columns" style="margin-bottom: 8px;">
                                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                                        <el-col :span="6">
                                                            <el-form-item label="sql查询字段:" label-width="120px">
                                                                {{item.key}}
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="前端列头文案:" label-width="120px"
                                                                          :prop="'table.columns.' + index + '.label'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                                                                <el-input v-model.trim="item.label" placeholder="" maxlength="50"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="前端列宽度:" label-width="120px"
                                                                          :prop="'table.columns.' + index + '.width'"
                                                                          :rules="rules.zNumber">
                                                                <el-input v-model.trim="item.width" placeholder="单位px" maxlength="50"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="是否可以排序:" label-width="100px">
                                                                <el-select style="width: 100%" v-model.trim="item.sortable"
                                                                           placeholder="默认否">
                                                                    <el-option :key="true" label="是" :value="true"></el-option>
                                                                    <el-option :key="false" label="否" :value="false"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="格式化类型:" label-width="100px">
                                                                <el-select style="width: 100%" clearable
                                                                           v-model.trim="item.formatter"
                                                                           value-key="className"
                                                                           @change="formatterTypeChange(item,['form','table','columns',index])">
                                                                    <el-option v-for="(type,formatterTypeIndex) in formatterTypes"
                                                                               :key="type.value" :value="type.value" :label="type.label" >
                                                                    </el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'PIC'">
                                                            <el-form-item label="图片展示宽度:"
                                                                          :prop="'table.columns.' + index + '.formatter.width'"
                                                                          :rules="rules.zNumberMust"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.formatter.width"  placeholder="单位px"
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'PIC'">
                                                            <el-form-item label="图片展示高度:"
                                                                          :prop="'table.columns.' + index + '.formatter.height'"
                                                                          :rules="rules.zNumberMust"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.formatter.height"  placeholder="单位px"
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                            <el-form-item label="选中选项的值:"
                                                                          :prop="'table.columns.' + index + '.formatter.active.value'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.formatter.active.value" placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                            <el-form-item label="选中选项的标签:"
                                                                          :prop="'table.columns.' + index + '.formatter.active.label'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="130px">
                                                                <el-input v-model.trim="item.formatter.active.label" placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                            <el-form-item label="未选中选项的值:"
                                                                          :prop="'table.columns.' + index + '.formatter.inactive.value'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="130px">
                                                                <el-input v-model.trim="item.formatter.inactive.value" placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                            <el-form-item label="未选中选项的标签:"
                                                                          :prop="'table.columns.' + index + '.formatter.inactive.label'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="140px">
                                                                <el-input v-model.trim="item.formatter.inactive.label" placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'URL'">
                                                            <el-form-item label="链接打开方式:"
                                                                          :prop="'table.columns.' + index + '.formatter.target'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                                          label-width="120px">
                                                                <el-select style="width: 100%" v-model="item.formatter.target"
                                                                           placeholder="请选择链接打开方式">
                                                                    <el-option key="_blank" label="新开窗口" value="_blank"></el-option>
                                                                    <el-option key="_self" label="当前窗口" value="_self"></el-option>
                                                                    <el-option key="_parent" label="父级窗口" value="_parent"></el-option>
                                                                    <el-option key="_top" label="顶层窗口" value="_top"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'URL'">
                                                            <el-form-item label="链接文案:"
                                                                          :prop="'table.columns.' + index + '.formatter.text'"
                                                                          :rules="[{required: false, message: '请输入', trigger: 'change'}]"
                                                                          label-width="100px">
                                                                <el-input v-model.trim="item.formatter.text" placeholder="默认链接本身"
                                                                          autocomplete="off" size="small" maxlength="100"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="12" v-if="item.formatter && item.formatter.type && item.formatter.type == 'TEXT'">
                                                            <el-form-item label="文本格式化:" label-width="100px">
                                                                <span>{{item.formatter.map | json}}</span>
                                                                <el-button type="text" plain v-if="!item.formatter.map" @click="showFormatterTextDialog(item,['form','table','columns',index])">添加</el-button>
                                                                <el-button type="text" plain v-if="item.formatter.map" @click="showFormatterTextDialog(item,['form','table','columns',index])">修改</el-button>
                                                                <el-button type="text" plain v-if="item.formatter.map" @click="deleteFormatterTextDialog(item,['form','table','columns',index])">删除</el-button>
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
                                                                       @click="removeTableColumn(item, index, form.table)">移除</el-button>
                                                        </el-col>
                                                    </el-row>
                                                </el-card>
                                            </el-card>
                                        </el-col>
                                        <el-col :span="24">
                                            <el-card shadow="hover" style="margin-bottom: 8px;">
                                                <div slot="header">
                                                    <el-form-item label="默认查询条件" label-width="100px">
                                                        <el-button type="text" plain @click="showAddWhereColumn(mainColumns, ['form','table'])">添加</el-button>
                                                    </el-form-item>
                                                </div>
                                                <template v-if="form.table && form.table.select && form.table.select.wheres && form.table.select.wheres.length > 0">
                                                    <el-card shadow="hover" v-for="(item,index) in form.table.select.wheres" style="margin-bottom: 8px;">
                                                        <el-row style="border: 0px solid gray;" :gutter="24">
                                                            <el-col :span="6">
                                                                <el-form-item label="sql查询字段:" label-width="100px">
                                                                    {{form.table.select.schema}}.{{form.table.select.table}} -> {{item.key}}
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="类型:" label-width="100px"
                                                                              :prop="'table.select.wheres.' + index + '.className'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" clearable
                                                                               v-model.trim="item.className"
                                                                               @change="whereTypeChange(item)">
                                                                        <el-option v-for="(type,whereTypeIndex) in whereTypes"
                                                                                   :key="type.value" :value="type.value" :label="type.label" >
                                                                        </el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6"
                                                                    v-if="item.type && (item.type == 'eq' || item.type == 'gt' || item.type == 'gteq' || item.type == 'lt' || item.type == 'lteq' || item.type == 'like')">
                                                                <el-form-item label="值:" label-width="100px"
                                                                              :prop="'table.select.wheres.' + index + '.value'"
                                                                              :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.value" placeholder="" maxlength="50"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                <el-form-item label="最小值:" label-width="100px"
                                                                              :prop="'table.select.wheres.' + index + '.begin'"
                                                                              :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.begin" placeholder="" maxlength="50"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                <el-form-item label="最大值:" label-width="100px"
                                                                              :prop="'table.select.wheres.' + index + '.end'"
                                                                              :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.end" placeholder="" maxlength="50"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="12" v-if="item.type && item.type == 'in'">
                                                                <el-form-item label="集合值:" label-width="100px">
                                                                    {{item.values | json}}
                                                                    <el-button type="text" plain @click="editWhereInValues(item)">修改</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="24" style="text-align: right;">
                                                                <el-button type="danger" plain size="mini"
                                                                           @click="justRemove(item, index, form.table.select.wheres)">移除</el-button>
                                                            </el-col>
                                                        </el-row>
                                                    </el-card>
                                                </template>
                                                <template v-if="form.table && form.table.select && form.table.select.leftJoins && form.table.select.leftJoins.length > 0">
                                                    <template v-for="(leftJoin, leftJoinIndex) in form.table.select.leftJoins">
                                                        <template v-if="leftJoin.wheres && leftJoin.wheres.length > 0">
                                                            <el-card shadow="hover" v-for="(item,index) in leftJoin.wheres" style="margin-bottom: 8px;">
                                                                <el-row style="border: 0px solid gray;" :gutter="24">
                                                                    <el-col :span="6">
                                                                        <el-form-item label="sql查询字段:" label-width="100px">
                                                                            {{form.table.select.leftJoins[leftJoinIndex].schema}}.{{form.table.select.leftJoins[leftJoinIndex].table}} -> {{item.key}}
                                                                        </el-form-item>
                                                                    </el-col>
                                                                    <el-col :span="6">
                                                                        <el-form-item label="类型:" label-width="100px"
                                                                                      :prop="'table.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.className'"
                                                                                      :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                            <el-select style="width: 100%" clearable
                                                                                       v-model.trim="item.className"
                                                                                       @change="whereTypeChange(item)">
                                                                                <el-option v-for="(type,whereTypeIndex) in whereTypes"
                                                                                           :key="type.value" :value="type.value" :label="type.label" >
                                                                                </el-option>
                                                                            </el-select>
                                                                        </el-form-item>
                                                                    </el-col>
                                                                    <el-col :span="6"
                                                                            v-if="item.type && (item.type == 'eq' || item.type == 'gt' || item.type == 'gteq' || item.type == 'lt' || item.type == 'lteq' || item.type == 'like')">
                                                                        <el-form-item label="值:" label-width="100px"
                                                                                      :prop="'table.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.value'"
                                                                                      :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                            <el-input v-model.trim="item.value" placeholder="" maxlength="50"
                                                                                      autocomplete="off" size="small"></el-input>
                                                                        </el-form-item>
                                                                    </el-col>
                                                                    <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                        <el-form-item label="最小值:" label-width="100px"
                                                                                      :prop="'table.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.begin'"
                                                                                      :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                            <el-input v-model.trim="item.begin" placeholder="" maxlength="50"
                                                                                      autocomplete="off" size="small"></el-input>
                                                                        </el-form-item>
                                                                    </el-col>
                                                                    <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                        <el-form-item label="最大值:" label-width="100px"
                                                                                      :prop="'table.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.end'"
                                                                                      :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                            <el-input v-model.trim="item.end" placeholder="" maxlength="50"
                                                                                      autocomplete="off" size="small"></el-input>
                                                                        </el-form-item>
                                                                    </el-col>
                                                                    <el-col :span="12" v-if="item.type && item.type == 'in'">
                                                                        <el-form-item label="集合值:" label-width="100px">
                                                                            {{item.values | json}}
                                                                            <el-button type="text" plain @click="editWhereInValues(item)">修改</el-button>
                                                                        </el-form-item>
                                                                    </el-col>
                                                                    <el-col :span="24" style="text-align: right;">
                                                                        <el-button type="danger" plain size="mini"
                                                                                   @click="justRemove(item, index, form.table.select.leftJoins[leftJoinIndex].wheres)">移除</el-button>
                                                                    </el-col>
                                                                </el-row>
                                                            </el-card>
                                                        </template>
                                                    </template>
                                                </template>
                                            </el-card>
                                        </el-col>
                                    </el-card>
                                </el-collapse-item>
                                <el-collapse-item title="搜索表单" name="search">
                                    <el-card shadow="hover">
                                        <el-col :span="24"  style="margin-bottom: 8px;">
                                            <el-button type="text" plain @click="showAddSearchColumn(mainColumns, ['form','table'])">添加表单项</el-button>
                                        </el-col>
                                        <template v-if="form.table && form.table.select && form.table.select.searchElements && form.table.select.searchElements.length > 0">
                                            <el-card shadow="hover" v-for="(item,index) in form.table.select.searchElements" style="margin-bottom: 8px;">
                                                <el-row style="border: 0px solid gray;" :gutter="24">
                                                    <el-col :span="6">
                                                        <el-form-item label="sql查询字段:" label-width="100px">
                                                            {{aliasTable[item.alias].schema}}.{{aliasTable[item.alias].table}} -> {{item.key}}
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="6">
                                                        <el-form-item label="前端文案:" label-width="100px"
                                                                      :prop="'table.select.searchElements.' + index + '.label'"
                                                                      :rules="[{required: true, message: '前端文案不能为空', trigger: 'change'}]">
                                                            <el-input v-model.trim="item.label" placeholder="" maxlength="100"
                                                                      autocomplete="off" size="small"></el-input>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="6">
                                                        <el-form-item label="前端提示信息:" label-width="120px"
                                                                      :prop="'table.select.searchElements.' + index + '.placeholder'">
                                                            <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                      autocomplete="off" size="small"></el-input>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="6">
                                                        <el-form-item label="输入框宽度:"
                                                                      :prop="'table.select.searchElements.' + index + '.width'"
                                                                      :rules="rules.zNumberMust"
                                                                      label-width="120px">
                                                            <el-input v-model.trim="item.width"  placeholder="单位px"
                                                                      autocomplete="off" size="small" maxlength="50"></el-input>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="6">
                                                        <el-form-item label="类型:" label-width="100px"
                                                                      :prop="'table.select.searchElements.' + index + '.className'"
                                                                      :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                            <el-select style="width: 100%" clearable
                                                                       v-model.trim="item.className"
                                                                       @change="searchTypeChange(item,['form','table','select','searchElements',index])">
                                                                <el-option v-for="(type,searchTypeIndex) in searchTypes"
                                                                           :key="type.value" :value="type.value" :label="type.label" >
                                                                </el-option>
                                                            </el-select>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="6">
                                                        <el-form-item label="默认值:" label-width="100px"
                                                                      :prop="'table.select.searchElements.' + index + '.defaultValue'">
                                                            <el-input v-model.trim="item.defaultValue" placeholder="" maxlength="100"
                                                                      autocomplete="off" size="small"></el-input>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="6"
                                                            v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') > -1">
                                                        <el-form-item label="远程下拉菜单配置:" label-width="130px">
                                                            {{item.schema}}.{{item.table}}[{{item.keyColumn}}-{{item.valueColumn}}]
                                                            <el-button type="text" plain @click="editRemoteSelect(item,['form','table','select','searchElements',index])">修改</el-button>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="12"
                                                            v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') == -1 && item.className.indexOf('.SearchSelect') > -1">
                                                        <el-form-item label="下拉选项配置:" label-width="130px">
                                                            {{item.options | json}}
                                                            <el-button type="text" plain @click="editSelect(item,['form','table','select','searchElements',index])">修改</el-button>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="24" style="text-align: right;">
                                                        <el-button type="danger" plain size="mini"
                                                                   @click="justRemove(item, index, form.table.select.searchElements)">移除</el-button>
                                                    </el-col>
                                                </el-row>
                                            </el-card>
                                        </template>
                                        <template v-if="form.table && form.table.select && form.table.select.leftJoins && form.table.select.leftJoins.length > 0">
                                            <template v-for="(leftJoin, leftJoinIndex) in form.table.select.leftJoins">
                                                <template v-if="leftJoin.searchElements && leftJoin.searchElements.length > 0">
                                                    <el-card shadow="hover" v-for="(item,index) in leftJoin.searchElements" style="margin-bottom: 8px;">
                                                        <el-row style="border: 0px solid gray;" :gutter="24">
                                                            <el-col :span="6">
                                                                <el-form-item label="sql查询字段:" label-width="100px">
                                                                    {{aliasTable[item.alias].schema}}.{{aliasTable[item.alias].table}} -> {{item.key}}
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="前端文案:" label-width="100px"
                                                                              :prop="'table.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.label'"
                                                                              :rules="[{required: true, message: '前端文案不能为空', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.label" placeholder="" maxlength="100"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="前端提示信息:" label-width="120px"
                                                                              :prop="'table.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.placeholder'">
                                                                    <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="输入框宽度:"
                                                                              :prop="'table.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.width'"
                                                                              :rules="rules.zNumberMust"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.width"  placeholder="单位px"
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="类型:" label-width="100px"
                                                                              :prop="'table.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.className'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" clearable
                                                                               v-model.trim="item.className"
                                                                               @change="searchTypeChange(item,['form','table','select','leftJoins',leftJoinIndex,'searchElements',index])">
                                                                        <el-option v-for="(type,searchTypeIndex) in searchTypes"
                                                                                   :key="type.value" :value="type.value" :label="type.label" >
                                                                        </el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="默认值:" label-width="100px"
                                                                              :prop="'table.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.defaultValue'">
                                                                    <el-input v-model.trim="item.defaultValue" placeholder="" maxlength="100"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6"
                                                                    v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') > -1">
                                                                <el-form-item label="远程下拉菜单配置:" label-width="130px">
                                                                    {{item.schema}}.{{item.table}}[{{item.keyColumn}}-{{item.valueColumn}}]
                                                                    <el-button type="text" plain @click="editRemoteSelect(item,['form','table','select','leftJoins',leftJoinIndex,'searchElements',index])">修改</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="12"
                                                                    v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') == -1 && item.className.indexOf('.SearchSelect') > -1">
                                                                <el-form-item label="下拉选项配置:" label-width="130px">
                                                                    {{item.options | json}}
                                                                    <el-button type="text" plain @click="editSelect(item,['form','table','select','leftJoins',leftJoinIndex,'searchElements',index])">修改</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="24" style="text-align: right;">
                                                                <el-button type="danger" plain size="mini"
                                                                           @click="justRemove(item, index, form.table.select.leftJoins[leftJoinIndex].searchElements)">移除</el-button>
                                                            </el-col>
                                                        </el-row>
                                                    </el-card>
                                                </template>
                                            </template>
                                        </template>
                                    </el-card>
                                </el-collapse-item>
                                <el-collapse-item title="新增/编辑表单" name="add" v-if="form.add_form">
                                    <el-card shadow="hover">
                                        <el-row :gutter="24">
                                            <el-col :span="6">
                                                <el-form-item label="前端弹窗宽（%）:" :prop="'add_form.width'" label-width="140px">
                                                    <el-input-number size="small" v-model="form.add_form.width"
                                                                     :min="50" :max="100"
                                                                     style="width: 100%"></el-input-number>
                                                </el-form-item>
                                            </el-col>
                                        </el-row>
                                        <el-card shadow="hover" style="margin-bottom: 8px;">
                                            <div slot="header">
                                                <el-form-item label="表单项" :prop="'add_form.elements'" :rules="rules.columns" label-width="100px">
                                                    <el-button type="text" plain @click="showAddFormColumn(mainColumns[0], ['form'])">添加</el-button>
                                                </el-form-item>
                                            </div>
                                            <template v-if="form.add_form.elements && form.add_form.elements.length > 0">
                                                <el-card shadow="hover" v-for="(item,index) in form.add_form.elements" style="margin-bottom: 8px;">
                                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                                        <el-col :span="6">
                                                            <el-form-item label="字段:" label-width="100px">
                                                                <el-input v-model.trim="item.key" placeholder="" maxlength="100"
                                                                          :prop="'add_form.elements.' + index + '.key'"
                                                                          :rules="[{required: true, message: '不能为空', trigger: 'change'}]"
                                                                          autocomplete="off" size="small" readOnly="true"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="类型:" label-width="100px"
                                                                          :prop="'add_form.elements.' + index + '.className'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" clearable
                                                                           v-model.trim="item.className"
                                                                           @change="addElementTypeChange(item,['form','add_form','elements',index])">
                                                                    <el-option v-for="(type,addElementTypeIndex) in addElementTypes"
                                                                               :key="type.value" :value="type.value" :label="type.label" >
                                                                    </el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('label') > -1">
                                                            <el-form-item label="控件标题:" label-width="100px"
                                                                          :prop="'add_form.elements.' + index + '.label'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                                                                <el-input v-model.trim="item.label" placeholder="" maxlength="20"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('type') > -1">
                                                            <el-form-item label="文本框类型:" label-width="110px"
                                                                          :prop="'add_form.elements.' + index + '.type'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" v-model.trim="item.type">
                                                                    <el-option key="text" label="普通单行" value="text"></el-option>
                                                                    <el-option key="textarea" label="多行" value="textarea"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('placeholder') > -1">
                                                            <el-form-item label="输入框提示文案:" label-width="120px"
                                                                          :prop="'add_form.elements.' + index + '.placeholder'"
                                                                          :rules="[{required: false, message: '请输入', trigger: 'change'}]">
                                                                <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('clearable') > -1">
                                                            <el-form-item label="是否可一键清空:" label-width="130px"
                                                                          :prop="'add_form.elements.' + index + '.clearable'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" v-model.trim="item.clearable">
                                                                    <el-option :key="true" label="是" :value="true"></el-option>
                                                                    <el-option :key="false" label="否" :value="false"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('to') > -1">
                                                            <el-form-item label="转换格式:" label-width="110px"
                                                                          :prop="'add_form.elements.' + index + '.to'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" v-model.trim="item.to">
                                                                    <el-option key="java.lang.String" label="java.lang.String" value="java.lang.String"></el-option>
                                                                    <el-option key="java.lang.Long" label="java.lang.Long" value="java.lang.Long"></el-option>
                                                                    <el-option key="java.util.Date" label="java.util.Date" value="java.util.Date"></el-option>
                                                                    <el-option key="java.sql.Timestamp" label="java.sql.Timestamp" value="java.sql.Timestamp"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('size') > -1">
                                                            <el-form-item label="控件大小:" label-width="110px"
                                                                          :prop="'add_form.elements.' + index + '.size'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" v-model.trim="item.size">
                                                                    <el-option key="mini" label="小" value="mini"></el-option>
                                                                    <el-option key="small" label="中" value="small"></el-option>
                                                                    <el-option key="medium" label="大" value="medium"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('width') > -1">
                                                            <el-form-item label="控件宽度:"
                                                                          :prop="'add_form.elements.' + index + '.width'"
                                                                          :rules="rules.number"
                                                                          label-width="100px">
                                                                <el-input v-model.trim="item.width"  placeholder="单位px"
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('minlength') > -1">
                                                            <el-form-item label="最小输入长度:"
                                                                          :prop="'add_form.elements.' + index + '.minlength'"
                                                                          :rules="rules.zNumber"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.minlength"  placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('maxlength') > -1">
                                                            <el-form-item label="最大输入长度:"
                                                                          :prop="'add_form.elements.' + index + '.maxlength'"
                                                                          :rules="rules.zNumber"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.maxlength"  placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('min') > -1">
                                                            <el-form-item label="计数器最小值:"
                                                                          :prop="'add_form.elements.' + index + '.min'"
                                                                          :rules="rules.number"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.min"  placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('max') > -1">
                                                            <el-form-item label="计数器最大值:"
                                                                          :prop="'add_form.elements.' + index + '.max'"
                                                                          :rules="rules.number"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.max"  placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('precision') > -1">
                                                            <el-form-item label="数值精度:"
                                                                          :prop="'add_form.elements.' + index + '.precision'"
                                                                          :rules="rules.number"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.precision"  placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('start') > -1">
                                                            <el-form-item label="开始时间:"
                                                                          :prop="'add_form.elements.' + index + '.start'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="100px">
                                                                <el-time-select style="width: 100%"
                                                                                v-model.trim="item.start"
                                                                                :picker-options="{start: '00:00',step: '00:01',end: '23:59'}"
                                                                                placeholder="选择开始时间">
                                                                </el-time-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('end') > -1">
                                                            <el-form-item label="截止时间:"
                                                                          :prop="'add_form.elements.' + index + '.end'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="100px">
                                                                <el-time-select style="width: 100%"
                                                                                v-model.trim="item.end"
                                                                                :picker-options="{start: '00:00',step: '00:01',end: '23:59'}"
                                                                                placeholder="选择截止时间">
                                                                </el-time-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('step') > -1">
                                                            <el-form-item label="步长:" v-if="item.className.indexOf('.AddInputNumber') > -1"
                                                                          :prop="'add_form.elements.' + index + '.step'"
                                                                          :rules="rules.number"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.step"  placeholder=""
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                            <el-form-item label="时间间隔:" v-if="item.className.indexOf('.AddTimePicker') > -1"
                                                                          :prop="'add_form.elements.' + index + '.step'"
                                                                          :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                          label-width="100px">
                                                                <el-time-select v-model.trim="item.step" style="width: 100%"
                                                                                :picker-options="{start: '00:00',step: '00:01',end: '23:59'}"
                                                                                placeholder="时间间隔">
                                                                </el-time-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('acceptType') > -1">
                                                            <el-form-item label="图片格式限制:" label-width="120px"
                                                                          :prop="'add_form.elements.' + index + '.acceptType'"
                                                                          :rules="[{required: false, message: '请输入', trigger: 'change'}]">
                                                                <el-input v-model.trim="item.acceptType" placeholder="例：'.jpg,.PNG'，多个使用逗号分隔" maxlength="100"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('limitSize') > -1">
                                                            <el-form-item label="图片大小限制:"
                                                                          :prop="'add_form.elements.' + index + '.limitSize'"
                                                                          :rules="rules.zNumber"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.limitSize"  placeholder="单位：字节"
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('remoteSelect') > -1">
                                                            <el-form-item label="远程下拉菜单配置:" label-width="130px">
                                                                {{item.schema}}.{{item.table}}[{{item.keyColumn}}-{{item.valueColumn}}]
                                                                <el-button type="text" plain @click="editRemoteSelect(item,['form','add_form','elements',index])">修改</el-button>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="12" v-if="item.className && addElementShows[item.className].indexOf('select') > -1">
                                                            <el-form-item label="下拉选项配置:" label-width="130px">
                                                                {{item.options | json}}
                                                                <el-button type="text" plain @click="editSelect(item,['form','add_form','elements',index])">修改</el-button>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="12" v-if="item.className && addElementShows[item.className].indexOf('radio') > -1">
                                                            <el-form-item label="单选框配置:" label-width="130px">
                                                                {{item.radios | json}}
                                                                <el-button type="text" plain @click="editSelect(item,['form','add_form','elements',index])">修改</el-button>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="12" v-if="item.className && addElementShows[item.className].indexOf('rule') > -1">
                                                            <el-form-item label="前端校验规则:" label-width="130px">
                                                                {{item.rule | json}}
                                                                <el-button type="text" v-if="!item.rule" plain @click="showAddRule(item,['form','add_form','elements',index])">添加</el-button>
                                                                <el-button type="text" v-if="item.rule" plain @click="showAddRule(item,['form','add_form','elements',index])">修改</el-button>
                                                                <el-button type="text" v-if="item.rule" plain @click="delAddRule(item)">删除</el-button>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('canEdit') > -1">
                                                            <el-form-item label="是否可编辑:" label-width="130px"
                                                                          :prop="'add_form.elements.' + index + '.canEdit'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" v-model.trim="item.canEdit">
                                                                    <el-option :key="true" label="是" :value="true"></el-option>
                                                                    <el-option :key="false" label="否" :value="false"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="24" style="text-align: right;">
                                                            <el-button-group>
                                                                <el-button type="primary" size="mini" icon="el-icon-arrow-up"
                                                                           v-if="index != 0"
                                                                           @click="up(item, index, form.add_form.elements)">上移</el-button>
                                                                <el-button type="primary" size="mini" icon="el-icon-arrow-down"
                                                                           v-if="index != form.add_form.elements.length - 1"
                                                                           @click="down(item, index, form.add_form.elements)">下移</el-button>
                                                            </el-button-group>
                                                            <el-button type="danger" plain size="mini"
                                                                       @click="justRemove(item, index, form.add_form.elements)">移除</el-button>
                                                        </el-col>
                                                    </el-row>
                                                </el-card>
                                            </template>
                                        </el-card>
                                        <el-card shadow="hover" style="margin-bottom: 8px;">
                                            <div slot="header">
                                                <el-form-item label="唯一键组合" :prop="'add_form.unique_columns'" :rules="rules.unique_columns" label-width="100px">
                                                    <el-button type="text" plain @click="addUnique(['form','add_form'])">添加</el-button>
                                                </el-form-item>
                                            </div>
                                            <template v-if="form.add_form.unique_columns && form.add_form.unique_columns.length > 0">
                                                <el-row style="border: 0px solid gray;" :gutter="24" v-for="(item,index) in form.add_form.unique_columns">
                                                    <el-col :span="10">
                                                        <el-form-item label="冲突前端提示文案:"
                                                                      :prop="'add_form.unique_columns.' + index + '.toast'"
                                                                      :rules="[{required: true, message: '请填写', trigger: 'change'}]"
                                                                      label-width="150px">
                                                            <el-input v-model.trim="item.toast" placeholder="唯一键冲突前端提示文案"
                                                                      autocomplete="off" size="small" maxlength="300"></el-input>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="10">
                                                        <el-form-item label="唯一键组合:"
                                                                      :prop="'add_form.unique_columns.' + index + '.columns'"
                                                                      :rules="rules.columns"
                                                                      label-width="130px">
                                                            <el-select size="small" v-model="item.columns" multiple placeholder="请选择唯一键组合"
                                                                       style="width: 100%;">
                                                                <el-option v-for="uniqueColumn in mainColumns[0].options"
                                                                           :key="uniqueColumn.key"
                                                                           :label="'列名:' + uniqueColumn.key + '   类型:' + uniqueColumn.dataType"
                                                                           :value="uniqueColumn.key"></el-option>
                                                            </el-select>
                                                        </el-form-item>
                                                    </el-col>
                                                    <el-col :span="4" style="text-align: right;">
                                                        <el-button type="danger" plain size="mini" @click="justRemove(item, index, form.add_form.unique_columns)">移除</el-button>
                                                    </el-col>
                                                </el-row>
                                            </template>
                                        </el-card>
                                    </el-card>
                                </el-collapse-item>
                            </el-collapse>
                        </el-col>
                    </el-row>
                </div>
            </el-collapse-item>
            <template v-if="form.follow_tables && form.follow_tables.length > 0">
                <el-collapse-item :title="'从表 - ' + follow.select.schema + '.' + follow.select.table" :name="'follow' + followIndex" v-for="(follow,followIndex) in form.follow_tables">
                    <div  style="padding-left: 20px;">
                        <el-row :gutter="24">
                            <el-col :span="6">
                                <el-form-item label="按钮文案:"
                                              :rules="[{required: true, message: '请输入按钮文案', trigger: 'change'}]"
                                              :prop="'follow_tables.' + followIndex + '.bottomName'"
                                              label-width="100px">
                                    <el-input v-model.trim="follow.bottomName" autocomplete="off" size="small"
                                              maxlength="200"></el-input>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="允许新增:"
                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                              :prop="'follow_tables.' + followIndex + '.add_btn'"
                                              label-width="100px">
                                    <el-select style="width: 100%" v-model="follow.add_btn" @change="addEditDeleteBtnChange(form.follow_tables[followIndex])">
                                        <el-option :key="true" label="是" :value="true"></el-option>
                                        <el-option :key="false" label="否" :value="false"></el-option>
                                    </el-select>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="允许编辑:"
                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                              :prop="'follow_tables.' + followIndex + '.edit_btn'"
                                              label-width="100px">
                                    <el-select style="width: 100%" v-model="follow.edit_btn" @change="addEditDeleteBtnChange(form.follow_tables[followIndex])">
                                        <el-option :key="true" label="是" :value="true"></el-option>
                                        <el-option :key="false" label="否" :value="false"></el-option>
                                    </el-select>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="允许删除:"
                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                              :prop="'follow_tables.' + followIndex + '.delete_btn'"
                                              label-width="100px">
                                    <el-select style="width: 100%" v-model="follow.delete_btn" @change="addEditDeleteBtnChange(form.follow_tables[followIndex])">
                                        <el-option :key="true" label="是" :value="true"></el-option>
                                        <el-option :key="false" label="否" :value="false"></el-option>
                                    </el-select>
                                </el-form-item>
                            </el-col>
                            <el-col :span="24">
                                <el-collapse v-model="followActiveNames[followIndex].activeNames">
                                    <el-collapse-item title="表格配置" name="table">
                                        <el-card shadow="hover">
                                            <el-col :span="6">
                                                <el-form-item label="是否分页:"
                                                              :prop="'follow_tables.' + followIndex + '.pagination'"
                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                              label-width="100px">
                                                    <el-select style="width: 100%" v-model="follow.pagination">
                                                        <el-option :key="true" label="是" :value="true"></el-option>
                                                        <el-option :key="false" label="否" :value="false"></el-option>
                                                    </el-select>
                                                </el-form-item>
                                            </el-col>
                                            <el-col :span="6">
                                                <el-form-item label="默认排序字段:"
                                                              :prop="'follow_tables.' + followIndex + '.defaultSortColumn'"
                                                              label-width="100px">
                                                    <el-select style="width: 100%" clearable @change="defaultSortColumnChange(follow)"
                                                               v-model.trim="follow.defaultSortColumn">
                                                        <el-option v-for="(column) in followDbs[followIndex].columns" :key="column.name"
                                                                   :label="'列名:' + column.name + ' 类型:' + column.type"
                                                                   :value="column.name">
                                                        </el-option>
                                                    </el-select>
                                                </el-form-item>
                                            </el-col>
                                            <el-col :span="6" v-if="follow.defaultSortColumn">
                                                <el-form-item label="排序方式:"
                                                              :prop="'follow_tables.' + followIndex + '.defaultOrder'"
                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                              label-width="100px">
                                                    <el-select style="width: 100%" v-model.trim="follow.defaultOrder">
                                                        <el-option key="asc" label="正序" value="asc"></el-option>
                                                        <el-option key="desc" label="倒序" value="desc"></el-option>
                                                    </el-select>
                                                </el-form-item>
                                            </el-col>
                                            <el-col :span="24">
                                                <el-card shadow="hover" style="margin-bottom: 8px;">
                                                    <div slot="header">
                                                        <el-form-item label="查询列" :prop="'follow_tables.' + followIndex + '.columns'"
                                                                      :rules="rules.columns" label-width="100px">
                                                            <el-button type="text" plain @click="showAddTableColumn(followColumns[followIndex], ['form','follow_tables',followIndex])">添加</el-button>
                                                        </el-form-item>
                                                    </div>
                                                    <el-card shadow="hover" v-for="(item,index) in form.follow_tables[followIndex].columns" style="margin-bottom: 8px;">
                                                        <el-row style="border: 0px solid gray;" :gutter="24">
                                                            <el-col :span="6">
                                                                <el-form-item label="sql查询字段:" label-width="120px">
                                                                    {{item.key}}
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="前端列头文案:" label-width="120px"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.label'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.label" placeholder="" maxlength="50"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="前端列宽度:" label-width="120px"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.width'"
                                                                              :rules="rules.zNumber">
                                                                    <el-input v-model.trim="item.width" placeholder="单位px" maxlength="50"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="是否可以排序:" label-width="100px">
                                                                    <el-select style="width: 100%" v-model.trim="item.sortable"
                                                                               placeholder="默认否">
                                                                        <el-option :key="true" label="是" :value="true"></el-option>
                                                                        <el-option :key="false" label="否" :value="false"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="格式化类型:" label-width="100px">
                                                                    <el-select style="width: 100%" clearable
                                                                               v-model.trim="item.formatter"
                                                                               value-key="className"
                                                                               @change="formatterTypeChange(item,['form','follow_tables',followIndex,'columns',index])">
                                                                        <el-option v-for="(type,formatterTypeIndex) in formatterTypes"
                                                                                   :key="type.value" :value="type.value" :label="type.label" >
                                                                        </el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'PIC'">
                                                                <el-form-item label="图片展示宽度:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.width'"
                                                                              :rules="rules.zNumberMust"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.formatter.width"  placeholder="单位px"
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'PIC'">
                                                                <el-form-item label="图片展示高度:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.height'"
                                                                              :rules="rules.zNumberMust"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.formatter.height"  placeholder="单位px"
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                <el-form-item label="选中选项的值:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.active.value'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.formatter.active.value" placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                <el-form-item label="选中选项的标签:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.active.label'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="130px">
                                                                    <el-input v-model.trim="item.formatter.active.label" placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                <el-form-item label="未选中选项的值:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.inactive.value'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="130px">
                                                                    <el-input v-model.trim="item.formatter.inactive.value" placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'SWITCH'">
                                                                <el-form-item label="未选中选项的标签:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.inactive.label'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="140px">
                                                                    <el-input v-model.trim="item.formatter.inactive.label" placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'URL'">
                                                                <el-form-item label="链接打开方式:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.target'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]"
                                                                              label-width="120px">
                                                                    <el-select style="width: 100%" v-model="item.formatter.target"
                                                                               placeholder="请选择链接打开方式">
                                                                        <el-option key="_blank" label="新开窗口" value="_blank"></el-option>
                                                                        <el-option key="_self" label="当前窗口" value="_self"></el-option>
                                                                        <el-option key="_parent" label="父级窗口" value="_parent"></el-option>
                                                                        <el-option key="_top" label="顶层窗口" value="_top"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.formatter && item.formatter.type && item.formatter.type == 'URL'">
                                                                <el-form-item label="链接文案:"
                                                                              :prop="'follow_tables.' + followIndex + '.columns.' + index +'.formatter.text'"
                                                                              :rules="[{required: false, message: '请输入', trigger: 'change'}]"
                                                                              label-width="100px">
                                                                    <el-input v-model.trim="item.formatter.text" placeholder="默认链接本身"
                                                                              autocomplete="off" size="small" maxlength="100"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="12" v-if="item.formatter && item.formatter.type && item.formatter.type == 'TEXT'">
                                                                <el-form-item label="文本格式化:" label-width="100px">
                                                                    <span>{{item.formatter.map | json}}</span>
                                                                    <el-button type="text" plain v-if="!item.formatter.map" @click="showFormatterTextDialog(item,['form','follow_tables',followIndex,'columns',index])">添加</el-button>
                                                                    <el-button type="text" plain v-if="item.formatter.map" @click="showFormatterTextDialog(item,['form','follow_tables',followIndex,'columns',index])">修改</el-button>
                                                                    <el-button type="text" plain v-if="item.formatter.map" @click="deleteFormatterTextDialog(item,['form','follow_tables',followIndex,'columns',index])">删除</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="24" style="text-align: right;">
                                                                <el-button-group>
                                                                    <el-button type="primary" size="mini" icon="el-icon-arrow-up"
                                                                               v-if="index != 0"
                                                                               @click="up(item, index, form.follow_tables[followIndex].columns)">上移</el-button>
                                                                    <el-button type="primary" size="mini" icon="el-icon-arrow-down"
                                                                               v-if="index != form.follow_tables[followIndex].columns.length - 1"
                                                                               @click="down(item, index, form.follow_tables[followIndex].columns)">下移</el-button>
                                                                </el-button-group>
                                                                <el-button type="danger" plain size="mini"
                                                                           @click="removeTableColumn(item, index, form.follow_tables[followIndex])">移除</el-button>
                                                            </el-col>
                                                        </el-row>
                                                    </el-card>
                                                </el-card>
                                            </el-col>
                                            <el-col :span="24">
                                                <el-card shadow="hover" style="margin-bottom: 8px;">
                                                    <div slot="header">
                                                        <el-form-item label="默认查询条件" label-width="100px">
                                                            <el-button type="text" plain @click="showAddWhereColumn(followColumns[followIndex], ['form','follow_tables',followIndex])">添加</el-button>
                                                        </el-form-item>
                                                    </div>
                                                    <template v-if="form.follow_tables && form.follow_tables[followIndex].select && form.follow_tables[followIndex].select.wheres && form.follow_tables[followIndex].select.wheres.length > 0">
                                                        <el-card shadow="hover" v-for="(item,index) in form.follow_tables[followIndex].select.wheres" style="margin-bottom: 8px;">
                                                            <el-row style="border: 0px solid gray;" :gutter="24">
                                                                <el-col :span="6">
                                                                    <el-form-item label="sql查询字段:" label-width="100px">
                                                                        {{form.follow_tables[followIndex].select.schema}}.{{form.follow_tables[followIndex].select.table}} -> {{item.key}}
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6">
                                                                    <el-form-item label="类型:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex + '.select.wheres.' + index + '.className'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" clearable
                                                                                   v-model.trim="item.className"
                                                                                   @change="whereTypeChange(item)">
                                                                            <el-option v-for="(type,whereTypeIndex) in whereTypes"
                                                                                       :key="type.value" :value="type.value" :label="type.label" >
                                                                            </el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6"
                                                                        v-if="item.type && (item.type == 'eq' || item.type == 'gt' || item.type == 'gteq' || item.type == 'lt' || item.type == 'lteq' || item.type == 'like')">
                                                                    <el-form-item label="值:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex + '.select.wheres.' + index + '.value'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.value" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                    <el-form-item label="最小值:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex + '.select.wheres.' + index + '.begin'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.begin" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                    <el-form-item label="最大值:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex + '.select.wheres.' + index + '.end'"
                                                                                  :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.end" placeholder="" maxlength="50"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="12" v-if="item.type && item.type == 'in'">
                                                                    <el-form-item label="集合值:" label-width="100px">
                                                                        {{item.values | json}}
                                                                        <el-button type="text" plain @click="editWhereInValues(item)">修改</el-button>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="24" style="text-align: right;">
                                                                    <el-button type="danger" plain size="mini"
                                                                               @click="justRemove(item, index, form.follow_tables[followIndex].select.wheres)">移除</el-button>
                                                                </el-col>
                                                            </el-row>
                                                        </el-card>
                                                    </template>
                                                    <template v-if="form.follow_tables && form.follow_tables[followIndex].select && form.follow_tables[followIndex].select.leftJoins && form.follow_tables[followIndex].select.leftJoins.length > 0">
                                                        <template v-for="(leftJoin, leftJoinIndex) in form.follow_tables[followIndex].select.leftJoins">
                                                            <template v-if="leftJoin.wheres && leftJoin.wheres.length > 0">
                                                                <el-card shadow="hover" v-for="(item,index) in leftJoin.wheres" style="margin-bottom: 8px;">
                                                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                                                        <el-col :span="6">
                                                                            <el-form-item label="sql查询字段:" label-width="100px">
                                                                                {{form.follow_tables[followIndex].select.leftJoins[leftJoinIndex].schema}}.{{form.follow_tables[followIndex].select.leftJoins[leftJoinIndex].table}} -> {{item.key}}
                                                                            </el-form-item>
                                                                        </el-col>
                                                                        <el-col :span="6">
                                                                            <el-form-item label="类型:" label-width="100px"
                                                                                          :prop="'follow_tables.' + followIndex +'.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.className'"
                                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                                <el-select style="width: 100%" clearable
                                                                                           v-model.trim="item.className"
                                                                                           @change="whereTypeChange(item)">
                                                                                    <el-option v-for="(type,whereTypeIndex) in whereTypes"
                                                                                               :key="type.value" :value="type.value" :label="type.label" >
                                                                                    </el-option>
                                                                                </el-select>
                                                                            </el-form-item>
                                                                        </el-col>
                                                                        <el-col :span="6"
                                                                                v-if="item.type && (item.type == 'eq' || item.type == 'gt' || item.type == 'gteq' || item.type == 'lt' || item.type == 'lteq' || item.type == 'like')">
                                                                            <el-form-item label="值:" label-width="100px"
                                                                                          :prop="'follow_tables.' + followIndex +'.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.value'"
                                                                                          :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                                <el-input v-model.trim="item.value" placeholder="" maxlength="50"
                                                                                          autocomplete="off" size="small"></el-input>
                                                                            </el-form-item>
                                                                        </el-col>
                                                                        <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                            <el-form-item label="最小值:" label-width="100px"
                                                                                          :prop="'follow_tables.' + followIndex +'.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.begin'"
                                                                                          :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                                <el-input v-model.trim="item.begin" placeholder="" maxlength="50"
                                                                                          autocomplete="off" size="small"></el-input>
                                                                            </el-form-item>
                                                                        </el-col>
                                                                        <el-col :span="6" v-if="item.type && item.type == 'bt'">
                                                                            <el-form-item label="最大值:" label-width="100px"
                                                                                          :prop="'follow_tables.' + followIndex +'.select.leftJoins.' + leftJoinIndex + '.wheres.' + index + '.end'"
                                                                                          :rules="[{required: true, message: '请填写', trigger: 'change'}]">
                                                                                <el-input v-model.trim="item.end" placeholder="" maxlength="50"
                                                                                          autocomplete="off" size="small"></el-input>
                                                                            </el-form-item>
                                                                        </el-col>
                                                                        <el-col :span="12" v-if="item.type && item.type == 'in'">
                                                                            <el-form-item label="集合值:" label-width="100px">
                                                                                {{item.values | json}}
                                                                                <el-button type="text" plain @click="editWhereInValues(item)">修改</el-button>
                                                                            </el-form-item>
                                                                        </el-col>
                                                                        <el-col :span="24" style="text-align: right;">
                                                                            <el-button type="danger" plain size="mini"
                                                                                       @click="justRemove(item, index, form.follow_tables[followIndex].select.leftJoins[leftJoinIndex].wheres)">移除</el-button>
                                                                        </el-col>
                                                                    </el-row>
                                                                </el-card>
                                                            </template>
                                                        </template>
                                                    </template>
                                                </el-card>
                                            </el-col>
                                        </el-card>
                                    </el-collapse-item>
                                    <el-collapse-item title="搜索表单" name="search">
                                        <el-card shadow="hover">
                                            <el-col :span="24" style="margin-bottom: 8px;">
                                                <el-button type="text" plain @click="showAddSearchColumn(followColumns[followIndex], ['form','follow_tables',followIndex])">添加表单项</el-button>
                                            </el-col>
                                            <template v-if="form.follow_tables && form.follow_tables.length > 0 && form.follow_tables[followIndex].select && form.follow_tables[followIndex].select.searchElements && form.follow_tables[followIndex].select.searchElements.length > 0">
                                                <el-card shadow="hover" v-for="(item,index) in form.follow_tables[followIndex].select.searchElements" style="margin-bottom: 8px;">
                                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                                        <el-col :span="6">
                                                            <el-form-item label="sql查询字段:" label-width="100px">
                                                                {{followAliasTable[followIndex][item.alias].schema}}.{{followAliasTable[followIndex][item.alias].table}} -> {{item.key}}
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="前端文案:" label-width="100px"
                                                                          :prop="'follow_tables.' + followIndex + '.select.searchElements.' + index + '.label'"
                                                                          :rules="[{required: true, message: '前端文案不能为空', trigger: 'change'}]">
                                                                <el-input v-model.trim="item.label" placeholder="" maxlength="100"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="前端提示信息:" label-width="120px"
                                                                          :prop="'follow_tables.' + followIndex + '.select.searchElements.' + index + '.placeholder'">
                                                                <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="输入框宽度:"
                                                                          :prop="'follow_tables.' + followIndex + '.select.searchElements.' + index + '.width'"
                                                                          :rules="rules.zNumberMust"
                                                                          label-width="120px">
                                                                <el-input v-model.trim="item.width"  placeholder="单位px"
                                                                          autocomplete="off" size="small" maxlength="50"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="类型:" label-width="100px"
                                                                          :prop="'follow_tables.' + followIndex + '.select.searchElements.' + index + '.className'"
                                                                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                <el-select style="width: 100%" clearable
                                                                           v-model.trim="item.className"
                                                                           @change="searchTypeChange(item,['form','follow_tables',followIndex,'select','searchElements',index])">
                                                                    <el-option v-for="(type,searchTypeIndex) in searchTypes"
                                                                               :key="type.value" :value="type.value" :label="type.label" >
                                                                    </el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6">
                                                            <el-form-item label="默认值:" label-width="100px"
                                                                          :prop="'follow_tables.' + followIndex + '.select.searchElements.' + index + '.defaultValue'">
                                                                <el-input v-model.trim="item.defaultValue" placeholder="" maxlength="100"
                                                                          autocomplete="off" size="small"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="6"
                                                                v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') > -1">
                                                            <el-form-item label="远程下拉菜单配置:" label-width="130px">
                                                                {{item.schema}}.{{item.table}}[{{item.keyColumn}}-{{item.valueColumn}}]
                                                                <el-button type="text" plain @click="editRemoteSelect(item,['form','follow_tables',followIndex,'select','searchElements',index])">修改</el-button>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="12"
                                                                v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') == -1 && item.className.indexOf('.SearchSelect') > -1">
                                                            <el-form-item label="下拉选项配置:" label-width="130px">
                                                                {{item.options | json}}
                                                                <el-button type="text" plain @click="editSelect(item,['form','follow_tables',followIndex,'select','searchElements',index])">修改</el-button>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="24" style="text-align: right;">
                                                            <el-button type="danger" plain size="mini"
                                                                       @click="justRemove(item, index, form.follow_tables[followIndex].select.searchElements)">移除</el-button>
                                                        </el-col>
                                                    </el-row>
                                                </el-card>
                                            </template>
                                            <template v-if="form.follow_tables && form.follow_tables.length > 0 && form.follow_tables[followIndex].select && form.follow_tables[followIndex].select.leftJoins && form.follow_tables[followIndex].select.leftJoins.length > 0">
                                                <template v-for="(leftJoin, leftJoinIndex) in form.follow_tables[followIndex].select.leftJoins">
                                                    <template v-if="leftJoin.searchElements && leftJoin.searchElements.length > 0">
                                                        <el-card shadow="hover" v-for="(item,index) in leftJoin.searchElements" style="margin-bottom: 8px;">
                                                            <el-row style="border: 0px solid gray;" :gutter="24">
                                                                <el-col :span="6">
                                                                    <el-form-item label="sql查询字段:" label-width="100px">
                                                                        {{followAliasTable[followIndex][item.alias].schema}}.{{followAliasTable[followIndex][item.alias].table}} -> {{item.key}}
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6">
                                                                    <el-form-item label="前端文案:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex+ '.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.label'"
                                                                                  :rules="[{required: true, message: '前端文案不能为空', trigger: 'change'}]">
                                                                        <el-input v-model.trim="item.label" placeholder="" maxlength="100"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6">
                                                                    <el-form-item label="前端提示信息:" label-width="120px"
                                                                                  :prop="'follow_tables.' + followIndex+ '.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.placeholder'">
                                                                        <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6">
                                                                    <el-form-item label="输入框宽度:"
                                                                                  :prop="'follow_tables.' + followIndex+ '.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.width'"
                                                                                  :rules="rules.zNumberMust"
                                                                                  label-width="120px">
                                                                        <el-input v-model.trim="item.width"  placeholder="单位px"
                                                                                  autocomplete="off" size="small" maxlength="50"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6">
                                                                    <el-form-item label="类型:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex+ '.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.className'"
                                                                                  :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                        <el-select style="width: 100%" clearable
                                                                                   v-model.trim="item.className"
                                                                                   @change="searchTypeChange(item,['form','follow_tables',followIndex,'select','leftJoins',leftJoinIndex,'searchElements',index])">
                                                                            <el-option v-for="(type,searchTypeIndex) in searchTypes"
                                                                                       :key="type.value" :value="type.value" :label="type.label" >
                                                                            </el-option>
                                                                        </el-select>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6">
                                                                    <el-form-item label="默认值:" label-width="100px"
                                                                                  :prop="'follow_tables.' + followIndex+ '.select.leftJoins.' + leftJoinIndex + '.searchElements.' + index + '.defaultValue'">
                                                                        <el-input v-model.trim="item.defaultValue" placeholder="" maxlength="100"
                                                                                  autocomplete="off" size="small"></el-input>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="6"
                                                                        v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') > -1">
                                                                    <el-form-item label="远程下拉菜单配置:" label-width="130px">
                                                                        {{item.schema}}.{{item.table}}[{{item.keyColumn}}-{{item.valueColumn}}]
                                                                        <el-button type="text" plain @click="editRemoteSelect(item,['form','follow_tables',followIndex,'select','leftJoins',leftJoinIndex,'searchElements',index])">修改</el-button>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="12"
                                                                        v-if="item.elType && item.elType == 'SELECT' && item.className.indexOf('.SearchSelectRemote') == -1 && item.className.indexOf('.SearchSelect') > -1">
                                                                    <el-form-item label="下拉选项配置:" label-width="130px">
                                                                        {{item.options | json}}
                                                                        <el-button type="text" plain @click="editSelect(item,['form','follow_tables',followIndex,'select','leftJoins',leftJoinIndex,'searchElements',index])">修改</el-button>
                                                                    </el-form-item>
                                                                </el-col>
                                                                <el-col :span="24" style="text-align: right;">
                                                                    <el-button type="danger" plain size="mini"
                                                                               @click="justRemove(item, index, form.follow_tables[followIndex].select.leftJoins[leftJoinIndex].searchElements)">移除</el-button>
                                                                </el-col>
                                                            </el-row>
                                                        </el-card>
                                                    </template>
                                                </template>
                                            </template>
                                        </el-card>
                                    </el-collapse-item>
                                    <el-collapse-item title="新增/编辑表单" name="add" v-if="form.follow_tables[followIndex].add_form">
                                        <el-card shadow="hover">
                                            <el-row :gutter="24">
                                                <el-col :span="6">
                                                    <el-form-item label="前端弹窗宽（%）:" label-width="140px"
                                                                  :prop="'follow_tables.' + followIndex + '.add_form.width'">
                                                        <el-input-number size="small" v-model="follow.add_form.width"
                                                                         :min="50" :max="100"
                                                                         style="width: 100%"></el-input-number>
                                                    </el-form-item>
                                                </el-col>
                                            </el-row>
                                            <el-card shadow="hover" style="margin-bottom: 8px;">
                                                <div slot="header">
                                                    <el-form-item label="表单项" :prop="'follow_tables.' + followIndex + '.add_form.elements'" :rules="rules.columns" label-width="100px">
                                                        <el-button type="text" plain @click="showAddFormColumn(followColumns[followIndex][0], ['form','follow_tables',followIndex])">添加</el-button>
                                                    </el-form-item>
                                                </div>
                                                <template v-if="form.follow_tables[followIndex].add_form.elements && form.follow_tables[followIndex].add_form.elements.length > 0">
                                                    <el-card shadow="hover" v-for="(item,index) in form.follow_tables[followIndex].add_form.elements" style="margin-bottom: 8px;">
                                                        <el-row style="border: 0px solid gray;" :gutter="24">
                                                            <el-col :span="6">
                                                                <el-form-item label="字段:" label-width="100px">
                                                                    <el-input v-model.trim="item.key" placeholder="" maxlength="100"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.key'"
                                                                              :rules="[{required: true, message: '不能为空', trigger: 'change'}]"
                                                                              autocomplete="off" size="small" readOnly="true"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6">
                                                                <el-form-item label="类型:" label-width="100px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.className'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" clearable
                                                                               v-model.trim="item.className"
                                                                               @change="addElementTypeChange(item,['form','follow_tables',followIndex,'add_form','elements',index])">
                                                                        <el-option v-for="(type,addElementTypeIndex) in addElementTypes"
                                                                                   :key="type.value" :value="type.value" :label="type.label" >
                                                                        </el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('label') > -1">
                                                                <el-form-item label="控件标题:" label-width="100px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.label'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.label" placeholder="" maxlength="20"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('type') > -1">
                                                                <el-form-item label="文本框类型:" label-width="110px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.type'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" v-model.trim="item.type">
                                                                        <el-option key="text" label="普通单行" value="text"></el-option>
                                                                        <el-option key="textarea" label="多行" value="textarea"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('placeholder') > -1">
                                                                <el-form-item label="输入框提示文案:" label-width="120px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.placeholder'"
                                                                              :rules="[{required: false, message: '请输入', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.placeholder" placeholder="" maxlength="100"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('clearable') > -1">
                                                                <el-form-item label="是否可一键清空:" label-width="130px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.clearable'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" v-model.trim="item.clearable">
                                                                        <el-option :key="true" label="是" :value="true"></el-option>
                                                                        <el-option :key="false" label="否" :value="false"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('to') > -1">
                                                                <el-form-item label="转换格式:" label-width="110px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.to'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" v-model.trim="item.to">
                                                                        <el-option key="java.lang.String" label="java.lang.String" value="java.lang.String"></el-option>
                                                                        <el-option key="java.lang.Long" label="java.lang.Long" value="java.lang.Long"></el-option>
                                                                        <el-option key="java.util.Date" label="java.util.Date" value="java.util.Date"></el-option>
                                                                        <el-option key="java.sql.Timestamp" label="java.sql.Timestamp" value="java.sql.Timestamp"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('size') > -1">
                                                                <el-form-item label="控件大小:" label-width="110px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.size'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" v-model.trim="item.size">
                                                                        <el-option key="mini" label="小" value="mini"></el-option>
                                                                        <el-option key="small" label="中" value="small"></el-option>
                                                                        <el-option key="medium" label="大" value="medium"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('width') > -1">
                                                                <el-form-item label="控件宽度:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.width'"
                                                                              :rules="rules.number"
                                                                              label-width="100px">
                                                                    <el-input v-model.trim="item.width"  placeholder="单位px"
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('minlength') > -1">
                                                                <el-form-item label="最小输入长度:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.minlength'"
                                                                              :rules="rules.zNumber"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.minlength"  placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('maxlength') > -1">
                                                                <el-form-item label="最大输入长度:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.maxlength'"
                                                                              :rules="rules.zNumber"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.maxlength"  placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('min') > -1">
                                                                <el-form-item label="计数器最小值:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.min'"
                                                                              :rules="rules.number"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.min"  placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('max') > -1">
                                                                <el-form-item label="计数器最大值:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.max'"
                                                                              :rules="rules.number"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.max"  placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('precision') > -1">
                                                                <el-form-item label="数值精度:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.precision'"
                                                                              :rules="rules.number"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.precision"  placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('start') > -1">
                                                                <el-form-item label="开始时间:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.start'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="100px">
                                                                    <el-time-select style="width: 100%"
                                                                                    v-model.trim="item.start"
                                                                                    :picker-options="{start: '00:00',step: '00:01',end: '23:59'}"
                                                                                    placeholder="选择开始时间">
                                                                    </el-time-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('end') > -1">
                                                                <el-form-item label="截止时间:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.end'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="100px">
                                                                    <el-time-select style="width: 100%"
                                                                                    v-model.trim="item.end"
                                                                                    :picker-options="{start: '00:00',step: '00:01',end: '23:59'}"
                                                                                    placeholder="选择截止时间">
                                                                    </el-time-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('step') > -1">
                                                                <el-form-item label="步长:" v-if="item.className.indexOf('.AddInputNumber') > -1"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.step'"
                                                                              :rules="rules.number"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.step"  placeholder=""
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                                <el-form-item label="时间间隔:" v-if="item.className.indexOf('.AddTimePicker') > -1"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.step'"
                                                                              :rules="[{required: true, message: '请输入', trigger: 'change'}]"
                                                                              label-width="100px">
                                                                    <el-time-select v-model.trim="item.step" style="width: 100%"
                                                                                    :picker-options="{start: '00:00',step: '00:01',end: '23:59'}"
                                                                                    placeholder="时间间隔">
                                                                    </el-time-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('acceptType') > -1">
                                                                <el-form-item label="图片格式限制:" label-width="120px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.acceptType'"
                                                                              :rules="[{required: false, message: '请输入', trigger: 'change'}]">
                                                                    <el-input v-model.trim="item.acceptType" placeholder="例：'.jpg,.PNG'，多个使用逗号分隔" maxlength="100"
                                                                              autocomplete="off" size="small"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('limitSize') > -1">
                                                                <el-form-item label="图片大小限制:"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.limitSize'"
                                                                              :rules="rules.zNumber"
                                                                              label-width="120px">
                                                                    <el-input v-model.trim="item.limitSize"  placeholder="单位：字节"
                                                                              autocomplete="off" size="small" maxlength="50"></el-input>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('remoteSelect') > -1">
                                                                <el-form-item label="远程下拉菜单配置:" label-width="130px">
                                                                    {{item.schema}}.{{item.table}}[{{item.keyColumn}}-{{item.valueColumn}}]
                                                                    <el-button type="text" plain @click="editRemoteSelect(item,['form','follow_tables',followIndex,'add_form','elements',index])">修改</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="12" v-if="item.className && addElementShows[item.className].indexOf('select') > -1">
                                                                <el-form-item label="下拉选项配置:" label-width="130px">
                                                                    {{item.options | json}}
                                                                    <el-button type="text" plain @click="editSelect(item,['form','follow_tables',followIndex,'add_form','elements',index])">修改</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="12" v-if="item.className && addElementShows[item.className].indexOf('radio') > -1">
                                                                <el-form-item label="单选框配置:" label-width="130px">
                                                                    {{item.radios | json}}
                                                                    <el-button type="text" plain @click="editSelect(item,['form','follow_tables',followIndex,'add_form','elements',index])">修改</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="12" v-if="item.className && addElementShows[item.className].indexOf('rule') > -1">
                                                                <el-form-item label="前端校验规则:" label-width="130px">
                                                                    {{item.rule | json}}
                                                                    <el-button type="text" v-if="!item.rule" plain @click="showAddRule(item,['form','follow_tables',followIndex,'add_form','elements',index])">添加</el-button>
                                                                    <el-button type="text" v-if="item.rule" plain @click="showAddRule(item,['form','follow_tables',followIndex,'add_form','elements',index])">修改</el-button>
                                                                    <el-button type="text" v-if="item.rule" plain @click="delAddRule(item)">删除</el-button>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="6" v-if="item.className && addElementShows[item.className].indexOf('canEdit') > -1">
                                                                <el-form-item label="是否可编辑:" label-width="130px"
                                                                              :prop="'follow_tables.' + followIndex + '.add_form.elements.' + index + '.canEdit'"
                                                                              :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                                                                    <el-select style="width: 100%" v-model.trim="item.canEdit">
                                                                        <el-option :key="true" label="是" :value="true"></el-option>
                                                                        <el-option :key="false" label="否" :value="false"></el-option>
                                                                    </el-select>
                                                                </el-form-item>
                                                            </el-col>
                                                            <el-col :span="24" style="text-align: right;">
                                                                <el-button-group>
                                                                    <el-button type="primary" size="mini" icon="el-icon-arrow-up"
                                                                               v-if="index != 0"
                                                                               @click="up(item, index, form.follow_tables[followIndex].add_form.elements)">上移</el-button>
                                                                    <el-button type="primary" size="mini" icon="el-icon-arrow-down"
                                                                               v-if="index != form.follow_tables[followIndex].add_form.elements.length - 1"
                                                                               @click="down(item, index, form.follow_tables[followIndex].add_form.elements)">下移</el-button>
                                                                </el-button-group>
                                                                <el-button type="danger" plain size="mini"
                                                                           @click="justRemove(item, index, form.follow_tables[followIndex].add_form.elements)">移除</el-button>
                                                            </el-col>
                                                        </el-row>
                                                    </el-card>
                                                </template>
                                            </el-card>
                                            <el-card shadow="hover" style="margin-bottom: 8px;">
                                                <div slot="header">
                                                    <el-form-item label="唯一键组合" :prop="'follow_tables.' + followIndex + '.add_form.unique_columns'" :rules="rules.unique_columns" label-width="100px">
                                                        <el-button type="text" plain @click="addUnique(['form','follow_tables',followIndex,'add_form'])">添加</el-button>
                                                    </el-form-item>
                                                </div>
                                                <template v-if="form.follow_tables[followIndex].add_form.unique_columns && form.follow_tables[followIndex].add_form.unique_columns.length > 0">
                                                    <el-row style="border: 0px solid gray;" :gutter="24" v-for="(item,index) in form.follow_tables[followIndex].add_form.unique_columns">
                                                        <el-col :span="10">
                                                            <el-form-item label="冲突前端提示文案:"
                                                                          :prop="'follow_tables.' + followIndex + '.add_form.unique_columns.' + index + '.toast'"
                                                                          :rules="[{required: true, message: '请填写', trigger: 'change'}]"
                                                                          label-width="150px">
                                                                <el-input v-model.trim="item.toast" placeholder="唯一键冲突前端提示文案"
                                                                          autocomplete="off" size="small" maxlength="300"></el-input>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="10">
                                                            <el-form-item label="唯一键组合:"
                                                                          :prop="'follow_tables.' + followIndex + '.add_form.unique_columns.' + index + '.columns'"
                                                                          :rules="rules.columns"
                                                                          label-width="130px">
                                                                <el-select size="small" v-model="item.columns" multiple placeholder="请选择唯一键组合"
                                                                           style="width: 100%;">
                                                                    <el-option v-for="uniqueColumn in followColumns[followIndex][0].options"
                                                                               :key="uniqueColumn.key"
                                                                               :label="'列名:' + uniqueColumn.key + '   类型:' + uniqueColumn.dataType"
                                                                               :value="uniqueColumn.key"></el-option>
                                                                </el-select>
                                                            </el-form-item>
                                                        </el-col>
                                                        <el-col :span="4" style="text-align: right;">
                                                            <el-button type="danger" plain size="mini" @click="justRemove(item, index, form.follow_tables[followIndex].add_form.unique_columns)">移除</el-button>
                                                        </el-col>
                                                    </el-row>
                                                </template>
                                            </el-card>
                                        </el-card>
                                    </el-collapse-item>
                                </el-collapse>
                            </el-col>
                        </el-row>
                    </div>
                </el-collapse-item>
            </template>
        </el-collapse>
        <div style="text-align: right;margin-top: 8px;">
            <el-button type="success" @click="preview">预览</el-button>
            <el-button type="primary" @click="submit">确认</el-button>
        </div>
    </el-form>



    <el-dialog title="添加列" :top="dialogTop" :visible.sync="tableColumnDialog.visible" class="group-dialog" :before-close="closeAddTableColumnDialog">
        <el-select v-model="tableColumnDialog.value" placeholder="请选择" size="small"
                   style="width: 100%" @change="addTableColumn">
            <el-option-group
                    v-for="(group,index) in tableColumnDialog.columns"
                    :key="group.schema + '.' + group.table"
                    :label="group.schema + '.' + group.table">
                <el-option v-for="(item,index) in group.options"
                           :key="group.schema + '.' + group.table + '.' + item.key"
                           :label="'表:' + group.schema + '.' + group.table + ' 列名:' + item.key + ' 类型:' + item.dataType"
                           :value="group.schema + '#' + group.table + '#' + item.key + '#' + item.alias">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addTableColumn">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="文本格式化" :top="dialogTop":visible.sync="formatterTextDialog.visible" class="group-dialog" :before-close="closeFormatterTextDialog">
        <el-form :model="formatterTextDialog" ref="formatterTextDialog" size="small">
            <el-row :gutter="24">
                <el-col :span="24">
                    <el-form-item label="配置项:" label-width="120px"
                                  prop="map"
                                  :rules="rules.columns">
                        <el-button type="primary" plain size="mini" @click="pushFormatterText">添加</el-button>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="24" v-for="(item,index) in formatterTextDialog.map">
                <el-col :span="10">
                    <el-form-item label="源数据:" label-width="100px"
                                  :prop="'map.' + index + '.key'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input size="small" placeholder="源数据" v-model.trim="item.key"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="外显文案:" label-width="100px"
                                  :prop="'map.' + index + '.value'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input size="small" placeholder="外显文案" v-model.trim="item.value"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="4">
                    <el-button type="danger" plain size="mini" @click="removeFormatterText(index)">移除</el-button>
                </el-col>
            </el-row>
            <el-form-item style="text-align: right;">
                <el-button type="info" plain size="mini" @click="closeFormatterTextDialog">取消</el-button>
                <el-button type="primary" plain size="mini" @click="confirmFormatterText('formatterTextDialog')">确认</el-button>
            </el-form-item>
        </el-form>
    </el-dialog>

    <el-dialog title="默认搜索条件" :top="dialogTop" :visible.sync="whereColumnDialog.visible" class="group-dialog" :before-close="closeWhereColumnDialog">
        <el-select v-model="whereColumnDialog.value" placeholder="请选择" size="small"
                   style="width: 100%" @change="addWhereColumn">
            <el-option-group
                    v-for="(group,index) in whereColumnDialog.columns"
                    :key="group.schema + '.' + group.table"
                    :label="group.schema + '.' + group.table">
                <el-option v-for="(item,index) in group.options"
                           :key="group.schema + '.' + group.table + '.' + item.key"
                           :label="'表:' + group.schema + '.' + group.table + ' 列名:' + item.key + ' 类型:' + item.dataType"
                           :value="group.schema + '#' + group.table + '#' + item.key + '#' + item.alias">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addWhereColumn">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="添加搜索表单项" :top="dialogTop" :visible.sync="searchColumnDialog.visible" class="group-dialog" :before-close="closeSearchColumnDialog">
        <el-select v-model="searchColumnDialog.value" placeholder="请选择" size="small"
                   style="width: 100%" @change="addSearchColumn">
            <el-option-group
                    v-for="(group,index) in searchColumnDialog.columns"
                    :key="group.schema + '.' + group.table"
                    :label="group.schema + '.' + group.table">
                <el-option v-for="(item,index) in group.options"
                           :key="group.schema + '.' + group.table + '.' + item.key"
                           :label="'表:' + group.schema + '.' + group.table + ' 列名:' + item.key + ' 类型:' + item.dataType"
                           :value="group.schema + '#' + group.table + '#' + item.key + '#' + item.alias">
                </el-option>
            </el-option-group>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addSearchColumn">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="远程下拉菜单配置" :top="dialogTop" :visible.sync="remoteSelectDialog.visible" class="group-dialog" :before-close="closeRemoteSelectDialog">
        <el-form :model="remoteSelectDialog" ref="remoteSelectDialog" size="small">
            <el-form-item label="数据库:" label-width="100px" prop="schema"
                          :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                <el-input v-model.trim="remoteSelectDialog.schema" placeholder="" maxlength="100"
                          autocomplete="off" size="small" @change="remoteSelectSchemaOrTableChange"></el-input>
            </el-form-item>
            <el-form-item label="数据库表:" label-width="100px" prop="table"
                          :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                <el-input v-model.trim="remoteSelectDialog.table" placeholder="" maxlength="100"
                          autocomplete="off" size="small" @change="remoteSelectSchemaOrTableChange"></el-input>
            </el-form-item>
            <el-form-item label="值字段:" label-width="100px" prop="keyColumn"
                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model.trim="remoteSelectDialog.keyColumn" placeholder="请选择外显字段" size="small" style="width: 100%">
                    <el-option v-for="column in remoteSelectDialog.columns"
                               :key="column.name"
                               :label="'列名:' + column.name + '   类型:' + column.type"
                               :value="column.name">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="外显字段:" label-width="100px" prop="valueColumn"
                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model.trim="remoteSelectDialog.valueColumn" placeholder="请选择值字段" size="small" style="width: 100%">
                    <el-option v-for="column in remoteSelectDialog.columns"
                               :key="column.name"
                               :label="'列名:' + column.name + '   类型:' + column.type"
                               :value="column.name">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item style="text-align: right;">
                <el-button type="info" plain size="mini" @click="closeRemoteSelectDialog">取消</el-button>
                <el-button type="primary" plain size="mini" @click="confirmRemoteSelect('remoteSelectDialog')">确认</el-button>
            </el-form-item>
        </el-form>
    </el-dialog>

    <el-dialog title="下拉菜单选项" :top="dialogTop" :visible.sync="selectDialog.visible" class="group-dialog" :before-close="closeSelectDialog">
        <el-form :model="selectDialog" ref="selectDialog" size="small">
            <el-row :gutter="24">
                <el-col :span="24">
                    <el-form-item label="下拉菜单选项:" label-width="120px"
                                  prop="options"
                                  :rules="rules.columns">
                        <el-button type="primary" plain size="mini" @click="pushSelect">添加</el-button>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="24" v-for="(item,index) in selectDialog.options">
                <el-col :span="10">
                    <el-form-item label="选项外显名称:" label-width="120px"
                                  :prop="'options.' + index + '.label'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input size="small" placeholder="选项外显名称" v-model.trim="item.label"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="选项值:" label-width="100px"
                                  :prop="'options.' + index + '.value'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input size="small" placeholder="选项外显名称" v-model.trim="item.value"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="4">
                    <el-button type="danger" plain size="mini" @click="removeSelect(index)">移除</el-button>
                </el-col>
            </el-row>
            <el-form-item style="text-align: right;">
                <el-button type="info" plain size="mini" @click="closeSelectDialog">取消</el-button>
                <el-button type="primary" plain size="mini" @click="confirmSelect('selectDialog')">确认</el-button>
            </el-form-item>
        </el-form>
    </el-dialog>

    <el-dialog title="表单项" :top="dialogTop" :visible.sync="addFormDialog.visible" class="group-dialog" :before-close="closeAddFormDialog">
        <el-select v-model="addFormDialog.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="closeAddFormDialog">
            <el-option
                    v-for="(item,index) in addFormDialog.columns"
                    :key="item+index"
                    :label="'列名:' + item.key + ' 类型:' + item.dataType"
                    :value="item.key">
            </el-option>
        </el-select>
    </el-dialog>

    <el-dialog title="校验规则配置" :top="dialogTop" :visible.sync="ruleDialog.visible" class="group-dialog" :before-close="closeRuleDialog">
        <el-form :model="ruleDialog" ref="ruleDialog" size="small">
            <el-form-item label="是否必填:" label-width="120px" prop="required"
                          :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                <el-select style="width: 100%" v-model.trim="ruleDialog.required">
                    <el-option :key="true" label="是" :value="true"></el-option>
                    <el-option :key="false" label="否" :value="false"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="错误提示文案:" label-width="120px" prop="message"
                          :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                <el-input v-model.trim="ruleDialog.message" placeholder="" maxlength="500"
                          autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="正则表达式校验:" label-width="130px" prop="regular"
                          :rules="[{required: false, message: '请输入', trigger: 'change'}]">
                <el-input v-model.trim="ruleDialog.regular" placeholder="请填写正则表达式" maxlength="1000"
                          autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item style="text-align: right;">
                <el-button type="info" plain size="mini" @click="closeRuleDialog">取消</el-button>
                <el-button type="primary" plain size="mini" @click="confirmRule('ruleDialog')">确认</el-button>
            </el-form-item>
        </el-form>
    </el-dialog>

</div>
</body>
<script>
    window.contextPath = '${contextPath}'
    window.basePackage = '${basePackage}'
    window.setInterval(() => {
        window.parent.document.getElementById("basic").height =  window.document.body.scrollHeight
    }, 1)

    function getParam(name) {
        var reg = new RegExp("[^\?&]?" + encodeURI(name) + "=[^&]+");
        var arr = window.location.search.match(reg);
        if (arr != null) {
            return decodeURI(arr[0].substring(arr[0].search("=") + 1));
        }
        return "";
    }

    window.vue = new Vue({
        name: 'm',
        el: '#app',
        data() {
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
                        callback(new Error(rule.message));
                    }
                }
            };

            var validateNumber = (rule, value, callback) => {
                if (!value || value === '') {
                    if (rule.required) {
                        callback(new Error(rule.message));
                    } else {
                        callback();
                    }
                } else {
                    if (/^(\-|\+)?\d+(\.\d+)?$/.test(value)) {
                        callback();
                    } else {
                        callback(new Error(rule.message));
                    }
                }
            };
            return {
                loading: false,
                height: window.innerHeight - 78,
                dialogTop: '150px',
                activeNames: [],
                accordionActiveName: [],
                followActiveNames: [],
                previewVisible: false,
                aliasTable: {},
                followAliasTable: [],
                mainDb: null,
                followDbs: null,
                form: {
                    pagination: false,
                    add_btn: false,
                    edit_btn: false,
                    delete_btn: false,
                    table: {
                        pagination: false,
                        columns: [],
                        select: {
                        }
                    }
                },
                rules: {
                    columns: [{required: true, message: '不能为空', validator: validateColumns, trigger: 'change'}],
                    zNumber: [{required: false, message: '请输入正整数格式内容', validator: validateZNum, trigger: 'change'}],
                    zNumberMust: [{required: true, message: '请输入正整数格式内容', validator: validateZNum, trigger: 'change'}],
                    number: [{required: false, message: '请输入数字格式内容', validator: validateNumber, trigger: 'change'}],
                },
                mainColumns: [],
                followColumns: [],
                tableColumnDialog: {
                    visible: false,
                    columns: [],
                    value: '',
                    db: []
                },
                formatterTextDialog: {
                    visible: false,
                    map: []
                },
                whereColumnDialog: {
                    visible: false,
                    columns: [],
                    value: '',
                    db: []
                },
                searchColumnDialog: {
                    visible: false,
                    columns: [],
                    value: '',
                    db: []
                },
                remoteSelectDialog: {
                    visible: false,
                    db: []
                },
                selectDialog: {
                    visible: false,
                    options: [],
                    db: []
                },
                addFormDialog: {
                    visible: false,
                    columns: [],
                    db: []
                },
                ruleDialog: {
                    visible: false,
                    db: []
                },
                formatterTypes: [{
                    label: '图片格式化',
                    value: {
                        className: window.basePackage + 'table.formatter.FormatterPic',
                        type: 'PIC'
                    }
                },{
                    label: '开关格式化',
                    value: {
                        className: window.basePackage + 'table.formatter.FormatterSwitch',
                        type: 'SWITCH'
                    }
                },{
                    label: '链接格式化',
                    value: {
                        className: window.basePackage + 'table.formatter.FormatterUrl',
                        type: 'URL'
                    }
                },{
                    label: '文本格式化',
                    value: {
                        className: window.basePackage + 'table.formatter.FormatterText',
                        type: 'TEXT'
                    }
                }],
                whereTypes: [{
                    label: '完全匹配',
                    value: window.basePackage + 'db.WhereEq'
                },{
                    label: '区间',
                    value: window.basePackage + 'db.WhereBt'
                },{
                    label: '大于',
                    value: window.basePackage + 'db.WhereGt'
                },{
                    label: '大于等于',
                    value: window.basePackage + 'db.WhereGteq'
                },{
                    label: '小于',
                    value: window.basePackage + 'db.WhereLt'
                },{
                    label: '大于等于',
                    value: window.basePackage + 'db.WhereLteq'
                },{
                    label: '模糊匹配',
                    value: window.basePackage + 'db.WhereLike'
                },{
                    label: '集合',
                    value: window.basePackage + 'db.WhereIn'
                }],
                searchTypes: [{
                    label: '完全匹配文本输入框',
                    value: window.basePackage + 'form.search.SearchInputEq'
                },{
                    label: '模糊匹配文本输入框',
                    value: window.basePackage + 'form.search.SearchInputLike'
                },{
                    label: '查询下拉菜单',
                    value: window.basePackage + 'form.search.SearchSelect'
                },{
                    label: '远程查询下拉菜单',
                    value: window.basePackage + 'form.search.SearchSelectRemote'
                },{
                    label: '日期选择器（yyyy-MM-dd）',
                    value: window.basePackage + 'form.search.SearchDatePickerBt'
                },{
                    label: '日期时间选择器（yyyy-MM-dd HH:mm:ss）',
                    value: window.basePackage + 'form.search.SearchDatetimePickerBt'
                }],
                addElementShows: {},
                addElementTypes: [{
                    label: '普通文本',
                    value: window.basePackage + 'form.add.AddInput'
                },{
                    label: '下拉选择框',
                    value: window.basePackage + 'form.add.AddSelect'
                },{
                    label: '远程下拉选择框',
                    value: window.basePackage + 'form.add.AddSelectRemote'
                },{
                    label: '单选框',
                    value: window.basePackage + 'form.add.AddRadio'
                },{
                    label: '计数器',
                    value: window.basePackage + 'form.add.AddInputNumber'
                },{
                    label: '日期选择器（yyyy-MM-dd）',
                    value: window.basePackage + 'form.add.AddDatePicker'
                },{
                    label: '日期时间选择器（yyyy-MM-dd HH:mm:ss）',
                    value: window.basePackage + 'form.add.AddDateTimePicker'
                },{
                    label: '时间选择器',
                    value: window.basePackage + 'form.add.AddTimePicker'
                },{
                    label: '图片上传',
                    value: window.basePackage + 'form.add.AddUploadPic'
                },{
                    label: '富文本',
                    value: window.basePackage + 'form.add.AddRich'
                },{
                    label: '创建时间',
                    value: window.basePackage + 'form.add.AddCreateDateTime'
                },{
                    label: '更新时间',
                    value: window.basePackage + 'form.add.AddUpdateDateTime'
                }]
            }
        },
        methods: {
            preview() {
                window.open(window.contextPath + "/pages/preview.html")
            },
            submit() {
                this.$refs['form'].validate((valid, obj) => {
                    this.accordionActiveName = []
                    this.activeNames = []
                    this.followActiveNames = []
                    if (this.followDbs && this.followDbs.length > 0) {
                        for (let i = 0; i < this.followDbs.length; i ++) {
                            this.followActiveNames.push({
                                activeNames: []
                            })
                        }
                    }
                    if (valid) {
                        this.loading = true;
                        axios.post(window.contextPath + '/api/save',this.form).then(res => {
                            if (res.data.status != 0) {
                                this.$message.error(res.data.msg);
                                this.loading = false;
                            }
                            else {
                                this.loading = false;
                            }
                        }).catch(res => {
                            console.error(res)
                            this.loading = false;
                        })
                    } else {
                        for (let key in obj) {
                            let items = key.split('.')
                            if (items[0] == 'follow_tables') {
                                let followIndex = items[1]
                                if (this.accordionActiveName.indexOf('follow' + followIndex) == -1) {
                                    this.accordionActiveName.push('follow' + followIndex)
                                }
                                if (items[2] == 'columns') {
                                    if (this.followActiveNames[followIndex].activeNames.indexOf('table') == -1) {
                                        this.followActiveNames[followIndex].activeNames.push('table')
                                    }
                                } else if (items[2] == 'select') {
                                    if (items[3] == 'wheres') {
                                        if (this.followActiveNames[followIndex].activeNames.indexOf('table') == -1) {
                                            this.followActiveNames[followIndex].activeNames.push('table')
                                        }
                                    }  else if (items[3] == 'searchElements') {
                                        if (this.followActiveNames[followIndex].activeNames.indexOf('search') == -1) {
                                            this.followActiveNames[followIndex].activeNames.push('search')
                                        }
                                    }
                                } else if (items[2] == 'add_form') {
                                    if (this.followActiveNames[followIndex].activeNames.indexOf('add') == -1) {
                                        this.followActiveNames[followIndex].activeNames.push('add')
                                    }
                                }
                            } else {
                                if (this.accordionActiveName.indexOf('main') == -1) {
                                    this.accordionActiveName.push('main')
                                }
                                if (items[0] == 'table') {
                                    if (items[1] == 'columns') {
                                        if (this.activeNames.indexOf('table') == -1) {
                                            this.activeNames.push('table')
                                        }
                                    } else if (items[1] == 'select') {
                                        if (items[2] == 'wheres') {
                                            if (this.activeNames.indexOf('table') == -1) {
                                                this.activeNames.push('table')
                                            }
                                        } else if (items[2] == 'searchElements') {
                                            if (this.activeNames.indexOf('search') == -1) {
                                                this.activeNames.push('search')
                                            }
                                        }
                                    }
                                } else if (items[0] == 'add_form') {
                                    if (this.activeNames.indexOf('add') == -1) {
                                        this.activeNames.push('add')
                                    }
                                }
                            }
                        }
                    }
                });
            },
            addUnique(db) {
                let data = this
                for (let i = 0; i < db.length; i ++) {
                    data = data[db[i]]
                }
                if (typeof data.unique_columns == 'undefined') {
                    data.unique_columns = []
                }
                data.unique_columns.push({
                    toast: '',
                    columns: [],
                })
                this.form = JSON.parse(JSON.stringify(this.form))
            },
            confirmRule(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        let data = this
                        for (let i = 0; i < this.ruleDialog.db.length; i ++) {
                            data = data[this.ruleDialog.db[i]]
                        }
                        data.rule = {
                            required: this.ruleDialog.required,
                            message: this.ruleDialog.message,
                            regular: this.ruleDialog.regular
                        }
                        this.closeRuleDialog()
                    }
                })
            },
            closeRuleDialog() {
                this.ruleDialog = {
                    visible: false,
                    db: []
                }
            },
            delAddRule(item) {
                delete item.rule
                this.form = JSON.parse(JSON.stringify(this.form))
            },
            showAddRule(item,db) {
                let required = false
                let message = undefined
                let regular = undefined
                if (item.rule) {
                    required = item.rule.required,
                    message = item.rule.message,
                    regular = item.rule.regular
                }
                this.ruleDialog = {
                    visible: true,
                    db: db,
                    required: required,
                    message: message,
                    regular: regular
                }
                this.ruleDialog = JSON.parse(JSON.stringify(this.ruleDialog))
            },
            addElementTypeChange(item,db) {
                delete item.elType
                delete item.columnType
                delete item.canEdit
                delete item.size
                delete item.width
                delete item.label
                delete item.rule
                delete item.min
                delete item.max
                delete item.precision
                delete item.step
                delete item.type
                delete item.placeholder
                delete item.clearable
                delete item.maxlength
                delete item.minlength
                delete item.to
                delete item.format
                delete item.start
                delete item.end
                delete item.acceptType
                delete item.limitSize
                delete item.schema
                delete item.table
                delete item.keyColumn
                delete item.valueColumn
                delete item.options
                delete item.radios
                if (item.className) {
                    if (item.className.indexOf('.AddInputNumber') > -1) {
                        item.elType = 'INPUT_NUMBER'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddInput') > -1) {
                        item.elType = 'INPUT'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        item.type = 'text'
                        item.clearable = true
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddDatePicker') > -1) {
                        item.elType = 'DATE_PICKER'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        item.clearable = true
                        item.format = "yyyy-MM-dd"
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddDateTimePicker') > -1) {
                        item.elType = 'DATETIME_PICKER'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        item.clearable = true
                        item.format = "yyyy-MM-dd HH:mm:ss"
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddTimePicker') > -1) {
                        item.elType = 'TIME_PICKER'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        item.clearable = true
                        item.start = '00:00'
                        item.end = '23:59'
                        item.step = '00:30'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddUploadPic') > -1) {
                        item.elType = 'UPLOAD_PIC'
                        item.columnType = 'COM'
                        item.canEdit = true
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddUpdateDateTime') > -1) {
                        item.elType = 'DATETIME_PICKER'
                        item.columnType = 'UPDATE_DATETIME'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddCreateDateTime') > -1) {
                        item.elType = 'DATETIME_PICKER'
                        item.columnType = 'CREATE_DATETIME'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddRich') > -1) {
                        item.elType = 'RICH'
                        item.columnType = 'COM'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddSelectRemote') > -1) {
                        item.elType = 'SELECT'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        item.clearable = true
                        this.remoteSelectDialog = {
                            visible: true,
                            db: db
                        }
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddSelect') > -1) {
                        item.elType = 'SELECT'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        item.clearable = true
                        this.selectDialog = {
                            visible: true,
                            options: [],
                            db: db,
                            key: 'options'
                        }
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.AddRadio') > -1) {
                        item.elType = 'RADIO'
                        item.columnType = 'COM'
                        item.canEdit = true
                        item.size = 'small'
                        this.selectDialog = {
                            visible: true,
                            options: [],
                            db: db,
                            key: 'radios'
                        }
                        this.form = JSON.parse(JSON.stringify(this.form))
                    }
                } else {
                    delete item.className
                    this.form = JSON.parse(JSON.stringify(this.form))
                }
            },
            addEditDeleteBtnChange(form) {
                if (form.add_btn || form.edit_btn || form.delete_btn) {
                    if (typeof form.add_form == 'undefined') {
                        form.add_form = {
                            elements: [],
                            width: 50
                        }
                    }
                } else {
                    delete form.add_form
                }
                this.form = JSON.parse(JSON.stringify(this.form))
            },
            closeAddFormDialog() {
                if (this.addFormDialog.item) {
                    let validate = ''
                    let data = this
                    for (let i = 0; i < this.addFormDialog.db.length; i ++) {
                        data = data[this.addFormDialog.db[i]]
                        if (i == 1) {
                            validate = this.addFormDialog.db[i]
                        } else if (i > 1) {
                            validate = validate + '.' + this.addFormDialog.db[i]
                        }
                    }
                    if (typeof data.add_form == 'undefined') {
                        data.add_form = {}
                    }
                    if (typeof data.add_form.schema == 'undefined') {
                        data.add_form.schema = this.addFormDialog.schema
                    }
                    if (typeof data.add_form.table == 'undefined') {
                        data.add_form.table = this.addFormDialog.table
                    }
                    if (typeof data.add_form.primaryKey == 'undefined') {
                        data.add_form.primaryKey = this.addFormDialog.primaryKey
                    }
                    if (typeof data.add_form.elements == 'undefined') {
                        data.add_form.elements = []
                    }
                    if (typeof data.add_form.width == 'undefined') {
                        data.add_form.width = 50
                    }
                    data.add_form.elements.push({
                        key: this.addFormDialog.item,
                        className: ''
                    })
                    if (validate == '') {
                        this.$refs.form.validateField('add_form.elements');
                    } else {
                        this.$refs.form.validateField(validate + '.add_form.elements');
                    }
                }
                this.addFormDialog = {
                    visible: false,
                    columns: [],
                    db: []
                }
            },
            showAddFormColumn(column, db) {
                let data = this
                for (let i = 0; i < db.length; i ++) {
                    data = data[db[i]]
                }
                let exs = []
                if (data.add_form && data.add_form.elements && data.add_form.elements.length > 0) {
                    for (let i = 0; i < data.add_form.elements.length; i ++) {
                        exs.push(data.add_form.elements[i].key)
                    }
                }
                let cols = []
                for (let i = 0; i < column.options.length; i ++) {
                    if (exs.indexOf(column.options[i].key) == -1
                            && column.options[i].key != column.primaryKey) {
                        cols.push({
                            key: column.options[i].key,
                            dataType: column.options[i].dataType
                        })
                    }
                }
                this.addFormDialog = {
                    visible: true,
                    columns: cols,
                    schema: column.schema,
                    table: column.table,
                    primaryKey: column.primaryKey,
                    db: db,
                    item: ''
                }
                this.addFormDialog = JSON.parse(JSON.stringify(this.addFormDialog))
            },
            editSelect(item, db) {
                let options = []
                let key = ''
                if (item.options) {
                    options = JSON.parse(JSON.stringify(item.options))
                    key = 'options'
                } else {
                    options = JSON.parse(JSON.stringify(item.radios))
                    key = 'radios'
                }
                this.selectDialog = {
                    visible: true,
                    options: options,
                    db: db,
                    key: key
                }
                this.selectDialog = JSON.parse(JSON.stringify(this.selectDialog))
            },
            confirmSelect(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        this.closeSelectDialog()
                    }
                })
            },
            removeSelect(index) {
                this.selectDialog.options.splice(index,1)
            },
            pushSelect() {
                this.selectDialog.options.push({
                    label: '',
                    value: ''
                })
            },
            closeSelectDialog() {
                let data = this
                for (let i = 0; i < this.selectDialog.db.length; i ++) {
                    data = data[this.selectDialog.db[i]]
                }
                let mm = []
                if (this.selectDialog.options && this.selectDialog.options.length > 0) {
                    for (let i = 0; i < this.selectDialog.options.length; i ++) {
                        if (typeof this.selectDialog.options[i].label != 'undefined'
                                && typeof this.selectDialog.options[i].value != 'undefined'
                                && this.selectDialog.options[i].label != ''
                                && this.selectDialog.options[i].value != ''
                                && this.selectDialog.options[i].label != null
                                && this.selectDialog.options[i].value != null) {
                            mm.push({
                                label: this.selectDialog.options[i].label,
                                value: this.selectDialog.options[i].value
                            })
                        }
                    }
                }
                if (mm.length > 0) {
                    if (typeof data[this.selectDialog.key] == 'undefined') {
                        data[this.selectDialog.key] = []
                    }
                    data[this.selectDialog.key] = mm
                } else {
                    delete data.judgeType
                    delete data.elType
                    delete data.format
                    delete data.schema
                    delete data.table
                    delete data.keyColumn
                    delete data.valueColumn
                    delete data.options
                    delete data.className
                    delete data.columnType
                    delete data.canEdit
                    delete data.size
                    delete data.clearable
                    delete data.options
                    delete data.radios
                    delete data.rule
                }
                this.form = JSON.parse(JSON.stringify(this.form))
                this.selectDialog = {
                    visible: false,
                    options: [],
                    db: []
                }
            },
            editRemoteSelect(item, db) {
                this.remoteSelectDialog = {
                    visible: true,
                    schema: item.schema,
                    table: item.table,
                    keyColumn: item.keyColumn,
                    valueColumn: item.valueColumn,
                    db: db
                }
                axios.get(window.contextPath + '/api/getTable', {
                    params: {
                        schema: this.remoteSelectDialog.schema,
                        table: this.remoteSelectDialog.table
                    }
                }).then(res => {
                    if (res.data.status == 0) {
                        this.remoteSelectDialog.columns = res.data.content.table.columns
                    }
                    this.remoteSelectDialog = JSON.parse(JSON.stringify(this.remoteSelectDialog))
                }).catch(res => {
                    console.error(res)
                    this.$message.error('服务异常');
                })
            },
            confirmRemoteSelect(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        let data = this
                        for (let i = 0; i < this.remoteSelectDialog.db.length; i ++) {
                            data = data[this.remoteSelectDialog.db[i]]
                        }
                        data.schema = this.remoteSelectDialog.schema
                        data.table = this.remoteSelectDialog.table
                        data.keyColumn = this.remoteSelectDialog.keyColumn
                        data.valueColumn = this.remoteSelectDialog.valueColumn
                        this.closeRemoteSelectDialog()
                    }
                })
            },
            remoteSelectSchemaOrTableChange() {
                this.remoteSelectDialog.columns = []
                this.remoteSelectDialog.keyColumn = ''
                this.remoteSelectDialog.valueColumn = ''
                if (typeof this.remoteSelectDialog.schema != 'undefined'
                        && typeof this.remoteSelectDialog.table != 'undefined'
                        && this.remoteSelectDialog.schema != ''
                        && this.remoteSelectDialog.table != '') {
                    axios.get(window.contextPath + '/api/getTable', {
                        params: {
                            schema: this.remoteSelectDialog.schema,
                            table: this.remoteSelectDialog.table
                        }
                    }).then(res => {
                        if (res.data.status == 0) {
                            this.remoteSelectDialog.columns = res.data.content.table.columns
                        }
                        this.remoteSelectDialog = JSON.parse(JSON.stringify(this.remoteSelectDialog))
                    }).catch(res => {
                        console.error(res)
                        this.$message.error('服务异常');
                    })
                }
            },
            closeRemoteSelectDialog() {
                if (this.remoteSelectDialog.db && this.remoteSelectDialog.db.length > 0) {
                    let data = this
                    for (let i = 0; i < this.remoteSelectDialog.db.length; i ++) {
                        data = data[this.remoteSelectDialog.db[i]]
                    }
                    if (typeof this.remoteSelectDialog.schema == 'undefined'
                            || typeof this.remoteSelectDialog.table == 'undefined'
                            || typeof this.remoteSelectDialog.keyColumn == 'undefined'
                            || typeof this.remoteSelectDialog.valueColumn == 'undefined'
                            || this.remoteSelectDialog.schema == null
                            || this.remoteSelectDialog.table == null
                            || this.remoteSelectDialog.keyColumn == null
                            || this.remoteSelectDialog.valueColumn == null
                            || this.remoteSelectDialog.schema == ''
                            || this.remoteSelectDialog.table == ''
                            || this.remoteSelectDialog.keyColumn == ''
                            || this.remoteSelectDialog.valueColumn == '') {
                        delete data.judgeType
                        delete data.elType
                        delete data.format
                        delete data.schema
                        delete data.table
                        delete data.keyColumn
                        delete data.valueColumn
                        delete data.className
                        delete data.columnType
                        delete data.canEdit
                        delete data.size
                        delete data.clearable
                        delete data.rule
                        this.form = JSON.parse(JSON.stringify(this.form))
                    }
                }
                this.remoteSelectDialog = {
                    visible: false,
                    db: []
                }
            },
            searchTypeChange(item,db) {
                delete item.judgeType
                delete item.elType
                delete item.format
                delete item.schema
                delete item.table
                delete item.keyColumn
                delete item.valueColumn
                delete item.options
                if (item.className) {
                    if (item.className.indexOf('.SearchSelectRemote') > -1) {
                        item.judgeType = 'eq'
                        item.elType = 'SELECT'
                        this.remoteSelectDialog = {
                            visible: true,
                            db: db
                        }
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.SearchSelect') > -1) {
                        item.judgeType = 'eq'
                        item.elType = 'SELECT'
                        this.selectDialog = {
                            visible: true,
                            options: [],
                            db: db,
                            key: 'options'
                        }
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.SearchInputEq') > -1) {
                        item.judgeType = 'eq'
                        item.elType = 'INPUT'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.SearchInputLike') > -1) {
                        item.judgeType = 'like'
                        item.elType = 'INPUT'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.SearchDatePickerBt') > -1) {
                        item.judgeType = 'bt'
                        item.elType = 'DATETIME_PICKER'
                        item.format = 'yyyy-MM-dd'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.SearchDatetimePickerBt') > -1) {
                        item.judgeType = 'bt'
                        item.elType = 'DATETIME_PICKER'
                        item.format = 'yyyy-MM-dd HH:mm:ss'
                        this.form = JSON.parse(JSON.stringify(this.form))
                    }
                } else {
                    delete item.className
                    this.form = JSON.parse(JSON.stringify(this.form))
                }
            },
            addSearchColumn() {
                if (this.searchColumnDialog.value) {
                    let vvv = this.searchColumnDialog.value.split('#')
                    let schema = vvv[0]
                    let table = vvv[1]
                    let key = vvv[2]
                    let alias = vvv[3]
                    let data = this
                    for (let i = 0; i < this.searchColumnDialog.db.length; i ++) {
                        data = data[this.searchColumnDialog.db[i]]
                    }
                    if (data.select.alias == alias) {
                        if (typeof data.select.searchElements == 'undefined') {
                            data.select.searchElements = []
                        }
                        data.select.searchElements.push({
                            alias: alias,
                            key: key,
                            className: '',
                            clearable: true,
                            show: true,
                            size: 'small',
                            width: 150
                        })
                    } else if (data.select.leftJoins && data.select.leftJoins.length > 0) {
                        for (let i = 0; i < data.select.leftJoins.length; i ++) {
                            if (data.select.leftJoins[i].alias == alias) {
                                if (typeof data.select.leftJoins[i].searchElements == 'undefined') {
                                    data.select.leftJoins[i].searchElements = []
                                }
                                data.select.leftJoins[i].searchElements.push({
                                    alias: alias,
                                    key: key,
                                    className: '',
                                    clearable: true,
                                    show: true,
                                    size: 'small',
                                    width: 150
                                })
                                break;
                            }
                        }
                    }
                    this.form = JSON.parse(JSON.stringify(this.form))
                }
                this.closeSearchColumnDialog()
            },
            closeSearchColumnDialog() {
                this.searchColumnDialog = {
                    visible: false,
                    columns: [],
                    value: '',
                    db: []
                }
            },
            showAddSearchColumn(columns, db) {
                this.searchColumnDialog = {
                    visible: true,
                    columns: JSON.parse(JSON.stringify(columns)),
                    value: '',
                    db: db
                }
            },
            editWhereInValues(item) {
                let inputValue = item.values.join(',')
                this.$prompt('请输入查询区间配置', '多个值之间使用英文逗号分隔', {
                    confirmButtonText: '确定',
                    cancelButtonText: '删除',
                    inputValue: inputValue
                }).then(({ value }) => {
                    if (value == null || typeof value == 'undefined' || value.trim() == '') {
                        delete item.type
                        delete item.className
                        delete item.values
                    } else {
                        item.values = value.trim().split(',')
                    }
                    this.form = JSON.parse(JSON.stringify(this.form))
                }).catch(() => {
                    delete item.type
                    delete item.className
                    delete item.values
                    this.form = JSON.parse(JSON.stringify(this.form))
                });
            },
            whereTypeChange(item) {
                delete item.type
                delete item.value
                delete item.values
                delete item.begin
                delete item.end
                if (item.className) {
                    if (item.className.indexOf('.WhereEq') > -1) {
                        item.type = 'eq'
                        item.value = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereGteq') > -1) {
                        item.type = 'gteq'
                        item.value = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereGt') > -1) {
                        item.type = 'gt'
                        item.value = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereLteq') > -1) {
                        item.type = 'lteq'
                        item.value = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereLt') > -1) {
                        item.type = 'lt'
                        item.value = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereBt') > -1) {
                        item.type = 'bt'
                        item.begin = ''
                        item.end = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereLike') > -1) {
                        item.type = 'like'
                        item.value = ''
                        this.form = JSON.parse(JSON.stringify(this.form))
                    } else if (item.className.indexOf('.WhereIn') > -1) {
                        item.type = 'in'
                        item.values = []
                        this.$prompt('请输入查询区间配置', '多个值之间使用英文逗号分隔', {
                            confirmButtonText: '确定',
                            cancelButtonText: '取消'
                        }).then(({ value }) => {
                            if (value == null || typeof value == 'undefined' || value.trim() == '') {
                                delete item.type
                                delete item.className
                                delete item.values
                            } else {
                                item.values = value.trim().split(',')
                            }
                            this.form = JSON.parse(JSON.stringify(this.form))
                        }).catch(() => {
                            delete item.type
                            delete item.className
                            delete item.values
                            this.form = JSON.parse(JSON.stringify(this.form))
                        });
                    }
                } else {
                    delete item.className
                    this.form = JSON.parse(JSON.stringify(this.form))
                }
            },
            addWhereColumn() {
                if (this.whereColumnDialog.value) {
                    let vvv = this.whereColumnDialog.value.split('#')
                    let schema = vvv[0]
                    let table = vvv[1]
                    let key = vvv[2]
                    let alias = vvv[3]
                    let data = this
                    for (let i = 0; i < this.whereColumnDialog.db.length; i ++) {
                        data = data[this.whereColumnDialog.db[i]]
                    }
                    if (data.select.alias == alias) {
                        if (typeof data.select.wheres == 'undefined') {
                            data.select.wheres = []
                        }
                        data.select.wheres.push({
                            key: key,
                            className: ''
                        })
                    } else if (data.select.leftJoins && data.select.leftJoins.length > 0) {
                        for (let i = 0; i < data.select.leftJoins.length; i ++) {
                            if (data.select.leftJoins[i].alias == alias) {
                                if (typeof data.select.leftJoins[i].wheres == 'undefined') {
                                    data.select.leftJoins[i].wheres = []
                                }
                                data.select.leftJoins[i].wheres.push({
                                    key: key,
                                    className: ''
                                })
                                break;
                            }
                        }
                    }
                    this.form = JSON.parse(JSON.stringify(this.form))
                }
                this.closeWhereColumnDialog()
            },
            closeWhereColumnDialog() {
                this.whereColumnDialog = {
                    visible: false,
                    columns: [],
                    value: '',
                    db: []
                }
            },
            showAddWhereColumn(columns, db) {
                this.whereColumnDialog = {
                    visible: true,
                    columns: JSON.parse(JSON.stringify(columns)),
                    value: '',
                    db: db
                }
            },
            up(item, index, elements) {
                elements[index] = elements.splice(index - 1, 1, elements[index])[0];
            },
            down(item, index, elements) {
                elements[index] = elements.splice(index + 1, 1, elements[index])[0];
            },
            removeTableColumn(item, index, table) {
                table.columns.splice(index, 1)
                let b = false
                for (let i = 0; i < table.select.columns.length; i ++) {
                    let asa = table.select.columns[i];
                    if (asa == item.key + ' as ' + item.prop) {
                        table.select.columns.splice(i, 1)
                        b = true
                        break
                    }
                }
                if (!b) {
                    if (table.select.leftJoins && table.select.leftJoins.length > 0) {
                        for (let i = 0; i < table.select.leftJoins.length; i ++) {
                            for (let j = 0; j < table.select.leftJoins[i].columns.length; j ++) {
                                let asa = table.select.leftJoins[i].columns[j];
                                if (asa == item.key + ' as ' + item.prop) {
                                    table.select.leftJoins[i].columns.splice(j, 1)
                                    break
                                }
                            }
                        }
                    }
                }
            },
            justRemove(item, index, elements) {
                elements.splice(index, 1)
            },
            deleteFormatterTextDialog(item, db) {
                let data = this
                for (let i = 0; i < db.length; i ++) {
                    data = data[db[i]]
                }
                delete data.formatter
                this.form = JSON.parse(JSON.stringify(this.form))
            },
            showFormatterTextDialog(item,db) {
                let map = []
                for(let key  in item.formatter.map){
                    map.push({
                        key: key,
                        value: item.formatter.map[key]
                    })
                }
                this.formatterTextDialog = {
                    visible: true,
                    map: map,
                    db: db
                }
            },
            removeFormatterText(index) {
                this.formatterTextDialog.map.splice(index, 1)
            },
            pushFormatterText() {
                this.formatterTextDialog.map.push({})
            },
            confirmFormatterText(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        this.closeFormatterTextDialog()
                    }
                })
            },
            closeFormatterTextDialog() {
                let mm = {}
                let b = false
                for (let i = 0; i < this.formatterTextDialog.map.length; i ++) {
                    let m = this.formatterTextDialog.map[i]
                    if (m.key && m.value) {
                        mm[m.key] = m.value
                        b = true
                    }
                }
                let data = this
                for (let i = 0; i < this.formatterTextDialog.db.length; i ++) {
                    data = data[this.formatterTextDialog.db[i]]
                }
                if (b) {
                    data.formatter.map = mm
                } else {
                    delete data.formatter
                }
                this.formatterTextDialog = {
                    visible: false,
                    map: []
                }
            },
            formatterTypeChange(item,db) {
                if (!item.formatter) {
                    delete item.formatter
                } else {
                    delete item.formatter.active
                    delete item.formatter.inactive
                    delete item.formatter.target
                    delete item.formatter.text
                    delete item.formatter.map
                    if (item.formatter.type == 'SWITCH') {
                        item.formatter.active = {}
                        item.formatter.inactive = {}
                    } else if (item.formatter.type == 'TEXT') {
                        item.formatter.map = {}
                        this.formatterTextDialog = {
                            visible: true,
                            map: [],
                            db: db
                        }
                    }
                }
                this.form = JSON.parse(JSON.stringify(this.form))
            },
            addTableColumn() {
                if (this.tableColumnDialog.value) {
                    let validate = ''
                    let vvv = this.tableColumnDialog.value.split('#')
                    let schema = vvv[0]
                    let table = vvv[1]
                    let key = vvv[2]
                    let alias = vvv[3]
                    let data = this
                    for (let i = 0; i < this.tableColumnDialog.db.length; i ++) {
                        data = data[this.tableColumnDialog.db[i]]
                        if (i == 1) {
                            validate = this.tableColumnDialog.db[i]
                        } else if (i > 1) {
                            validate = validate + '.' + this.tableColumnDialog.db[i]
                        }
                    }
                    if (data.select.alias == alias) {
                        if (data.select.columns.indexOf(key + ' as ' + alias + '_' + key) > -1) {
                            this.$message.warning('已添加');
                            return
                        } else {
                            if (typeof data.columns == 'undefined') {
                                data.columns = []
                            }
                            data.columns.push({
                                key: key,
                                prop: alias + '_' + key,
                                sortable: false
                            })
                            data.select.columns.push(key + ' as ' + alias + '_' + key)
                        }
                    } else if (data.select.leftJoins && data.select.leftJoins.length > 0) {
                        for (let i = 0; i < data.select.leftJoins.length; i ++) {
                            if (data.select.leftJoins[i].alias == alias) {
                                if (data.select.leftJoins[i].columns.indexOf(key + ' as ' + alias + '_' + key) > -1) {
                                    this.$message.warning('已添加');
                                    return
                                } else {
                                    if (typeof data.columns == 'undefined') {
                                        data.columns = []
                                    }
                                    data.columns.push({
                                        key: key,
                                        prop: alias + '_' + key,
                                        sortable: false
                                    })
                                    data.select.leftJoins[i].columns.push(key + ' as ' + alias + '_' + key)
                                    break;
                                }
                            }
                        }
                    }
                    this.form = JSON.parse(JSON.stringify(this.form))
                    this.$refs.form.validateField(validate + '.columns');
                }
                this.closeAddTableColumnDialog()
            },
            closeAddTableColumnDialog() {
                this.tableColumnDialog = {
                    visible: false,
                    columns: [],
                    value: '',
                    db: []
                }
            },
            showAddTableColumn(columns, db) {
                let data = this
                for (let i = 0; i < db.length; i ++) {
                    data = data[db[i]]
                }
                let exs = []
                if (data.columns && data.columns.length > 0) {
                    for (let i = 0;i < data.columns.length; i ++) {
                        exs.push(data.columns[i].key + ' as ' + data.columns[i].prop)
                    }
                }
                let col = []
                for (let i = 0; i < columns.length; i ++) {
                    let column = columns[i]
                    let co = {
                        schema: column.schema,
                        table: column.table,
                        primaryKey: column.primaryKey,
                        options: []
                    }
                    for (let j = 0; j < column.options.length; j ++) {
                        let index = exs.indexOf(column.options[j].key + ' as ' + column.options[j].alias + '_' + column.options[j].key)
                        if (index == -1) {
                            co.options.push({
                                key: column.options[j].key,
                                dataType: column.options[j].dataType,
                                schema: column.options[j].schema,
                                table: column.options[j].table,
                                alias: column.options[j].alias
                            })
                        }
                    }
                    col.push(co)
                }
                this.tableColumnDialog = {
                    visible: true,
                    columns: col,
                    value: '',
                    db: db
                }
            },
            defaultSortColumnChange(table) {
                if (table.defaultSortColumn == '') {
                    delete table.defaultSortColumn
                }
                delete table.defaultOrder
            },
            init(mainDb, followDbs) {
                let alias = 'a'
                window.vue.mainDb = mainDb
                window.vue.followDbs = followDbs
                window.vue.aliasTable[alias] = {
                    schema: mainDb.schema,
                    table: mainDb.table
                }
                window.vue.form.table.select = {
                    alias: alias,
                    primaryKey: mainDb.primaryKey,
                    schema: mainDb.schema,
                    table: mainDb.table,
                    columns: [],
                    searchElements: []
                }
                let column = {
                    schema: mainDb.schema,
                    table: mainDb.table,
                    primaryKey: mainDb.primaryKey,
                    options: []
                }
                for (let i = 0; i < mainDb.columns.length; i ++) {
                    column.options.push({
                        key: mainDb.columns[i].name,
                        dataType: mainDb.columns[i].type,
                        schema: mainDb.schema,
                        table: mainDb.table,
                        alias: alias
                    })
                }
                window.vue.mainColumns.push(column)
                if (mainDb.follows && mainDb.follows.length > 0) {
                    window.vue.form.table.select.leftJoins = []
                    for (let i = 0; i < mainDb.follows.length; i ++) {
                        alias = String.fromCharCode(alias.charCodeAt() + 1)
                        window.vue.aliasTable[alias] = {
                            table: mainDb.follows[i].table,
                            schema: mainDb.follows[i].schema,
                        }
                        window.vue.form.table.select.leftJoins.push({
                            alias: alias,
                            table: mainDb.follows[i].table,
                            schema: mainDb.follows[i].schema,
                            parentKey: mainDb.follows[i].parentKey,
                            relateKey: mainDb.follows[i].relateKey,
                            columns: []
                        })

                        let followColumn = {
                            schema: mainDb.follows[i].schema,
                            table: mainDb.follows[i].table,
                            primaryKey: mainDb.follows[i].primaryKey,
                            options: []
                        }
                        for (let j = 0; j < mainDb.follows[i].columns.length; j ++) {
                            followColumn.options.push({
                                key: mainDb.follows[i].columns[j].name,
                                dataType: mainDb.follows[i].columns[j].type,
                                schema: mainDb.follows[i].schema,
                                table: mainDb.follows[i].table,
                                alias: alias
                            })
                        }
                        window.vue.mainColumns.push(followColumn)
                    }
                }
                if (followDbs && followDbs.length > 0) {
                    window.vue.form.follow_tables = []
                    alias = 'a'
                    for (let i = 0; i < followDbs.length; i ++) {
                        let followAliasTable = {}
                        followAliasTable[alias] = {
                            schema: followDbs[i].schema,
                            table: followDbs[i].table
                        }
                        let follow = {
                            pagination: false,
                            add_btn: false,
                            edit_btn: false,
                            delete_btn: false,
                            relateKey: followDbs[i].relateKey,
                            parentKey: followDbs[i].parentKey,
                            select: {
                                alias: alias,
                                primaryKey: followDbs[i].primaryKey,
                                schema: followDbs[i].schema,
                                table: followDbs[i].table,
                                columns: [],
                                searchElements: []
                            }
                        }
                        let followColumns = []
                        let column = {
                            schema: followDbs[i].schema,
                            table: followDbs[i].table,
                            primaryKey: followDbs[i].primaryKey,
                            options: []
                        }
                        for (let j = 0; j < followDbs[i].columns.length; j ++) {
                            column.options.push({
                                key: followDbs[i].columns[j].name,
                                dataType: followDbs[i].columns[j].type,
                                schema: followDbs[i].schema,
                                table: followDbs[i].table,
                                alias: alias
                            })
                        }
                        followColumns.push(column)
                        let followDb = followDbs[i]
                        if (followDb.follows && followDb.follows.length > 0) {
                            follow.select.leftJoins = []
                            for (let k = 0; k < followDb.follows.length; k ++) {
                                alias = String.fromCharCode(alias.charCodeAt() + 1)
                                followAliasTable[alias] = {
                                    schema: followDb.follows[i].schema,
                                    table: followDb.follows[i].table
                                }
                                follow.select.leftJoins.push({
                                    alias: alias,
                                    table: followDb.follows[i].table,
                                    schema: followDb.follows[i].schema,
                                    parentKey: followDb.follows[i].parentKey,
                                    relateKey: followDb.follows[i].relateKey,
                                    columns: []
                                })
                                let followColumn = {
                                    schema: followDb.follows[i].schema,
                                    table: followDb.follows[i].table,
                                    primaryKey: followDb.follows[i].primaryKey,
                                    options: []
                                }
                                for (let j = 0; j < followDb.follows[i].columns.length; j ++) {
                                    followColumn.options.push({
                                        key: followDb.follows[i].columns[j].name,
                                        dataType: followDb.follows[i].columns[j].type,
                                        schema: followDb.follows[i].schema,
                                        table: followDb.follows[i].table,
                                        alias: alias
                                    })
                                }
                                followColumns.push(followColumn)
                            }
                        }
                        window.vue.followActiveNames.push({
                            activeNames: []
                        })
                        window.vue.form.follow_tables.push(follow)
                        window.vue.followColumns.push(followColumns)
                        window.vue.followAliasTable.push(followAliasTable)
                    }
                }
                window.vue.form = JSON.parse(JSON.stringify(window.vue.form))
            }
        },
        created: function () {
            let id = getParam("id")
            if (id) {
                this.loading = true;
                axios.get(window.contextPath + '/api/getJson', {
                    params: {
                        id: id
                    }
                }).then(res => {
                    if (res.data.status != 0) {
                        this.$message.error(res.data.msg);
                        this.loading = false;
                    } else {
                        this.form = res.data.content.json
                        this.loading = false;
                    }
                }).catch(res => {
                    console.error(res)
                    this.$message.error('服务异常');
                    this.loading = false;
                })
            }

            this.addElementShows[window.basePackage + 'form.add.AddInput'] = ['label','placeholder','clearable','size','width','rule','type','maxlength','minlength','canEdit']
            this.addElementShows[window.basePackage + 'form.add.AddSelect'] = ['label','placeholder','clearable','size','width','rule','canEdit','select']
            this.addElementShows[window.basePackage + 'form.add.AddSelectRemote'] = ['label','placeholder','clearable','size','width','rule','canEdit','remoteSelect']
            this.addElementShows[window.basePackage + 'form.add.AddRadio'] = ['label','size','rule','canEdit','radio']
            this.addElementShows[window.basePackage + 'form.add.AddInputNumber'] = ['label','size','width','rule','min','max','precision','step','canEdit']
            this.addElementShows[window.basePackage + 'form.add.AddDatePicker'] = ['label','to','placeholder','clearable','size','width','rule','canEdit']
            this.addElementShows[window.basePackage + 'form.add.AddDateTimePicker'] = ['label','to','placeholder','clearable','size','width','rule','canEdit']
            this.addElementShows[window.basePackage + 'form.add.AddTimePicker'] = ['label','placeholder','clearable','size','width','rule','start','end','step','canEdit']
            this.addElementShows[window.basePackage + 'form.add.AddUploadPic'] = ['label','placeholder','acceptType','limitSize','rule','canEdit']
            this.addElementShows[window.basePackage + 'form.add.AddRich'] = ['label','maxlength','rule']
            this.addElementShows[window.basePackage + 'form.add.AddCreateDateTime'] = []
            this.addElementShows[window.basePackage + 'form.add.AddUpdateDateTime'] = []
            window.setInterval(() => {
                this.dialogTop = (window.parent.ScollPostion().top + 30) + 'px'
            }, 100)

            window.setInterval(() => {
                let configStr = JSON.stringify(this.form)
                localStorage.setItem('config', [configStr])
            }, 100)
        }
    })
</script>
</html>