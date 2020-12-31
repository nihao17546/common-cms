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
    </style>
</head>
<body>
<div id="app" v-loading="loading">
    <el-dialog
            title="预览"
            :visible.sync="previewVisible" :before-close="closePreview">
        <pre>{{form}}</pre>
    </el-dialog>
    <el-form :model="form" :rules="rules" ref="form" size="small" v-if="mainDb">
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
                    <el-select style="width: 100%" v-model="form.add_btn">
                        <el-option :key="true" label="是" :value="true"></el-option>
                        <el-option :key="false" label="否" :value="false"></el-option>
                    </el-select>
                </el-form-item>
            </el-col>
            <el-col :span="6">
                <el-form-item label="允许编辑:" prop="edit_btn" label-width="100px">
                    <el-select style="width: 100%" v-model="form.edit_btn">
                        <el-option :key="true" label="是" :value="true"></el-option>
                        <el-option :key="false" label="否" :value="false"></el-option>
                    </el-select>
                </el-form-item>
            </el-col>
            <el-col :span="6">
                <el-form-item label="允许删除:" prop="delete_btn" label-width="100px">
                    <el-select style="width: 100%" v-model="form.delete_btn">
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
                                                               @change="formatterTypeChange(item,index)">
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
                                                    <el-button type="text" plain @click="showFormatterTextDialog(item,index)">修改</el-button>
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
                                                                   @change="whereTypeChange(item,index)">
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
                                                                           @change="whereTypeChange(item,index)">
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
                            <el-col :span="24">
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
                </el-collapse>
            </el-col>
        </el-row>
        <div style="text-align: right;margin-top: 8px;">
            <el-button type="success" @click="preview">预览</el-button>
            <el-button type="primary" @click="submit">确认</el-button>
        </div>
    </el-form>



    <el-dialog title="添加列" :visible.sync="tableColumnDialog.visible" class="group-dialog" :before-close="closeAddTableColumnDialog">
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

    <el-dialog title="文本格式化" :visible.sync="formatterTextDialog.visible" class="group-dialog" :before-close="closeFormatterTextDialog">
        <div style="margin-bottom: 5px;text-align: left;">
            <el-button type="primary" plain size="mini" @click="pushFormatterText">添加</el-button>
        </div>
        <div v-for="(item,index) in formatterTextDialog.map">
            <el-row :gutter="24">
                <el-col :span="10">
                    <el-input size="small" placeholder="源数据" v-model.trim="item.key"></el-input>
                </el-col>
                <el-col :span="10">
                    <el-input size="small" placeholder="外显文案" v-model.trim="item.value"></el-input>
                </el-col>
                <el-col :span="4">
                    <el-button type="danger" plain size="mini" @click="removeFormatterText(index)">移除</el-button>
                </el-col>
            </el-row>
        </div>
    </el-dialog>

    <el-dialog title="默认搜索条件" :visible.sync="whereColumnDialog.visible" class="group-dialog" :before-close="closeWhereColumnDialog">
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

    <el-dialog title="添加搜索表单项" :visible.sync="searchColumnDialog.visible" class="group-dialog" :before-close="closeSearchColumnDialog">
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

    <el-dialog title="远程下拉菜单配置" :visible.sync="remoteSelectDialog.visible" class="group-dialog" :before-close="closeRemoteSelectDialog">
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
            <el-form-item label="外显字段:" label-width="100px" prop="keyColumn"
                          :rules="[{required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model.trim="remoteSelectDialog.keyColumn" placeholder="请选择外显字段" size="small" style="width: 100%">
                    <el-option v-for="column in remoteSelectDialog.columns"
                               :key="column.name"
                               :label="'列名:' + column.name + '   类型:' + column.type"
                               :value="column.name">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="值字段:" label-width="100px" prop="valueColumn"
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

    <el-dialog title="下拉菜单选项" :visible.sync="selectDialog.visible" class="group-dialog" :before-close="closeSelectDialog">
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
</div>
</body>
<script>
    window.contextPath = '${contextPath}'
    window.basePackage = '${basePackage}'
    // window.setInterval(() => {
    //     window.parent.document.getElementById("basic").height = Math.max(document.getElementById("app").offsetHeight + 15, 500)
    // }, 200)

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
                        callback(new Error('格式要求正整数'));
                    }
                }
            };
            return {
                loading: false,
                height: window.innerHeight - 78,
                activeNames: [],
                previewVisible: false,
                aliasTable: {},
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
                },
                mainColumns: [],
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
                }]
            }
        },
        methods: {
            preview() {
                this.previewVisible = true
            },
            closePreview() {
                this.previewVisible = false
            },
            submit() {
                this.$refs['form'].validate((valid) => {
                    if (valid) {
                        alert(1)
                    } else {
                        alert(0)
                    }
                });
            },
            editSelect(item, db) {
                let options = []
                if (item.options) {
                    options = JSON.parse(JSON.stringify(item.options))
                }
                this.selectDialog = {
                    visible: true,
                    options: options,
                    db: db
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
                    if (typeof data.options == 'undefined') {
                        data.options = []
                    }
                    data.options = mm
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
                            db: db
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
            whereTypeChange(item, index) {
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
            showFormatterTextDialog(item,index) {
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
                    index: index
                }
            },
            removeFormatterText(index) {
                this.formatterTextDialog.map.splice(index, 1)
            },
            pushFormatterText() {
                this.formatterTextDialog.map.push({})
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
                if (b) {
                    this.form.table.columns[this.formatterTextDialog.index].formatter.map = mm
                } else {
                    delete this.form.table.columns[this.formatterTextDialog.index].formatter
                }
                this.formatterTextDialog = {
                    visible: false,
                    map: []
                }
            },
            formatterTypeChange(item,index) {
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
                            index: index
                        }
                    }
                }
                this.form = JSON.parse(JSON.stringify(this.form))
            },
            addTableColumn() {
                if (this.tableColumnDialog.value) {
                    let vvv = this.tableColumnDialog.value.split('#')
                    let schema = vvv[0]
                    let table = vvv[1]
                    let key = vvv[2]
                    let alias = vvv[3]
                    let data = this
                    for (let i = 0; i < this.tableColumnDialog.db.length; i ++) {
                        data = data[this.tableColumnDialog.db[i]]
                    }
                    if (data.select.alias == alias) {
                        if (data.select.columns.indexOf(key + ' as ' + alias + '_' + key) > -1) {
                            this.$message.warning('已添加');
                            return
                        } else {
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
                    this.$refs.form.validateField("table.columns");
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
                this.tableColumnDialog = {
                    visible: true,
                    columns: JSON.parse(JSON.stringify(columns)),
                    value: '',
                    db: db
                }
            },
            defaultSortColumnChange(table) {
                delete table.defaultOrder
            },
            init(mainDb, followDbs) {
                window.vue.mainDb = mainDb
                window.vue.followDbs = followDbs
                window.vue.aliasTable['a'] = {
                    schema: mainDb.schema,
                    table: mainDb.table
                }
                window.vue.form.table.select = {
                    alias: 'a',
                    primaryKey: mainDb.primaryKey,
                    schema: mainDb.schema,
                    table: mainDb.table,
                    columns: [],
                    searchElements: []
                }
                let column = {
                    schema: mainDb.schema,
                    table: mainDb.table,
                    options: []
                }
                for (let i = 0; i < mainDb.columns.length; i ++) {
                    column.options.push({
                        key: mainDb.columns[i].name,
                        dataType: mainDb.columns[i].type,
                        schema: mainDb.schema,
                        table: mainDb.table,
                        alias: 'a'
                    })
                }
                window.vue.mainColumns.push(column)
                if (mainDb.follows && mainDb.follows.length > 0) {
                    window.vue.form.table.select.leftJoins = []
                    for (let i = 0; i < mainDb.follows.length; i ++) {
                        window.vue.aliasTable['a' + i] = {
                            table: mainDb.follows[i].table,
                            schema: mainDb.follows[i].schema,
                        }
                        window.vue.form.table.select.leftJoins.push({
                            alias: 'a' + i,
                            table: mainDb.follows[i].table,
                            schema: mainDb.follows[i].schema,
                            parentKey: mainDb.follows[i].parentKey,
                            relateKey: mainDb.follows[i].relateKey,
                            columns: []
                        })

                        let followColumn = {
                            schema: mainDb.follows[i].schema,
                            table: mainDb.follows[i].table,
                            options: []
                        }
                        for (let j = 0; j < mainDb.follows[i].columns.length; j ++) {
                            followColumn.options.push({
                                key: mainDb.follows[i].columns[j].name,
                                dataType: mainDb.follows[i].columns[j].type,
                                schema: mainDb.follows[i].schema,
                                table: mainDb.follows[i].table,
                                alias: 'a' + i
                            })
                        }
                        window.vue.mainColumns.push(followColumn)
                    }
                }
            }
        },
        created: function () {
        }
    })
</script>
</html>